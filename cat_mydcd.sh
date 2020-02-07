#!/bin/bash

sys=${1}
wd=$analysis/$sys
mkdir $wd

# VMD make index file
psfs=$(find $jrlay/$sys/ -type f -name "*.psf")
apsf=$(echo $psfs | awk '{print $1}')
dcds=$(find $jrlay/$sys/ -type f -name "prod*.dcd")
adcd=$(echo $dcds | awk '{print $1}')

vmd -dispdev text -e $Mod_scripts/make_index.tcl -args ${apsf} ${adcd} ${wd}




$catdcd -o $wd/wo_water_all.dcd -i my.ind $dcds 

echo "Congrats!  We are done :}"
