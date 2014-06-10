reset
set terminal png
name=system("echo $PLOT_OUT.png")
set output name
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
plot './result.dat' using 2:xtic(1) ,\
     '' using 3:xtic(1) ,\
     '' using 4:xtic(1) ,\
     '' using 5:xtic(1) ,\
     '' using 6:xtic(1) ,\
     '' using 7:xtic(1) ,\
     '' using 8:xtic(1)
