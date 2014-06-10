#!/bin/bash
for prog in wave1 wave2
do
    echo "------------- $prog ------------"
    for compiler in gcc icc
    do
	echo -e "\t------------- $compiler ------------"
	echo
	
	for t in $NTHREADS
	do
	    echo -e "\t\t------- $t ------"
	    FILE="../output/output-$prog-$compiler-$t.out"
	    echo $t>$FILE
		export OMP_NUM_THREADS=$t
		echo "------------- $t Threads ------------">>$FILE
		for i in 1 2 3 4 5
		do
			../src/$prog/$prog 200 200 200 >> $FILE 
		done
		echo >>$FILE
		echo >>$FILE
		echo -e "\t\t DONE $t THREADS"
		echo 

	done
	echo -e "\t DONE $compiler"
	echo 
    done
    echo
    echo
done
