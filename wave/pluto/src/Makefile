CC = icc
GCC = gcc

# for icc
OPT_FLAGS=-O3 -fp-model precise
PAR_FLAGS := -parallel
OMP_FLAGS := -openmp

# for gcc
GOPT_FLAGS := -O3 -ftree-vectorize -msse3 
GPAR_FLAGS := -ftree-parallelize-loops=4
GOMP_FLAGS := -fopenmp

# general
CFLAGS = -DTIME -DVERIFY
LDFLAGS = -lm

#Pluto Path
PLC=$(BENCHROOT)/StencilCompilers/pluto/installed/bin/polycc


all: tiled

tiled: tile.sizes wave.c
	$(PLC) --tile --parallel wave.c -o temp1.c
	bash replace.sh
	$(CC) $(OPT_FLAGS) $(PAR_FLAGS) $(OMP_FLAGS) $(CFLAGS) temp2.c -o wavepluto.$(CC) $(LDFLAGS)	
	$(GCC) $(GOPT_FLAGS) $(GPAR_FLAGS) $(GOMP_FLAGS) $(CFLAGS) temp2.c -o wavepluto.$(GCC) $(LDFLAGS)

clean:
	rm -f temp* wavepluto.* output.* *~

