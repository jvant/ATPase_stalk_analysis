
##################################################################################
#
#                    Authors: Abhishek Singharoy, John Vant
#                              Date: 01/19/19
#                        Center for Structural Discovery
#                           Biodesign Institute, ASU
#
##################################################################################
#
#                             Purpose:
# To Determine the bending fluctuations using orient package
# Verision 3.0 uses 2 principle vectors to calculate bending between two 
# sections
# This version has an expanded selection which includes all of segname PROG
##################################################################################
#                            Parameters
# Load dcds
source ../f1loaddcds.tcl
# test files
#mol new ../Agave/plugged_whole_solvion_atp.psf
#mol addfile ../Agave/step7.3_production.dcd waitfor -1

# Local variables 
set convert [expr 180/3.14]

# Get total number of frames 
set nf [molinfo top get numframes]

# Define Sections
## z cutpoint
set center_point 95
# Make atomselections
set top [atomselect top "backbone and segname PROG and ( z > $center_point )"]
set bottom [atomselect top "backbone and segname PROG and ( z < $center_point )"]

# Open file for writing
set "outfile" [open "Bend.dat" w];

# Import packages
package require Orient
namespace import Orient::orient

##################################################################################
#                            Calculations


for {set i 0 } {$i < $nf } { incr i } {
    $top frame $i
    $bottom frame $i
    set I_top [draw principalaxes $top]
    set I_bottom [draw principalaxes $bottom]
    set "Vtop" [lindex $I_top 2]
    set "Vbottom" [lindex $I_bottom 2]
    set angle "[expr $convert*acos([vecdot $Vtop $Vbottom])]" 
    if {$angle > 90} {
       set angle [expr (180 - $angle)]
      }
    puts $outfile $angle 	
}    
# Close .dat file so it can be written
close $outfile



