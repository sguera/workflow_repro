CC = gcc
# gnu
FLAGS = -O3 -ffast-math -funroll-loops -fopenmp 
LM= -lm
# intel
#FLAGS = -O3 -unroll-aggressive -opt-prefetch -openmp
# cray
#FLAGS = -O3 -hfp3

all: wave2

wave2: wave2.c
	$(CC) $(FLAGS) $+ ${LM} -o $@

clean:
	rm wave2
