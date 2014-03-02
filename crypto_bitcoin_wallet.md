 
# Understand how Bitcoin-Qt encrypt your wallet

I loose my bitcoin wallet password. So decide to investigate how bitcoin-Qt
encrypt wallet to try a brut force my password.

I'm going to try to explain to you how to decrypt your wallet with an known
password. This explation is for people who are expert in cryptography, but it's
a standard procedure to encrypt something. It's more personnal note than a
complete explanation.

The bitcoin wallet it based on AES-256-CBC cipher algorithm and SHA-512 digest.

## Kowns about AES-256 key and iv

An AES-256 needs to parameters to be procedeed. As you imagine, you need a key.
This key is a bug number of 256 bits and it's used for encrypt and decrypt. But
this key is useless if you don't have the iv (initialization vector).

I don't know how excatly AES-256 algorithm but you have to tell where your
algorithm have to start. IV is used with the first data block. IV is also a big
number, in case of bitcoin wallet is 128 bits long.

You can read more about key and iv on [Wikipedia][initialization_vector].

## Encryption step-by-step

### EVP_BytesToKey

First you enter a passphrase. The passphrase is not key. This size is not fixed
and if you use it as a big number (each characters is one byte of the big
number) you reduce considerably the securty.

For that __bitcoin-qt__ (and I think a lot of other) hash your passphrase to
get a pseudo-random big number with a constant size. The hash used is SHA-512.
It's result in a BIG number. First 32 bytes of the hashed passphrase are the key
and next 16 bytes are iv. The to entry point of your AES algorithm.

But the particularity point of bitcoin wallet result in use of
[OpenSSL EVP_BytestoKey][evp_bytestokey] function.

This function do a hash your passphrase with a selected digest, but instead of
hashing just one time, it's hash _n_ times with _n_ equal to a big number. _N_
it depend of your CPU power (_n_ is about 100 000 on my actual compturer).

This method it used to protect from brut force attack, because for each
password you check, you have to calculate _n_ hashes.

You can read the parameters _n_ when you dump your wallet _nDeriveIterations_.
You can also see a _salt_ wich it is a 8 bytes long random number concatenated
to the passphrase during hash process.

The documentation of OpenSSL about EVP_BytestoKey [is wrong][ssleay],
or I mistanderstanding it. You can see below the simplified equivalent
implemantion of EVP_BytestoKey function in [Ruby][ruby].

~~~ruby
def EVP_BytesToKey(password, salt, iterations, digest)
  h = digest.digest password + salt
  (iterations - 1).times { h = Digest::SHA512.digest h }
  return h[0..31], h[32..47]
end
~~~

### Master key encryption

[initialization_vector]: http://en.wikipedia.org/wiki/Initialization_vector
[evp_bytestokey]: http://www.openssl.org/docs/crypto/EVP_BytesToKey.html
[ssleay]: https://github.com/openssl/openssl/blob/master/doc/ssleay.txt#L2332
[ruby]: https://www.ruby-lang.org

