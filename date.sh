#!/bin/bash
set -e 

#Save current location
dir=`pwd`
work_dir=`ls reproducibility | grep sgsponer-trans`
NOW=$(date +"%d%m%Y_%H%M")

echo $NOW
