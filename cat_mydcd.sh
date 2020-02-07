#!/usr/bin/env bash

############################################################## 
# 
# Author:               John Vant 
# Email:              jvant@asu.edu 
# Affiliation:   ASU Biodesign Institute 
# Date Created:          200205
# 
############################################################## 
# 
# Usage: 
# 
############################################################## 
# 
# Notes: 
# 
############################################################## 
# Paths
catdcd="/home/jvant/Documents/Programs/catdcd4.0/catdcd"

############################################################## 
if [ -e $catdcd ]
then
    echo "catdcd is not where you think it is!"
    echo "Path is set as:"
    echo "$catdcd"
    echo "would you like to provide a path to catdcd? [y/n]"
    read ans
    if [ "y" == $ans ]
    then
	echo "What is the path?  end with catdcd executable."
	read catdcd
    else
	echo "Ok we are done here."
	exit
    fi
fi

# VMD make index file
vmd -dispdev text -e ../Modulus_Scripts/make_index.tcl -args ${1} ${2}
dcds=$(fqind ./ -type f -name "step*.dcd")

$catdcd -o wo_water_all.dcd -i my.ind $dcds 

echo "Congrats!  We are done :}"

