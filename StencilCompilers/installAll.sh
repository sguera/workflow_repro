#!/bin/bash
set -e 

#Save current location
dir=`pwd`


#Installation Function
fnInstall(){
echo "==================="
echo "  Install $1  "
echo "==================="
cd $1
./install$1.sh
cd $dir

}

#Help Message

usage="$(basename "$0") [-h] [compiler] Install specified Compiler

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
set -- "$@" "pluto pochoir halide patus";
fi

#Handle the Arguments
while [ "$1" != "" ]; do
    case $1 in
        Patus | patus)          fnInstall patus           
                                ;;

        Pochoir | pochoir)      fnInstall pochoir           
                                ;;

        Pluto | pluto)          fnInstall pluto          
                                ;;

        Halide | halide)        fnInstall halide           
                                ;;

        -h | --help )           echo "$usage"
                                exit 1
                                ;;

        all | All )             fnInstall patus
                                fnInstall pochoir
                                fnInstall pluto
                                fnInstall halide
                                exit 1
                                ;;

        * )                     echo "$usage"
                                exit 1
								;;
    esac
    shift
done
