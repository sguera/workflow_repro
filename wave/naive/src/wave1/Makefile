CC = gcc
# gnu
FLAGS = -O3 -ffast-math -funroll-loops -fopenmp 
LM= -lm
# intel
#FLAGS = -O3 -unroll-aggressive -opt-prefetch -openmp
# cray
#FLAGS = -O3 -hfp3

code_wave1=wave1

all: wave1

wave1: wave1.c
	$(CC)  $(FLAGS) $+ ${LM} -o $@

clean:
	rm wave1 
