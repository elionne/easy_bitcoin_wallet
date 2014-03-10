# Easy bitcoin wallet

Easy bitcoin wallet attempt to be a tool to easy make operations on cryptogric
around the bitcoin wallet. It cannot read entry directly from your wallet
database, it can only encrypt, decrypt hash your passphrase.

The keys to use with Easy bitcoin wallet can be found with the Python program
jackjack-jj/pywallet

# Compilation

~~~
gcc b2k.c -g -o b2k -lcrypto -Wall
~~~

# Usage

Every data are noted in hexadecimal.

Gets the master key from passphrase hashed 150000 times with salt
`f71c71c050ab2ec0`. Only use the [EVP_BytesToKey](https://www.openssl.org/docs/crypto/EVP_BytesToKey.html)
function from openssl.

~~~
./b2k -k S f71c71c050ab2ec0 -C 150000
~~~

To get the public from private keys.

~~~
./b2k -p -P 0C28FCA386C7A227600B2FE50B7CAE11EC86D3BF1FBE471BE89827E19D72AA1D

# Or compressed format

./b2k -p -z -P 0C28FCA386C7A227600B2FE50B7CAE11EC86D3BF1FBE471BE89827E19D72AA1D
~~~

To encrypt your master key with a given key and iv (e.g. SHA-512 of string
"mypassword").

~~~
./b2k -e -M 10eb0150b1e21ddd4cffa3520a3ddad77afb223136c6aef10c24f2f15fbc1309 -K a336f671080fbf4f2a230f313560ddf0d0c12dfcf1741e49e8722a234673037d -I c493caa8d291d8025f71089d63cea809
~~~

Decrypt the result with the same data.

~~~
./b2k -d -N 77de9a6a4f7ec523777e1283df32631da83caa6c46a35ca5059f0dfe2635132c1093872e8e5693a5c9c4a458f7e9037b -K a336f671080fbf4f2a230f313560ddf0d0c12dfcf1741e49e8722a234673037d -I c493caa8d291d8025f71089d63cea809
~~~