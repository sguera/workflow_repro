#!/bin/bash

dir=`pwd`
#export LD_LIBRARY_PATH=$BENCHROOT/StencilCompilers/halide/halide/bin:$LD_LIBRARY_PATH
for prog in wave
do
for t in $NTHREADS
do
    FILE="$dir/../output/output-$prog-$t.out"
	export HL_NUMTHREADS=$t
	echo "------------- $t Threads ------------" >$FILE
	for i in 1 2 3 4 5
	do
	    $dir/../src/wave >>$FILE
	    echo >>$FILE
	done
	echo
	echo
done
done
