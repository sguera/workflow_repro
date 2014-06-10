#!/bin/bash

DIR=`pwd`
echo $DIR
FILE="$DIR/result.dat"
PLOT="$DIR/gnuplot.gp"
count=0;

# start table heading
printf "CPU" >$FILE

for comp in $@
do
	comp=${comp^}
	if [ "$comp" = "Naive" ]; then {
		count=$((count+4))
		printf "\t $comp""1_gcc\t $comp""1_icc\t $comp""2_gcc\t $comp""2_icc" >> $FILE
	} elif [ "$comp" = "Pluto" ]; then {
		count=$((count+2))
		printf "\t $comp""_gcc\t $comp""_icc" >> $FILE
	} else {
		count=$((count+1))
		printf "\t $comp" >> $FILE
	}
	fi
done		

printf "\n" >>$FILE
# end table heading

# start writing execution times
for i in $NTHREADS
do
	# write num of thread
    printf " $i" >> $FILE;

#	for j in $@
#	do
#		j=${j,,}
#		j=${j^}
#		printf "\t$j " >>$FILE
#	done

	for comp in $@
	do
		cd $comp/output/
		printf "\t " >> $FILE
		if [ $comp = "naive" ]; then {
			awk -F'   ' '/Performance/{total +=  $2; count++} 
						END {
							if (count == 0 ) {
								printf "%.6f", 0
							} else {
								printf "%.6f", total/count
							}
						}' ./output-wave1-gcc-$i.out >> $FILE
			printf "\t " >> $FILE
			awk -F'   ' '/Performance/{total +=  $2; count++} 
						END {
							if (count == 0 ) {
								printf "%.6f", 0
							} else {
								printf "%.6f", total/count
							}
						}' ./output-wave1-icc-$i.out >> $FILE
			printf "\t " >> $FILE
			awk -F'   ' '/Performance/{total +=  $2; count++} 
						END {
							if (count == 0 ) {
								printf "%.6f", 0
							} else {
								printf "%.6f", total/count
							}
						}' ./output-wave2-gcc-$i.out >> $FILE
			printf "\t " >> $FILE
			awk -F'   ' '/Performance/{total +=  $2; count++} 
						END {
							if (count == 0 ) {
								printf "%.6f", 0
							} else {
								printf "%.6f", total/count
							}
						}' ./output-wave2-icc-$i.out >> $FILE
		} elif [ $comp = "pluto" ]; then {
			awk -F'   ' '/Performance/{total +=  $2; count++} 
						END {
							if (count == 0 ) {
								printf "%.6f", 0
							} else {
								printf "%.6f", total/count
							}
						}' ./output-wave-gcc-$i.out >> $FILE
			printf "\t " >> $FILE
			awk -F'   ' '/Performance/{total +=  $2; count++} 
						END {
							if (count == 0 ) {
								printf "%.6f", 0
							} else {
								printf "%.6f", total/count
							}
						}' ./output-wave-icc-$i.out >> $FILE			
		} elif [ $comp = "patus" ]; then {
			tail output-wave1-out-$i.out | awk -F' +' '/Performance/{printf "%.6f",$2}' >> $FILE
		} else {
			awk -F'   ' '/Performance/{total +=  $2; count++} 
						END {
							if (count == 0 ) {
								printf "%.6f", 0
							} else {
								printf "%.6f", total/count
							}
						}' ./output-wave-$i.out >> $FILE
		}
		fi

		cd $DIR
	done
    printf "\n">> $FILE
done

#write plot file
printf 'reset\n' > $PLOT
printf 'set terminal png\n' >> $PLOT
printf 'set output "'$PLOT_OUT'"\n' >> $PLOT
printf 'set auto x\n' >> $PLOT
printf 'set style data histogram\n' >> $PLOT
printf 'set style histogram cluster gap 1\n' >> $PLOT
printf 'set style fill solid border -1\n' >> $PLOT
printf 'set boxwidth 0.9\n' >> $PLOT
printf 'set yrange [0:*]\n' >> $PLOT
printf 'set key autotitle columnheader\n' >> $PLOT
printf 'set xlabel "Number of Threads"\n' >> $PLOT
printf 'set ylabel "GFlops/s"\n' >> $PLOT
printf 'set title "Performance Comparison of Different Stencil Compilers"\n' >> $PLOT
printf 'set key outside\n' >> $PLOT
printf 'set grid\n' >> $PLOT

if [ $count -eq 1 ]; then {
	printf "plot '$FILE' using 2:xtic(1)" >> $PLOT
	printf "\n" >> $PLOT
} elif [ $count -gt 1 ]; then {
	printf "plot '$FILE' using 2:xtic(1) ,\\" >> $PLOT
	printf "\n" >> $PLOT

	for i in `seq 3 $count`
	do
		printf "\t'' using $i:xtic(1) ,\\" >> $PLOT
		printf "\n" >> $PLOT
	done

	printf "\t'' using "$((count+1))":xtic(1)\n" >> $PLOT
}
fi
