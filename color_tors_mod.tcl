
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
# set beta values based on k-modulus
#
#
##################################################################################
#                            Parameters
#
# Input structure name below
set psf [glob ../3-fixedf1head_Summit/*psf]
set pdb [glob ../3-fixedf1head_Summit/chain_A-H_fixed.pdb]

mol new $psf
mol addfile $pdb

# set name of the data file
set data_file torsional_kmods.txt

# Number of sections defining angles
set numsect 8

for {set i 0} {$i < $numsect} {incr i} {
    set k [expr $i + 1]
    set bound(up) [expr 151 - $i * 14]
    set bound(low) [expr 151 - $k * 14]
    set "Pt($k)" [atomselect top "segname PROG and not resid 101 to 287 and (z > $bound(low) and z < $bound(up) )"]
    puts $Pt($k)
}
# Read in data file

set openfile [open "$data_file" r]
set data [read $openfile]
set new [split $data]

# set beta = 0
set sel_all [atomselect top all]
$sel_all set beta 0

echo "enter loop"

# start for loop to set beta values for each section defined above
for {set i 1} {$i <= $numsect} {incr i} {
    regsub .{5}$ [lindex $new [expr $i * 2 - 1]] {} new_var
    echo $new_var
    $Pt($i) set beta [lindex $new_var ]
}

$sel_all writepsf beta_colored.psf
$sel_all writepdb beta_colored.pdb
