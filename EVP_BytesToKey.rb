require 'digest'
require 'openssl'
require 'base58'


Base58::ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

def EVP_BytesToKey(password, salt, iterations, digest)
	h = digest.digest password + salt
	(iterations - 1).times do h = Digest::SHA512.digest h end
	return h[0..31], h[32..47]
end

system "stty -echo"
puts "Entrer le mot de passe"
secret = STDIN.gets.chomp
system "stty echo"

#Get key and iv for decryption of master key
salt = ["f71c71c050ab2ec0"].pack("H*")
iterations = 148357
key, iv = EVP_BytesToKey(secret, salt, iterations, Digest::SHA512.new)

puts "Derivated password"
print "Key: ", key.unpack("H*").first, "\n"
print "Iv: ",  iv.unpack("H*").first, "\n"

# decrypt bitcoin master key
decipher = OpenSSL::Cipher.new("AES-256-CBC")

decipher.decrypt
decipher.key = key
decipher.iv = iv

# decrypt bitcoin master key
crypted_master_key = ["00"].pack('H*')
master_key = decipher.update(crypted_master_key) + decipher.final

print "Master key: ", master_key.unpack("H*").first, "\n"

## Bitcoin address data
crypted_private_key = ["00"].pack("H*")
bitcoin_addr = "1Eik1YTkDrF2qB7XHTzBWEkz9CLmxAemVC"
public_key = ["00"].pack("H*")
private_key = "00"
print "Original private key: ", Base58.decode(private_key).to_s(16), "\n"

# decrypt bitcoin private key
decipher = OpenSSL::Cipher.new("AES-256-CBC")

decipher.decrypt
decipher.key = master_key
iv = Digest::SHA256.digest Digest::SHA256.digest public_key
decipher.iv = iv

print "Key: ", master_key.unpack("H*").first, "\n"
print "Iv: ",  iv.unpack("H*").first, "\n"

private_key = decipher.update(crypted_private_key) + decipher.final
print "Private key: ", private_key.unpack("H*").first, "\n"

# Check bitcoin address
hashed_key = "\0" + Digest::RMD160.digest(Digest::SHA256.digest public_key)
checksum = Digest::SHA256.digest Digest::SHA256.digest hashed_key

hashed_key = hashed_key + checksum[0..3]
hashed_key_integer = hashed_key.unpack("H*").first.to_i(16)
print "Reconstitued bitcoin address: ", (hashed_key[0] ? "1" : "") + Base58.encode( hashed_key_integer ), "\n"

# Generate public key from private key
ec = OpenSSL::PKey::EC.new "secp256k1"
group = ec.group
group.point_conversion_form = :compressed
bn_private_key = OpenSSL::BN.new private_key, 2
print bn_private_key.to_s(16), "\n"

point = OpenSSL::PKey::EC::Point.new group
public_key = point.mul( OpenSSL::BN.new("0"), bn_private_key)

ec.private_key = bn_private_key
ec.public_key = public_key

print "Compressed public key: ", public_key.to_bn.to_s(16), "\n"
