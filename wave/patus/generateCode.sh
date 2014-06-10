#!/bin/bash

#Exit if a command fails
set -e

#Set the Architecture with argument
if [ "$1" != "" ];
then arch=$1;
else arch="x86_64";
fi
echo $arch


#Source Patus Variables
CWD=`pwd`
cd $BENCHROOT/StencilCompilers/patus/patus
source util/patusvars.sh
cd $CWD

#Generate Code
patus --stencil2=src/wave-1.stc --strategy=$PATUS_HOME/strategy/cacheblocked.stg --architecture=$arch  --outdir=$BENCHROOT/wave/patus/patusGenerated

#Compile generated code
cd patusGenerated
make
