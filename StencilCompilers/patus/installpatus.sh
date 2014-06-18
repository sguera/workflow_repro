#!/bin/bash
version=patus-0.1.4
#check if version is already downloaded and delete it if it is
if [ -a "$version.zip" ]; then
    rm $version.zip;
fi

#Downlaod Patus from main repository: available until v0.1.3
#wget http://patus.googlecode.com/files/$version.zip

#Downlaod Patus from mirror repository: here is available the latest version v0.1.4
wget https://github.com/sguera/Patus/raw/master/$version.zip

#Extract Patus
if [ -d "patus" ]; then
    rm -r patus
fi

unzip $version.zip
mv Patus patus
