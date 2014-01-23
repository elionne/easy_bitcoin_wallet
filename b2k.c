/* gcc b2k.c -g -o b2k -lcrypto -Wall */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <limits.h>
#include <openssl/evp.h>
#include <openssl/ecdsa.h>
#include <openssl/obj_mac.h>

unsigned char crypted_master_key[48]  = { 0 };
unsigned char crypted_private_key[48] = { 0 };
unsigned char public_key[65]          = { 0 };
unsigned char founded_public_key[32]  = { 0 };
unsigned char master_key[32]          = { 0 };
unsigned char private_key[32]         = { 0 };


/* private key (from https://en.bitcoin.it/wiki/Wallet_import_format)
  0C28FCA386C7A227600B2FE50B7CAE11EC86D3BF1FBE471BE89827E19D72AA1D
  
*/

static struct {
    int generate_key_iv_only;
    int derivation_count;
    int public_from_private_only;
    int decrypt, encrypt;
    int compressed_format;

    unsigned char key[32];
    int key_set;

    unsigned char iv[16];
    int iv_set;

    unsigned char salt[8];
    int salt_set;

    unsigned char private_key[32];
    int private_key_set;

    unsigned char public_key[65];
    int public_key_set;

    unsigned char master_key[32];
    int master_key_set;

    unsigned char crypted_private_key[48];
    int crypted_private_key_set;

    unsigned char crypted_master_key[48];
    int crypted_master_key_set;

} global_options;

void derive_password(const char* password,
                    const unsigned char* salt,
                    const int derivation_count,
                    unsigned char* key,
                    unsigned char* iv)
{
    const EVP_CIPHER *cipher;
    const EVP_MD *dgst;
    
    cipher = EVP_aes_256_cbc();
    if(!cipher) { fprintf(stderr, "no such cipher\n"); abort(); }

    dgst=EVP_get_digestbyname("sha512");
    if(!dgst) { fprintf(stderr, "no such digest\n"); abort(); }

    if(!EVP_BytesToKey(cipher, dgst, salt,
        (unsigned char *) password,
        strlen(password), derivation_count, key, iv))
    {
        fprintf(stderr, "EVP_BytesToKey failed\n");
        abort();
    }  
}

void decrypt_aes(unsigned char* crypted_message,
                 int crypted_message_len,
                 unsigned char* key, 
                 unsigned char* iv,
                 unsigned char* message,
                 int* message_len)
{
    EVP_CIPHER_CTX ctx_cipher;
    EVP_CIPHER_CTX_init(&ctx_cipher);
    
    int len = 0, error = 0;

    error = EVP_DecryptInit_ex(&ctx_cipher, EVP_aes_256_cbc(), NULL, key, iv);  
    error = EVP_DecryptUpdate(&ctx_cipher, message, &len, crypted_message, crypted_message_len);
    
    *message_len = len;
    error = EVP_DecryptFinal_ex(&ctx_cipher, message + len, &len);
    *message_len += len;

    if( error == 0 ){
      printf("Decryption error\n");
      abort();
    }

    EVP_CIPHER_CTX_cleanup(&ctx_cipher);
}

void encrypt_aes(unsigned char* message,
                 int message_len,
                 unsigned char* key,
                 unsigned char* iv,
                 unsigned char* crypted_message,
                 int* crypted_message_len)
{
    EVP_CIPHER_CTX ctx_cipher;
    EVP_CIPHER_CTX_init(&ctx_cipher);

    int len = 0, error = 0;

    error = EVP_EncryptInit_ex(&ctx_cipher, EVP_aes_256_cbc(), NULL, key, iv);
    error = EVP_EncryptUpdate(&ctx_cipher, crypted_message, &len, message, message_len);

    *crypted_message_len = len;
    error = EVP_EncryptFinal_ex(&ctx_cipher, crypted_message + len, &len);
    *crypted_message_len += len;

    if( error == 0 ){
      printf("Encryption error\n");
      abort();
    }

    EVP_CIPHER_CTX_cleanup(&ctx_cipher);
}

void double_sha256(unsigned char* message,
                   int message_len,
                   unsigned char* digest,
                   unsigned int* digest_len)
{
    
    const EVP_MD *sha256 = EVP_get_digestbyname("sha256");
    
    EVP_MD_CTX ctx_md;
    EVP_MD_CTX_init(&ctx_md);
    
    EVP_DigestInit_ex(&ctx_md, sha256, NULL);
    EVP_DigestUpdate(&ctx_md, message, message_len);
    EVP_DigestFinal_ex(&ctx_md, digest, digest_len);
    
    EVP_DigestInit_ex(&ctx_md, sha256, NULL);
    EVP_DigestUpdate(&ctx_md, digest, *digest_len);
    EVP_DigestFinal_ex(&ctx_md, digest, digest_len);
}

