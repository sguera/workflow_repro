GCC = gcc
CC = icc
# gnu
GFLAGS = -O3 -ffast-math -funroll-loops -fopenmp 
LM= -lm
# intel
IFLAGS = -O3 -unroll-aggressive -opt-prefetch -openmp
# cray
#FLAGS = -O3 -hfp3

code_wave1=wave1

all: wave1

wave1: wave1.c
	$(CC)  $(IFLAGS) $+ ${LM} -o $@.$(CC)
	$(GCC)  $(GFLAGS) $+ ${LM} -o $@.$(GCC)

clean:
	rm wave1.* 
