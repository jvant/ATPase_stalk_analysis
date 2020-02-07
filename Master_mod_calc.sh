#!/bin/bash

##########################################################################      
#                                                                               
#        Created by:  John Vant                                                 
#                     jvant@asu.edu                                             
#                     Biodesign Institute, ASU                                  
#                                                                               
#        This Script is meant to run a global Cryo-EM structure                 
#        error analysis                                                         
#                                                                               
##########################################################################      

# Usage: bash Molprobity_wrapper.sh /path/to/wording/directory <psf> <dcd> <step>                                                                              

##########################################################################      
# Modules                                                                       
module load phenix/1.14-3260
##########################################################################      
# Files needed in working directory                                             
# psf file, dcd file, and a map file in .map or .ccp4 format                    
##########################################################################      


wd=$1
psf=$2
dcd=$3
step=$4

# Manage paths                                                                  
scripts_path=$(pwd)
cd $wd
pwd              # All child scripts will be out of this directory              

##########################################################################
