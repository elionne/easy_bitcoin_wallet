enum_pwgen2 : enum_pwgen2.c
	gcc -g -o enum_pwgen2 enum_pwgen2.c
b2k : b2k.c
	gcc b2k.c -g -o b2k -lcrypto -Wall

all : b2k enum_pwgen2