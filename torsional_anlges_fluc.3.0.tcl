

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
# To Determine the angular fluctuations using orient package
#  Verision 2.2 uses origonal principle vectors to calculate
#
##################################################################################
#                            Parameters
#
# Input structure name below
source ../f1loaddcds.tcl
# Number of sections defining angles
set numsect 8
# Number of equilibrated dcds
#set numdcdfiles

# Local variables 
set convert [expr 180/3.14]


# Get total number of frames 
set nf [molinfo top get numframes]
#set nf 5

for {set i 0} {$i <= $numsect} {incr i} {
    set k [expr $i + 1]
    set bound(up) [expr 151 - $i * 14]
    set bound(low) [expr 151 - $k * 14]
    set "Pt($k)" [atomselect top "backbone and (segname PROG and not resid 101 to 287 and (z > $bound(low) and z < $bound(up) ))"]
    puts $Pt($k)
}

for {set i 0} {$i <= $numsect} {incr i} {
    set k [expr $i + 1]
    set bound(up) [expr 151 - $i * 14]
    set bound(low) [expr 151 - $k * 14]
    set "Pto($k)" [atomselect top "backbone and (segname PROG and not resid 101 to 287 and (z > $bound(low) and z < $bound(up) ))" frame 0]
}

for {set i 1} {$i <= $numsect } {incr i} {
    set "outfilea($i)" [open "Pta$i.dat" w];
    set "outfileb($i)" [open "Ptb$i.dat" w];
    set "outfilec($i)" [open "Ptc$i.dat" w];
}

# Import packages
package require Orient
namespace import Orient::orient
echo "vecor math"
for {set i 0} {$i < $numsect } {incr i} {
    set k [expr $i + 1]
    set I [draw principalaxes $Pto($k)]
    set "VPa0($k)" [lindex $I 0]
    set "VPb0($k)" [lindex $I 1]
    set "VPc0($k)" [lindex $I 2]
}

echo "align protein at frame i to frame 0"
# set selection for all sections at frame 0 (reference for allignment)
set sel0 [atomselect top "protein" frame 0]

# Start for loop for setting vectors of all other frames
for {set i 1 } {$i < $nf } { incr i } {
    set sel [atomselect top "protein" frame $i]
    $sel move [measure fit $sel $sel0]

# obtaining principle components
echo "insigia principle components"
    for {set l 1} {$l <= $numsect } {incr l} {
	$Pt($l) frame $i
	$Pt($l) num
	set I [draw principalaxes $Pt($l)]
	set "VPa($l)" [lindex $I 0]
	set "VPb($l)" [lindex $I 1]
	set "VPc($l)" [lindex $I 2]
}

# combinations  
echo "combinations"
    for {set l 1} {$l <= $numsect } {incr l} {
	set anglea($l) "[expr $convert*acos([vecdot $VPa0($l) $VPa($l)])]" 
	set angleb($l) "[expr $convert*acos([vecdot $VPb0($l) $VPb($l)])]" 
	set anglec($l) "[expr $convert*acos([vecdot $VPc0($l) $VPc($l)])]" 

      if {$anglea($l) > 90} {
       set anglea($l) [expr (180 - $anglea($l))]
      }
	puts $outfilea($l) $anglea($l) 	
     if {$angleb($l) > 90} {
       set angleb($l) [expr (180 - $angleb($l))]
      }
	puts $outfileb($l) $angleb($l)
     if {$anglec($l) > 90} {
       set anglec($l) [expr (180 - $anglec($l))]
      }
	puts $outfilec($l) $anglec($l)
    }
}

#puts "start close loop"
for {set i 1} {$i <= $numsect } {incr i} {
    close $outfilea($i)
    close $outfileb($i) 
    close $outfilec($i) 
}
