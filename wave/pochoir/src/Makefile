POCHOIR_PATH := $(BENCHROOT)/StencilCompilers/pochoir/pochoir_v0.5
FLAGS = -O3 -ipo -std=c++0x 
POCHOIR_LIB_PATH := $(POCHOIR_PATH)


all: secondStep
	@echo Done


#Pochoirs first Step
CC=$(POCHOIR_PATH)/pochoir
firstStep: wave.cpp
	@echo First compilation step
	${CC} -o wave -O0 -g -debug -std=c++0x wave.cpp


#Second Step of Pohcoir Compilation
secondStep: firstStep
	@echo Second compilation step
	${CC} -o wave -O3 -std=c++0x wave.cpp

clean:
	rm wave ????.txt