void public_key_from_private_key(unsigned char* private_key,
                                 int private_key_len,
                                 unsigned char* public_key, 
                                 int* public_key_len)
{
    EC_KEY *eckey = EC_KEY_new_by_curve_name(NID_secp256k1);
    const EC_GROUP *group = EC_KEY_get0_group(eckey);
    BIGNUM *bn_private_key = BN_bin2bn(private_key, private_key_len, BN_new());
    BN_CTX *ctx = BN_CTX_new();
    EC_POINT *public_key_point = EC_POINT_new(group);  
    
    EC_POINT_mul(group, public_key_point, bn_private_key, NULL, NULL, ctx);

    /* changes convertion compression format */
    point_conversion_form_t compressed_format;
    if( global_options.compressed_format ) {
        compressed_format = POINT_CONVERSION_COMPRESSED;
        *public_key_len = 33;
    }else{
        compressed_format = POINT_CONVERSION_UNCOMPRESSED;
        *public_key_len = 65;
    }
    
    EC_POINT_point2oct(group, public_key_point, compressed_format, public_key, *public_key_len, ctx);
    
    EC_KEY_set_private_key(eckey,bn_private_key);
    EC_KEY_set_public_key(eckey,public_key_point);

    BN_clear_free(bn_private_key);
    EC_POINT_free(public_key_point);
    BN_CTX_free(ctx);
}

inline void print_bin_to_hex(const char* message, const unsigned char* data, int size)
{
    int i;
    printf("(%i) %s", size, message);
    for(i = 0; i < size; ++i)
      printf("%02x", data[i]);
    
    printf("\n");
  
}

unsigned char* hex_to_bin(unsigned char *bin_out, char *hex_in, ssize_t size)
{
    BIGNUM *bn = NULL;
    int error = 0;
    
    error = BN_hex2bn(&bn, hex_in);

    if( error == 0 ){
        bin_out = 0;
        goto errors;
    }

    if( BN_num_bytes(bn) > size ){
        bin_out = 0;
        goto errors;
    }

    BN_bn2bin(bn, bin_out);

errors:
    BN_free(bn);
    return bin_out;
}

int string_to_int_with_check(char* number)
{
    char *endptr, *str = number;
    int val;
    errno = 0;    /* To distinguish success/failure after call */
    val = strtol(str, &endptr, 10);

    /* Check for various possible errors */

    if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN)) ||
        (errno != 0 && val == 0) ||
        (endptr == str))
    {
        perror("Wrong argument.");
        exit(EXIT_FAILURE);
    }

    return val;
}

void usage()
{
    printf(" usage %s [options]\n\n", "./b2k");
    printf("All input are un hexdecimal text without 0x prefix. All internal \n\
size are static, so be carful about each options size.\n");
    
    printf("    -k \n\
            Generates key and iv from password, exit just after. This option \n\
            uses the EVP_BytesToKey of openssl lib with sha512 digest. You can \n\
            set the number of iteration with -C (default is 150000) and salt \n\
            with -S ( default is f71c71c050ab2ec0 ).\n\n");
    
    printf("    -p \n\
            Generates the public key associated to a private key set with -K.\n\n");

    printf("    -e \n\
            Encrypt data.\n\n");
    printf("    -d \n\
            Decrypt data.\n\n");

    printf("    -z \n\
            Print a compressed format of public key. Use with -p.\n\n");

    printf("    -M <master_key> \n");
    printf("    -N <crypted_master_key> \n\
            Sets the master key or crypted master key of aes encryption. \n\
            master_key 32 bytes, and crypted_master_key 48 bytes.\n\n");

    printf("    -K <key> \n\
            Uses with -d and -e to set the key. See -I\n\n");
    
    printf("    -I <iv> \n\
            Uses with -d and -e to set the initialization vector to crypt and\n\
            and decrypt master key ( set with -M ). You can use the password \n\
            generation to internaly generate key and iv instead of use -K and\n\
            -I option. (16 bytes) \n\n");

    printf("    -P <private_key> \n");
    printf("    -Q <crypted_private_key \n\
            Sets the decrypted and crypted bitcoin private key. You crypt and\n\
            decrypt with -e and -d options. private_key 32 bytes, \n\
            crypted_private_key 48 bytes\n\n");
                
    printf("    -C <count> \n\
            Sets the number of iterations to pass to EVP_BytesToKey. \n\
            (default: 150000).\n\n");

    printf("    -S <salt> \n\
            Sets the salt to EVP_BytesToKey. Default salt is f71c71c050ab2ec0.\n\
            Salt is 8 bytes long ( 16 hexa characters).\n\n");

    printf("    -U <public_key> \n\
            Sets the bitcoin public key in hexadecimal. Public is used when \n\
            you want to encrypt or decrypt a private key. Public is double  \n\
            hased to get the iv parameter for aes cipher. (33 or 65 bytes \n\
            depends on format compression\n\n");

}

