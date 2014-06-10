#!/bin/bash

set -e

#Download Halide
if [ -a "halide.zip" ]; then
rm halide.zip;
fi

#downlaod Halide

#Newest Version from git
wget https://github.com/halide/Halide/archive/master.zip -O halide.zip

#Relase Version of the 10.03.2014
#wget https://github.com/halide/Halide/releases/download/release_2014_03_10/halide_Linux_64_trunk_d4ae15bcdb08fbfbac82385d535f1e4cf3a04465_2014_03_10.tgz -O halide.tgz

#extract Halide

#If it is a zip
unzip halide.zip

#IF it is a tgz
#tar -C Halide-master -xvf halide.tgz

if [ -d "halide" ]; then
rm -r halide;
fi
mv Halide-master halide
cd halide

#compile
make

#export LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):$(BENCHROOT)/StencilCompilers/Halide/halide/bin

#move back to call directory
cd ..
