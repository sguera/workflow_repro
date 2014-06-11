#!/bin/bash
set -e 

#Help Message
usage="$(basename "$0") [-h] command [compiler1 [compiler2 ...]]|[all]
		$(basename "$0") [-h] run|install [compiler1 [compiler2 ...]]

$(basename "$0") is a simple shell script for installing and running stencil compilers.
Compiler can be one or more of: patus
								pochoir
								pluto
								halide
where:
	-h  show this help text

Commands:
	install - Install the compilers
	run - Excute the stencil code produced by the compilers"

#Installation Function
install(){
	#Install the compilers
	cd StencilCompilers/
	./installAll.sh $compilers
	cd $dir
}

#Run Function
run(){
	#Run the waves
	cd wave/
	./runAll.sh $compilers

	#Gather outputs
	./gatheringOutputs.sh $compilers

	#Produce a plot
	gnuplot gnuplot.gp
	cp $PLOT_OUT $outdir/.
	cd $dir
	rm started_time.txt
}

#Handle call with no argument
if [ "$#" == 0 ]; then
	echo "$usage"
	exit 1
elif [ "$1" != "run" -a "$1" != "install" ]; then
	echo "$usage"
	exit 1
else
	cmd=$1
	shift
fi

#Save current location
dir=`pwd`
outdir=$dir/workflow_outputs
NOW=$(date +"%d%m%Y_%H%M")
export PLOT_OUT=results_$NOW.png

#Set up the environment
cd $dir
source SetupEnv.sh

intel_arch='ia32'
if [ `uname -m` = "x86_64" ]; then
  intel_arch='intel64'
fi
source $INTEL_VARS $intel_arch

#Format every compiler name to lower case and build a string of the selected compilers
compilers=""
#Handle call with no argument
if [ "$#" == 0 ]; then
	set -- "$@" "naive pluto pochoir patus halide";
fi

for i in $@
do
	i=${i,,}
	compilers="$compilers $i"
done

echo "CMD: $cmd with COMPILERS: $compilers"
$cmd

exit 1