void parse_options(int argc, char* argv[])
{
    char opt;
    memset(&global_options, 0, sizeof(global_options));
    
    while( (opt = getopt(argc, argv, "hkK:I:C:S:pP:edU:M:Q:N:z")) != -1){
        unsigned char* error;
        switch( opt ){
        case 'K':
            error = hex_to_bin(global_options.key, optarg, sizeof(global_options.key));
            if( error == 0 ){
                printf("Invalid key argument.\n");
                exit(-1);
            }else
                global_options.key_set = 1;
            break;
        case 'I':
            error = hex_to_bin(global_options.iv, optarg, sizeof(global_options.iv));
            if( error == 0 ){
                printf("Invalid iv argument.\n");
                exit(-1);
            }else
                global_options.iv_set = 1;
            break;
        case 'C':
            global_options.derivation_count = string_to_int_with_check(optarg);
            if( global_options.derivation_count == 0 )
                printf("Invalid count argument.\n");
            break;
        case 'S':
            error = hex_to_bin(global_options.salt, optarg, sizeof(global_options.salt));
            if( error == 0 ){
                printf("Invalid salt argument.\n");
                exit(-1);
            }else
                global_options.salt_set = 1;
            break;
        case 'P':
            error = hex_to_bin(global_options.private_key, optarg, sizeof(global_options.private_key));
            if( error == 0 ){
                printf("Invalid private key argument.\n");
                exit(-1);
            }else
                global_options.private_key_set = 1;
            break;
        case 'Q':
            error = hex_to_bin(global_options.crypted_private_key, optarg, sizeof(global_options.crypted_private_key));
            if( error == 0 ){
                printf("Invalid master key argument.\n");
                exit(-1);
            }else
                global_options.crypted_private_key_set = 1;
            break;
        case 'U':
            error = hex_to_bin(global_options.public_key, optarg, sizeof(global_options.public_key));
            if( error == 0 ){
                printf("Invalid public key argument.\n");
                exit(-1);
            }else
                global_options.public_key_set = 1;
            break;
        case 'M':
            error = hex_to_bin(global_options.master_key, optarg, sizeof(global_options.master_key));
            if( error == 0 ){
                printf("Invalid master key argument.\n");
                exit(-1);
            }else
                global_options.master_key_set = 1;
            break;
        case 'N':
            error = hex_to_bin(global_options.crypted_master_key, optarg, sizeof(global_options.crypted_master_key));
            if( error == 0 ){
                printf("Invalid crypted master key argument.\n");
                exit(-1);
            }else
                global_options.crypted_master_key_set = 1;
            break;
        case 'k':
            global_options.generate_key_iv_only = 1;
            if( global_options.public_from_private_only ||
                global_options.encrypt ||
                global_options.decrypt)
            {
                printf("-k option is incompatible with -p, -e and -d options.\n");
                exit(-1);
            }
            break;
        case 'h':
            usage();
            exit(0);
            break;
        case 'p':
            global_options.public_from_private_only = 1;
            if( global_options.generate_key_iv_only ||
                global_options.encrypt ||
                global_options.decrypt)
            {
                printf("-p option is incompatible with -k, -e and -d options.\n");
                exit(-1);
            }
            break;
        case 'e':
            global_options.encrypt = 1;
            if( global_options.decrypt == 1 )
            {
                printf("-e option is incompatible with -d.\n");
                exit(-1);
            }
            break;
        case 'd':
            global_options.decrypt = 1;
            if( global_options.encrypt == 1 )
            {
                printf("-d option is incompatible with -e.\n");
                exit(-1);
            }
            break;
        case 'z':
            global_options.compressed_format = 1;
            break;
            
        default:
            break;
        }
    }

    if( global_options.public_from_private_only == 1 &&
        global_options.private_key_set == 0 ){
            printf("-p option needs a private key\n");
            exit(-1);
    }

    if( global_options.encrypt ){
        if( !global_options.master_key_set && !global_options.private_key_set){
            printf("You must set -P or -M option with -e.\n");
            exit(-1);
        }
        if( global_options.private_key_set == 1 && global_options.public_key_set == 0 ){
            printf("You must set a public key with the option -e and -P.\n");
            exit(-1);
        }
    }

    if( global_options.decrypt ){
        if( !global_options.crypted_master_key_set && !global_options.crypted_private_key_set){
            printf("You must set -Q or -N option with -d.\n");
            exit(-1);
        }
        if( global_options.crypted_private_key_set == 1 && global_options.public_key_set == 0 ){
            printf("You must set a public key with the option -d and -Q.\n");
            exit(-1);
        }
    }

    if( global_options.compressed_format == 1 &&
        global_options.public_from_private_only == 0 )
    {
        printf("-z option must be used with -p option.\n");
        exit(-1);
    }
}

