
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
set path "/local/jvant/ATPase_analysis"
# Input structure name below
foreach sys {0-whole_atp 2-cutIJ-noHchain_atp 4-whole-disu_atp \
		 1-cutIJ_atp 3-F1head-fixed_atp 5-cutIJ-disu_atp} {
    mol new $path/$sys/beta_colored.psf
    mol addfile $path/$sys/beta_colored.pdb
    mol reprsentation NewCartoon
    
}


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

set sel_all [atomselect top all]
$sel_all set beta 0

puts "enter loop"
# start for loop to set beta values for each section defined above
set count 0
foreach name [lsort [array names selections]] {
    
    set sel [atomselect top "$selections($name)"]
    $sel set beta [lindex $data $count]
    incr count
}

$sel_all writepsf beta_colored.psf
$sel_all writepdb beta_colored.pdb
exit
