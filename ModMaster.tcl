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
# Usage: vmd -dispdev text -e ModMaster.tcl -args 
##################################################################################  
#                          Import packages               
#
package require Orient
source /usr/share/tcl8.5/tcllib-1.14/math/math.tcl
source /usr/share/tcl8.5/tcllib-1.14/math/statistics.tcl
source /usr/share/tcl8.5/tcllib-1.14/math/linalg.tcl 
package require math::statistics
namespace import Orient::orient

##################################################################################  
#                            Parameters                                             
#                                                         
# Read in Arguments
# Set the defaults
array set options {-psf "my.psf"}
# Read in the arguments
array set options $argv
# Use them
source ./params
puts "Your PSF file is: $options(-psf)"

# Move to working directory
puts "Working out of the following directory"
puts [pwd]

# load psf
mol new my.psf
#set dcds [glob *dcd]
set dcds "wo_water_all.dcd"
foreach name $dcds {
    puts "The dcd file is..."
    puts $name
    mol addfile $name waitfor -1
}
puts "did it load"
# Get total number of frames                   
set nf [molinfo top get numframes]
puts "These trajectories amount to [expr $nf / 1000] ps"

##################################################################################  
# Torsional Modulus Calculations

# Local variables                              
set convert [expr 180/3.14]

################
#### New Make atomselections
source ./selections
puts $selections(1)

for {set i 1} {$i <= [array size selections]} {incr i} {
    set "Pt($i)" [atomselect top $selections($i)] ; list
}
for {set i 1} {$i <= [array size selections]} {incr i} {
    set "Pto($i)" [atomselect top $selections($i) frame 0] ; list
}



################
# Open .dat files for writing
for {set i 1} {$i <= [array size selections]} {incr i} {
    set "outfilea($i)" [open "Pta$i.dat" w];
    set "outfileb($i)" [open "Ptb$i.dat" w];
    set "outfilec($i)" [open "Ptc$i.dat" w];
}

# Define principal axes for reference frame 0
echo "vecor math"
for {set i 1} {$i <= [array size selections] } {incr i} {
    set I [draw principalaxes $Pto($i)] ; list
    set "VPa0($i)" [lindex $I 0] ; list
    set "VPb0($i)" [lindex $I 1] ; list
    set "VPc0($i)" [lindex $I 2] ; list
}

puts "align protein at frame i to frame 0"
# set selection for all sections at frame 0 (reference for allignment)
set sel0 [atomselect top "protein" frame 0]

# Start for loop for setting vectors of all other frames
for {set i 1 } {$i < $nf } { incr i } {
    set sel [atomselect top "protein" frame $i] ; list
    $sel move [measure fit $sel $sel0]

# obtaining principle components
puts "insigia principle components"
    for {set l 1} {$l <= [array size selections] } {incr l} {
	$Pt($l) frame $i
	$Pt($l) num
	set I [draw principalaxes $Pt($l)] ; list
	set "VPa($l)" [lindex $I 0] ; list
	set "VPb($l)" [lindex $I 1] ; list
	set "VPc($l)" [lindex $I 2] ; list
}

# combinations  
echo "combinations"
    for {set l 1} {$l <= [array size selections] } {incr l} {
	set anglea($l) [expr $convert*acos( [vecdot $VPa0($l) $VPa($l)] ) ]; list
	set angleb($l) [expr $convert*acos( [vecdot $VPb0($l) $VPb($l)] ) ] ; list
	set anglec($l) [expr $convert*acos( [vecdot $VPc0($l) $VPc($l)] ) ] ; list

      if {$anglea($l) > 90} {
       set anglea($l) [expr (180 - $anglea($l))]
      }
	puts $outfilea($l) $anglea($l) 	
     if {$angleb($l) > 90} {
       set angleb($l) [expr (180 - $angleb($l))] ; list
      }
	puts $outfileb($l) $angleb($l)
     if {$anglec($l) > 90} {
       set anglec($l) [expr (180 - $anglec($l))] ; list
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

# Calc Standard deviation and Kmod
puts "reading in data file"

set k 1.38064852e-23
set temp 300
set outfilekmod [open "allkmods.dat" w]
puts $outfilekmod "tors_kmod_a tors_kmod_b tors_kmod_c" 
for {set i 1} {$i <= [array size selections] } {incr i} {
    set infilea($i) [open "Pta$i.dat" r]
    set infileb($i) [open "Ptb$i.dat" r]
    set infilec($i) [open "Ptc$i.dat" r]
    set data_a($i) [read $infilea($i)]
    set data_b($i) [read $infileb($i)]
    set data_c($i) [read $infilec($i)]
    set std_a($i) [::math::statistics::stdev $data_a($i)]
    set std_b($i) [::math::statistics::stdev $data_b($i)]
    set std_c($i) [::math::statistics::stdev $data_c($i)]
    set tors_kmod_a [expr [expr [expr $k * $temp] / [expr pow($std_a($i),2)] ] * pow(10,21)]
    set tors_kmod_b [expr [expr [expr $k * $temp] / [expr pow($std_b($i),2)] ] * pow(10,21)]
    set tors_kmod_c [expr [expr [expr $k * $temp] / [expr pow($std_c($i),2)] ] * pow(10,21)]
    
    puts $outfilekmod "$tors_kmod_a $tors_kmod_b $tors_kmod_c" 

}
close $outfilekmod


##################################################################################  
# Stretching Mod Calcs
set "outfile" [open "Dist.dat" w];

set sel_top [atomselect top "backbone and (segname PROG and not resid 101 to 287 and (z > 137 and z < 151 ))"]
set sel_bottom [atomselect top "backbone and (segname PROG and not resid 101 to 287 and (z > 39 and z < 53 ))"]

for {set i 1 } {$i < $nf } { incr i } {
    $sel_top frame $i
    $sel_bottom frame $i
    set top_coord [measure center $sel_top weight mass]
    set bottom_coord [measure center $sel_bottom weight mass]
    set "dist($i)" [veclength [vecsub $top_coord $bottom_coord]]
    puts $outfile $dist($i)
}

close $outfile

##################################################################################  
# Bending Mod Calcs

# Define Sections
## z cutpoint
set center_point 95
# Make atomselections
set top [atomselect top "backbone and segname PROG and ( z > $center_point )"]
set bottom [atomselect top "backbone and segname PROG and ( z < $center_point )"]

# Open file for writing
set "outfile" [open "Bend.dat" w];

# Calculations

for {set i 1 } {$i < $nf } { incr i } {
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

##################################################################################  
# Helix only Bending Mod Calcs

# Define Sections
# Make atomselections
set top [atomselect top "backbone and segname PROG and not resid 101 to 287 and ( z > $center_point )"]
set bottom [atomselect top "backbone and segname PROG and not resid 101 to 287 and ( z < $center_point )"]

# Open file for writing
set "outfile" [open "Bend-wo-helix.dat" w];

# Calculations

for {set i 1 } {$i < $nf } { incr i } {
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


exit
