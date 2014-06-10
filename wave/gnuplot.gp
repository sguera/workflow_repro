reset
set terminal png
set output "results_04062014_1139.png"
set auto x
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9
set yrange [0:*]
set key autotitle columnheader
set xlabel "Number of Threads"
set ylabel "GFlops/s"
set title "Performance Comparison of Different Stencil Compilers"
set key outside
set grid
plot '/users/staff/ifi/guerrera/reproducibility/sgsponer-trans-d46737626b60/wave/result.dat' using 2:xtic(1) ,\
	'' using 3:xtic(1) ,\
	'' using 4:xtic(1) ,\
	'' using 5:xtic(1) ,\
	'' using 6:xtic(1) ,\
	'' using 7:xtic(1) ,\
	'' using 8:xtic(1) ,\
	'' using 9:xtic(1)
