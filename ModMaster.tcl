##################################################################################  
#                                                                                   
#                    Authors: John Vant, Abhishek Singharoy
#                              Date: 02/18/20
#                        Center for Structural Discovery                            
#                           Biodesign Institute, ASU                                
#                                                                                   
##################################################################################  
#                                                                                   
#                             Purpose:                                              
# To determine the angular fluctuations of ATPase coiled-coil via principleaxis 
# assignment
#  
#                                                                                   
##################################################################################  
# Usage: vmd -dispdev text -e ModMaster.tcl -args [-psf <filename>] [-dcd <filename>] 
##################################################################################  
#                          Import packages               

package require Orient
namespace import Orient::orient

##################################################################################  
#                            Parameters                                             
#                                                         
# Read in Arguments
# Set the defaults
array set options {-psf "my.psf"}
array set options {-dcd "wo_water_all.dcd"}
# Read in the arguments
array set options $argv
# Use them
source ./params
puts "Your PSF file is: $options(-psf)"
puts "Your DCD file is: $options(-dcd)"
puts " "
# Move to working directory
puts "Working out of the following directory"
puts [pwd]

# load psf
mol new $options(-psf)
#set dcds [glob *dcd]
set dcds "wo_water_all.dcd"
foreach name $options(-dcd) {
    puts "The dcd file is..."
    puts $name
    mol addfile $name waitfor -1
}

# Get total number of frames                   
set nf [molinfo top get numframes]

##################################################################################  
# Torsional Modulus Calculations

# Local variables                              
set convert [expr 180/3.14]

#### New Make atomselections
source ./selections
puts $selections(1)

for {set i 1} {$i <= [array size selections]} {incr i} {
    set "Pt($i)" [atomselect top $selections($i)] ;
}
for {set i 1} {$i <= [array size selections]} {incr i} {
    set "Pto($i)" [atomselect top $selections($i) frame 0] ;
}


# Open .dat files for writing
for {set i 1} {$i <= [array size selections]} {incr i} {
    set "outfilea($i)" [open "Pta$i.dat" w];
    set "outfileb($i)" [open "Ptb$i.dat" w];
    set "outfilec($i)" [open "Ptc$i.dat" w];
}

# Define principal axes for reference frame 0
echo "vecor math"
for {set i 1} {$i <= [array size selections] } {incr i} {
    set I [draw principalaxes $Pto($i)] ;
    set "VPa0($i)" [lindex $I 0] ;
    set "VPb0($i)" [lindex $I 1] ;
    set "VPc0($i)" [lindex $I 2] ;
}

puts "align protein at frame i to frame 0"
# set selection for all sections at frame 0 (reference for allignment)
set sel0 [atomselect top "protein" frame 0]

# Start for loop for setting vectors of all other frames
for {set i 1 } {$i < $nf } { incr i } {
    set sel [atomselect top "protein" frame $i] ; 
    $sel move [measure fit $sel $sel0]

# obtaining principle components
puts "insigia principle components"
    for {set l 1} {$l <= [array size selections] } {incr l} {
	$Pt($l) frame $i
	$Pt($l) num
	set I [draw principalaxes $Pt($l)] ; 
	set "VPa($l)" [lindex $I 0] ; 
	set "VPb($l)" [lindex $I 1] ; 
	set "VPc($l)" [lindex $I 2] ; 
}

# combinations  
echo "combinations"
    for {set l 1} {$l <= [array size selections] } {incr l} {
	set anglea($l) [expr $convert*acos( [vecdot $VPa0($l) $VPa($l)] ) ]; 
	set angleb($l) [expr $convert*acos( [vecdot $VPb0($l) $VPb($l)] ) ] ; 
	set anglec($l) [expr $convert*acos( [vecdot $VPc0($l) $VPc($l)] ) ] ;

      if {$anglea($l) > 90} {
       set anglea($l) [expr (180 - $anglea($l))]
      }
	puts $outfilea($l) $anglea($l) 	
     if {$angleb($l) > 90} {
       set angleb($l) [expr (180 - $angleb($l))] ;
      }
	puts $outfileb($l) $angleb($l)
     if {$anglec($l) > 90} {
       set anglec($l) [expr (180 - $anglec($l))] ;
      }
	puts $outfilec($l) $anglec($l)
    }
}

#puts "start close loop" 
for {set i 1} {$i <= [array size selections] } {incr i} {
    close $outfilea($i)
    close $outfileb($i) 
    close $outfilec($i) 
}

exit
