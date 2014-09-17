CC = gcc
# gnu
FLAGS = -O3 -ffast-math -funroll-loops -fopenmp 
LM= -lm
# intel
#FLAGS = -O3 -unroll-aggressive -opt-prefetch -openmp
# cray
#FLAGS = -O3 -hfp3

code_wave1=wave1
code_wave2=wave2

all: openmp

wave1s:
	$(MAKE) -C $(code_wave1) all

wave2s: 
	$(MAKE) -C $(code_wave2) all

clean:
	$(MAKE) -C $(code_wave1) clean
	$(MAKE) -C $(code_wave2) clean

