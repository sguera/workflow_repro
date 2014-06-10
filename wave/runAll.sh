#!/bin/bash
set -e

#Naive
DIR=`pwd`
fnCompileRunNaive(){
    cd naive/src
    make
    cd ../run
    ./run-bench.sh
    cd $DIR
}

#Patus
fnGenerateCompileRunPatus(){
    cd patus
    ./generateCode.sh
    cd run
    ./generateJobAndRun.sh
    cd $DIR
}

#Pochoir
fnCompileRunPochoir(){
    cd pochoir/src
    export POCHOIR_LIB_PATH=$BENCHROOT/StencilCompilers/pochoir/pochoir_v0.5
    make
    cd ../run
    ./runpochoir.sh
    cd $DIR
 }

#Halide
fnCompileRunHalide(){
    cd halide/src
    export LD_LIBRARY_PATH=$BENCHROOT/StencilCompilers/halide/halide/bin:$LD_LIBRARY_PATH
    #echo $LD_LIBRARY_PATH
    make
    cd ../run
    ./runhalide.sh
    cd $DIR
}

#Pluto
fnCompileRunPluto(){
    cd pluto/src
    make
    cd ../run
    ./runpluto.sh
    cd $DIR
}

#Help Message

usage="$(basename "$0") [-h] [compiler] Run the benchmark with specified Compiler

where:
    -h  show this help text
    compiler can be one or more of: patus
                                    pochoir
                                    pluto
			            halide
			            all"

#Handle call with no argument
if [ "$#" == 0 ]; then
echo "$1"
set -- "$@" "naive pluto pochoir patus halide";
fi

#Handle the Arguments
while [ "$1" != "" ]; do
    case $1 in
        Patus | patus)          fnGenerateCompileRunPatus
                                ;;

        Pochoir | pochoir)      fnCompileRunPochoir
                                ;;

        Pluto | pluto)          fnCompileRunPluto
                                ;;

        Halide | halide)        fnCompileRunHalide
                                ;;

	Naive | naive)          fnCompileRunNaive "naive"
	                        ;;

        -h | --help )           echo "$usage"
                                exit
                                ;;

        all | All )             fnCompileRunNaive
	                        fnGenerateCompileRunPatus
                                fnCompileRunPochoir
                                fnCompileRunPluto
                                fnCompileRunHalide
                                exit 1
                                ;;

        * )                     fnCompileRunNaive
	                        fnGenerateCompileRunPatus
                                fnCompileRunPochoir
                                fnCompileRunPluto
                                fnCompileRunHalide
                                exit 1
                                ;;
    esac
    shift
done