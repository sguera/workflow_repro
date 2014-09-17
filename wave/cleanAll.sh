#!/bin/bash

#Naive
DIR=`pwd`
fnCompileRunOpenmp(){
    cd naive/src
    make clean
    cd $DIR
}

#Patus
fnGenerateCompileRunPatus(){
    cd patus
    rm -r patusGenerated
    cd $DIR
 }

#Pochoir
fnCompileRunPochoir(){
    cd pochoir/src
    make clean
    cd $DIR
 }

#Halide
fnCompileRunHalide(){
    cd halide/src
    make clean
    cd $DIR
}

#Pluto
fnCompileRunPluto(){
    cd pluto/src
    make clean
    cd $DIR
}

#Help Message

usage="$(basename "$0") [-h] [compiler] Run the benchmark with specified Compiler

where:
    -h  show this help text
    compiler can be one or more of: Patus
                                    Pochoir
                                    Pluto
			            Halide
			            All"

#Handle call with no argument
if [ "$#" == 0 ]; then
echo "$1"
set -- "$@" "all";
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

		* )						fnCompileRunOpenmp
								fnGenerateCompileRunPatus
								fnCompileRunPochoir
								fnCompileRunPluto
								fnCompileRunHalide
								exit 1
								;;
	esac
	shift
done
