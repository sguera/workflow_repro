#
# Makefile for Patus stencil benchmark
#
# Note: $(PATUS_*) variables will be automatically replaced by the
# required runtime files by Patus.
#

CC = gcc
CFLAGS = -O3 -g -msse2 -fopenmp -I.


bench: kernel.o driver.o ssemathlib.o util.o timer.o
	$(CC) $(CFLAGS) -o $@ $+ -lm

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<
	
tune:
ifndef x_max
	@echo For tuning, the value of x_max must be specified. E.g. 'make tune x_max=100'
	@false
endif
ifndef y_max
	@echo For tuning, the value of y_max must be specified. E.g. 'make tune y_max=100'
	@false
endif
ifndef z_max
	@echo For tuning, the value of z_max must be specified. E.g. 'make tune z_max=100'
	@false
endif

	java -jar /users/staff/ifi/guerrera/reproducibility/sgsponer-trans-d46737626b60/StencilCompilers/patus/patus/bin/patus.jar autotune bench $(x_max) $(y_max) $(z_max) @WAVE_CB_X=\(\(\$$0-4\)/4\),\(\(\$$0-4\)/2\),\(\$$0-4\) @WAVE_CB_Y=4:4:\(\$$1-4\) @WAVE_CB_Z=4:4:\(\$$2-4\) @WAVE_CHUNK=1,2,4 @WAVE__UNROLL_P3=0:1:8  | tee `date +tune_%F_%H.%M.%S.txt`
	
plot:
	for f in *.data; do echo "set term png; set view map; splot \"$$f\" matrix with image" | gnuplot > $${f%.data}.png; done
	
clean:
	rm -rf *.o bench
