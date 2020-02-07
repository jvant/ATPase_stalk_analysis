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

# VMD make index file
vmd -dispdev text -e ../make_index.tcl -args ${1} ${2}

catdcd="/home/jvant/Documents/Programs/catdcd4.0/catdcd"

dcds=$(find ./ -type f -name "step*.dcd")

$catdcd -o wo_water_all.dcd -i my.ind $dcds 