LIKWID="likwid-pin -q -c 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"
PATUS_HOME=$BENCHROOT/StencilCompilers/patus/patus
dir=$BENCHROOT/wave/patus/


for prog in wave1
do
	for arch in out
	do
		for t in $NTHREADS
		do
			FILE="tune-mint-$prog-$arch-$t.job"
			OUTPUT="../output/output-$prog-$arch-$t.out"
			echo "#!/bin/bash" > $FILE
			
			echo "export OMP_NUM_THREADS=$t" >> $FILE
			echo "echo \"------------- mintb-$prog-$arch ------------\"" >> $FILE
			echo "echo \"------------- $t Threads ------------\"" >> $FILE
			echo "java -jar  $PATUS_HOME/bin/patus.jar autotune $dir/patusGenerated/bench 208 204 204 52,64,104,128,208 4:4:204 4:4:204 1,2,4 0:8 \"C((\\\$1+\\\$4-1)/\\\$4)*((\\\$2+\\\$5-1)/\\\$5)*((\\\$3+\\\$6-1)/\\\$6)>=$t\" -mch.unibas.cs.hpwc.patus.autotuner.MetaHeuristicOptimizer" >> $FILE

			#echo "java -jar $PATUS_HOME/bin/patus.jar autotune \"./pin.sh /users/stud/g/gspsev00/material/material/src/wave/patus/out/bench\" 208 204 204 52,64,104,128,208 4:4:204 4:4:204 1,2,4 0:8 \"C((\\\$1+\\\$4-1)/\\\$4)*((\\\$2+\\\$5-1)/\\\$5)*((\\\$3+\\\$6-1)/\\\$6)>=$t\" -mch.unibas.cs.hpwc.patus.autotuner.MetaHeuristicOptimizer" >> $FILE #0:11 entfernt schluss von parametern
			sh ./$FILE > $OUTPUT
		done
	done
done
