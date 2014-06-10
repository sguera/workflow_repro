#!/bin/bash

LIKWID="likwid-pin -c 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"
dir=`pwd`
# without pinning
echo ">>> without pinning"
for compiler in icc gcc
do

	echo "=== $compiler ==="
	echo
	for t in $NTHREADS
	do
	    FILE="$dir/../output/output-wave-$compiler-$t.out"
		export OMP_NUM_THREADS=$t
		echo "------------- $t Threads ------------" >$FILE
                echo "------------- $t Threads ------------" 
		for i in 1 2 3 4 5
		do
                    echo "Run $i"
			../src/wavepluto.$compiler >>$FILE
			echo >>$FILE
		done
		echo
		echo
	done
done


# # with pinning
# echo ">>> with pinning"
# for compiler in gnu icc
# do
# 	echo "=== $compiler"
# 	echo
	
# 	type=""
# 	if [ "$compiler" = "icc" ]
# 	then
# 		type="-t intel"
# 	fi
	
# 	for t in 1 2 4 8 16
# 	do
# 		export OMP_NUM_THREADS=$t
# 		echo "------------- $t Threads ------------"
# 		for i in 1 2 3 4 5
# 		do
# 			$LIKWID $type ../src/wavepluto.$compiler.mint
# 			echo
# 		done
# 		echo
# 		echo
# 	done
# done
