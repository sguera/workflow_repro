#!/bin/bash



#Naive
DIR=`pwd`
fnCompileRunNaive(){
    cd naive/src
    make clean
    cd $DIR
}

#Patus
fnGenerateCompileRunPatus(){
    cd Patus
    rm -r patusGenerated
    cd $DIR
 }

#Pochoir
fnCompileRunPochoir(){
    cd Pochoir/src
    make clean
    cd $DIR
 }

#Halide
fnCompileRunHalide(){
    cd Halide/src
    make clean
    cd $DIR
}

#Pluto
fnCompileRunPluto(){
    cd Pluto/src
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
