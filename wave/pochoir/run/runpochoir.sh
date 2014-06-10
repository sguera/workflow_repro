#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --time=1:00:00
#SBATCH --account=s377

#LIKWID="/users/chrmat/likwid-2.2/bin/bin/likwid-pin -q -c 0,16,1,17,2,18,3,19,4,20,5,21,6,22,7,23,8,24,9,25,10,26,11,27,12,28,13,29,14,30,15,31"



# without pinning
echo ">>> without pinning"
for prog in wave
do

    for t in $NTHREADS
    do
	FILE="../output/output-$prog-$t.out"
	export CILK_NWORKERS=$t
	echo "------------- $t Threads ------------">$FILE
	echo "------------- $t Threads ------------"
	for i in 1 2 3 4 5
	do
                echo $i
		../src/wave 200 200 200 >>$FILE
		echo>>$FILE
	done
	echo>>$FILE
	echo
done
done

# with pinning
#echo ">>> with pinning"
#for t in 1 2 4 8 16 32
#do
#	export CILK_NWORKERS=$t
#	echo "------------- $t Threads ------------"
#	for i in 1 2 3 4 5
#	do
#		$LIKWID -t intel $SCRATCH/wave_pochoir 200 200 200
#		echo
#	done
#	echo
#	echo
#done
