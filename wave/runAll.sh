#!/bin/bash
set -e

#Naive
DIR=`pwd`
fnCompileRunOpenmp(){
	cd openmp/src
	make openmp
	cd ..
	#create output folder
	if [ -d "output" ]; then
		rm -r output
	fi
	mkdir output
	cd run
	./run-bench.sh
	cd $DIR
}

#Patus
fnGenerateCompileRunPatus(){
	cd patus
	./generateCode.sh
	#create folder where to install
	if [ -d "output" ]; then
		rm -r output
	fi
	mkdir output
	cd run
	./generateJobAndRun.sh
	cd $DIR
}

#Pochoir
fnCompileRunPochoir(){
	cd pochoir/src
	export POCHOIR_LIB_PATH=$BENCHROOT/StencilCompilers/pochoir/pochoir_v0.5
	make
	cd ..
	#create output folder
	if [ -d "output" ]; then
		rm -r output
	fi
	mkdir output
	cd run
	./runpochoir.sh
	cd $DIR
 }

#Halide
fnCompileRunHalide(){
	cd halide/src
	export LD_LIBRARY_PATH=$BENCHROOT/StencilCompilers/halide/halide/bin:$LD_LIBRARY_PATH
	#echo $LD_LIBRARY_PATH
	make
	cd ..
	#create output folder
	if [ -d "output" ]; then
		rm -r output
	fi
	mkdir output
	cd run
	./runhalide.sh
	cd $DIR
}

#Pluto
fnCompileRunPluto(){
	cd pluto/src
	make
	cd ..
	#create output folder
	if [ -d "output" ]; then
		rm -r output
	fi
	mkdir output
	cd run
	./runpluto.sh
	cd $DIR
}

#Help Message

usage="$(basename "$0") [-h] [compiler] Run the benchmark with specified Compiler

where:
	-h  show this help text
	compiler can be one or more of: 
					patus
					pochoir
					pluto
					halide
					all"

#Handle call with no argument
if [ "$#" == 0 ]; then
	echo "$1"
	set -- "$@" "openmp pluto pochoir patus halide";
fi

#Handle the Arguments
while [ "$1" != "" ]; do
	case $1 in
		Patus | patus)			fnGenerateCompileRunPatus
								;;

		Pochoir | pochoir)		fnCompileRunPochoir
								;;

		Pluto | pluto)			fnCompileRunPluto
								;;

		Halide | halide)		fnCompileRunHalide
								;;

		Openmp | openmp)			fnCompileRunOpenmp "openmp"
								;;

		-h | --help )			echo "$usage"
								exit 1
								;;

		all | All )				fnCompileRunOpenmp
								fnGenerateCompileRunPatus
								fnCompileRunPochoir
								fnCompileRunPluto
								fnCompileRunHalide
								exit 1
								;;

		* )						echo "$usage"
								exit 1
								;;
	esac
	shift
done
