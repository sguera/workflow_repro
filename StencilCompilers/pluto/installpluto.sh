#!/bin/bash

#Get the latest release of Pluto
#wget "http://sourceforge.net/projects/pluto-compiler/files/latest/download?source=files" -O Pluto_latest.tar.gz
#Get release 0.10.0 of Pluto
wget "http://sourceforge.net/projects/pluto-compiler/files/pluto-0.10.0.tar.gz//download?source=files" -O Pluto_latest.tar.gz
#extract Pluto
tar xvf Pluto_latest.tar.gz
rm Pluto_latest.tar.gz

#create folder where to install
if [ -d "installed" ]; then
    rm -r installed
fi
mkdir installed

#Compile and install Pluto
cd pluto*
./configure --prefix=$BENCHROOT/StencilCompilers/pluto/installed
make
make test
make install

#Get back to start directory
cd ..
