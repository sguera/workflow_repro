#CXX = icpc -std=c++0x -O0 -g
CXX = g++ -std=c++0x -O3 -g
LIBS = -I$(BENCHROOT)/StencilCompilers/halide/halide/include -lHalide -ldl -lpthread -lrt
LDFLAGS += -L$(BENCHROOT)/StencilCompilers/halide/halide/bin -Wl,-R$(BENCHROOT)/StencilCompilers/halide/halide/bin
#LDFLAGS += -L$(BENCHROOT)/StencilCompilers/halide/halide/bin

APPS = wave

all: $(APPS)

wave: wave.cpp
	$(CXX) $+ $(LDFLAGS) $(LIBS) -o $@
	
clean:
	rm -rf $(APPS) ????.txt *~ 