int main(int argc, char *argv[])
{
    unsigned char key[EVP_MAX_KEY_LENGTH], iv[EVP_MAX_IV_LENGTH];
    char password[32];
    unsigned char salt[8] = {0xf7, 0x1c, 0x71, 0xc0, 0x50, 0xab, 0x2e, 0xc0};
    int derivation_count = 150000;

    OpenSSL_add_all_algorithms();
    OpenSSL_add_all_digests();

    parse_options(argc, argv);

    if( global_options.salt_set )
        memcpy(salt, global_options.salt, sizeof(salt));

    if( global_options.key_set )
        memcpy(key, global_options.key, EVP_MAX_KEY_LENGTH);

    if( global_options.iv_set )
        memcpy(iv, global_options.iv, EVP_MAX_IV_LENGTH);

    if( global_options.public_key_set )
        memcpy(public_key, global_options.public_key, sizeof(public_key));

    if( global_options.private_key_set )
        memcpy(private_key, global_options.private_key, 32);

    if( global_options.crypted_master_key_set )
        memcpy(crypted_master_key, global_options.crypted_master_key, sizeof(crypted_master_key));
    
    if( global_options.master_key_set )
        memcpy(master_key, global_options.master_key, sizeof(master_key));

    if( global_options.derivation_count != 0 )
        derivation_count = global_options.derivation_count;

    if( global_options.public_from_private_only != 0 ){            
        int public_key_len;

        print_bin_to_hex("Private Key: ", private_key, 32);
        
        public_key_from_private_key(private_key, 32, public_key, &public_key_len);
        print_bin_to_hex("Public Key: ", public_key, public_key_len);

        exit(0);
    }

    if(  global_options.decrypt || global_options.encrypt ||
        (global_options.key_set == 0 && global_options.iv_set == 0)){
        /* Get passphrase from stdin */
        strncpy(password, getpass("Enter your passphrase: "), sizeof(password));
    }

    if( global_options.master_key_set == 0 ||
        (global_options.key_set == 0 && global_options.iv_set == 0 )){
        /* key and iv from password */
        derive_password(password, salt, derivation_count, key, iv);
    }

    print_bin_to_hex("Key: ", key, 32);
    print_bin_to_hex("IV: ", iv, 16);

    if( global_options.generate_key_iv_only )
        exit(0);

    if( global_options.encrypt == 1 ){
        /* Encrypt master key */
        int crypted_master_key_len;
        encrypt_aes(master_key, sizeof(master_key), key, iv, crypted_master_key, &crypted_master_key_len);
        print_bin_to_hex("Crypted master key: ", crypted_master_key, crypted_master_key_len);

        if( global_options.private_key_set == 0 )
            exit(0);
    }
    
    if( global_options.decrypt ){
        /* Decrypt master key */
        int master_key_len;
        decrypt_aes(crypted_master_key, sizeof(crypted_master_key), key, iv, master_key, &master_key_len);
        print_bin_to_hex("Master Key: ", master_key, master_key_len);

        if( global_options.crypted_private_key_set == 0 )
            exit(0);
    }

    /* == Decrypt private key ==*/
    /* Compute the double sha256 of public key */
    unsigned char db_sha_public_key[EVP_MAX_MD_SIZE];
    unsigned int digest_len;
    
    double_sha256(public_key, sizeof(public_key), db_sha_public_key, &digest_len);
    print_bin_to_hex("Hased public key: ", db_sha_public_key, digest_len);

    if( global_options.decrypt ){
        /* Decrypt private key with master key and double sha256 of public key for iv */
        int private_key_len;
        decrypt_aes(crypted_private_key, sizeof(crypted_private_key), master_key, db_sha_public_key, private_key, &private_key_len);
        print_bin_to_hex("Private Key: ", private_key, private_key_len);

        /* Find public from private key for verification */
        int public_key_len;
        public_key_from_private_key(private_key, private_key_len, founded_public_key, &public_key_len);

        print_bin_to_hex("Public Key: ", public_key, public_key_len);
        print_bin_to_hex("Founded Public Key: ", founded_public_key, public_key_len);

        if( memcmp(public_key, founded_public_key, public_key_len) == 0 )
            printf("Decryption completed, public keys macthes\n");
        else
            printf("Decryption completed, public keys doesn't match. May be your passphrase is wrong. Check also your input data.\n");      
    }

    if( global_options.encrypt ){
        /* Encrypt private key with master key and double sha256 of public key for iv */
        int crypted_private_key_len;
        encrypt_aes(private_key, sizeof(private_key), master_key, db_sha_public_key, crypted_private_key, &crypted_private_key_len);
        print_bin_to_hex("Crypted private Key: ", crypted_private_key, crypted_private_key_len);
    }

    return 0;
}
