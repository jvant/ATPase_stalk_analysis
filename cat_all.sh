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
# Notes: Agave style
# 
############################################################## 
# Paths
export catdcd="/home/jvant/catdcd"
export jrlay="/scratch/jrlayto1/F-type_ATPase/systems"
export analysis="/home/jvant/scr/F-type_ATPase_cc_analysis/analysis"
export Mod_scripts="/home/jvant/scr/F-type_ATPase_cc_analysis/ATPase_stalk_analysis"
############################################################## 
if [ -e catdcd ]
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
	export catdcd
    else
	echo "Ok we are done here."
	exit
    fi
fi

for sys in 4asu 5t4q 6n2y 6q45 6rdb
do

    sbatch \
	-N 1 \
	-n 8 \
	-t 1-00:00 \
	-o $analysis/$sys/slurm-${sys}_catdcd.out \
	-p asinghargpu1 \
	-q asinghargpu1 \
	-J ${sys}_catdcd \
	<<EOF
#!/bin/bash

# Load Modules
module load vmd/1.9.3

./cat_mydcd.sh $sys

EOF

    
done
