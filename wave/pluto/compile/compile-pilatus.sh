#!/bin/bash -l
module load PrgEnv-intel
icc -O3 -unroll-aggressive -opt-prefetch -openmp lb-16-16-16-1000.c -o wavepluto.icc.pilatus
module switch PrgEnv-intel PrgEnv-gnu
gcc -O3 -ffast-math -funroll-loops -fopenmp -lm lb-16-16-16-1000.c -o wavepluto.gnu.pilatus 
cp wavepluto.icc.pilatus $SCRATCH
cp wavepluto.gnu.pilatus $SCRATCH
