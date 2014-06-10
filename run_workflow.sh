#!/bin/bash
set -e 

#Save current location
dir=`pwd`
outdir=$dir/workflow_outputs
NOW=$(date +"%d%m%Y_%H%M")
export PLOT_OUT=results_$NOW.png
echo $PLOT_OUT
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
echo "$1"
set -- "$@" "naive pluto pochoir patus halide";
fi

for i in $@
do
i=${i,,}
compilers="$compilers $i"
done

#echo $compilers

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
