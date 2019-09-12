#!/bin/bash

if [ "$1" == "" ]
then
echo "Modo de usar: $0 meuapkalterado.apk"
else
echo "Digite um nome simples para o arquivo:"
read nome
echo "Digite uma senha com pelo menos 8 caracteres ex:minhasenha"
read senha

keytool -genkey -keystore $nome.jks -storepass $senha -storetype jks -alias $nome -keyalg rsa -dname "CN=DESEC" -keypass $senha
jarsigner -keystore $nome.jks -storepass $senha -storetype jks -sigalg sha1withrsa -digestalg sha1 $1 $nome
jarsigner -verify -certs -verbose $1
fi
