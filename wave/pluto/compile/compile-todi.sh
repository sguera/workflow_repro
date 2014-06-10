#!/bin/bash -l
module load PrgEnv-cray
cc -O3 -hfp3 lb-16-16-16-1000.c -o wavepluto.cray.todi
module switch PrgEnv-cray PrgEnv-intel
cc -O3 -unroll-aggressive -opt-prefetch -openmp lb-16-16-16-1000.c -o wavepluto.icc.todi
module switch PrgEnv-intel PrgEnv-gnu
cc -O3 -ffast-math -funroll-loops -fopenmp -lm lb-16-16-16-1000.c -o wavepluto.gnu.todi
cp wavepluto.cray.todi $SCRATCH 
cp wavepluto.icc.todi $SCRATCH
cp wavepluto.gnu.todi $SCRATCH
