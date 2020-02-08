
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
set wd [lindex $argv 0]
set psf [lindex $argv 1]
set dcd [lindex $argv 2]

cd $wd

mol new $psf
mol addfile $dcd first 0 last 0

# set name of the data file
set data_file PCA.dat

# Number of sections defining angles
source selections

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
