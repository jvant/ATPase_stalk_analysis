
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
# To Determine the stretching fluctuations using orient package
#  Verision 3.0 uses end to end distances of peripherial stalk
# ie segname PROG
#
##################################################################################
#                            Parameters
#
# Load Equilibtated dcds
source ../f1loaddcds.tcl

## Test cases
#mol new ../Agave/plugged_whole_solvion_atp.psf
#mol addfile ../Agave/step7.3_production.dcd waitfor -1


# Local variables 
set "outfile" [open "Dist.dat" w];

# Get total number of frames 
set nf [molinfo top get numframes]

set sel_top [atomselect top "backbone and (segname PROG and not resid 101 to 287 and (z > 137 and z < 151 ))"]
set sel_bottom [atomselect top "backbone and (segname PROG and not resid 101 to 287 and (z > 39 and z < 53 ))"]

for {set i 0 } {$i < $nf } { incr i } {
    $sel_top frame $i
    $sel_bottom frame $i
    set top_coord [measure center $sel_top weight mass]
    set bottom_coord [measure center $sel_bottom weight mass]
    set "dist($i)" [veclength [vecsub $top_coord $bottom_coord]]
    puts $outfile $dist($i)
}

close $outfile
