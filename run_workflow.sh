#!/bin/bash
set -e 

#Save current location
dir=`pwd`
outdir=$dir/workflow_outputs
workdir=`ls reproducibility | grep sgsponer-trans`
NOW=$(date +"%d%m%Y_%H%M")
export PLOT_OUT=results_$NOW.png
echo $PLOT_OUT
#Set up the environment
source /users/stud/g/gspsev00/intel/bin/compilervars.sh intel64
cd reproducibility/$workdir
source SetupEnv

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
