#!/bin/bash
#At the beginning written with capital P. After a while put to lower case
version=Pochoir_v0.5

#Get Pochoir
if [ -a "$version.tar.bz2" ]; then
rm $version.tar.bz2;
fi
wget http://people.csail.mit.edu/yuantang/$version.tar.bz2

#extract Pochoir and get rid of directory tree
tar xvf $version.tar.bz2

#put to lower case
version=${version,,}
mv home/yuantang/SuperTech/Pochoir/Release_v0.5 $version
rm -r home/ #Pay attention NOT to use"/home/"
cd $version

#Compile Pochoir
make
