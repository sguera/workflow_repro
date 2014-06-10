#!/bin/bash
version=patus-0.1.3

#check if version is already downloaded and delete it if it is
if [ -a "$version.zip" ]; then
    rm $version.zip;
fi

#Downlaod Patus
wget http://patus.googlecode.com/files/$version.zip

#Extract Patus
if [ -d "patus" ]; then
    rm -r patus
fi

unzip patus-0.1.3.zip
mv Patus patus
