#!/usr/bin/env tcl

############################################################## 
# 
# Author:               John Vant 
# Email:              jvant@asu.edu 
# Affiliation:   ASU Biodesign Institute 
# Date Created:          200206
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
package require psfgen
resetpsf
topology /home/jvant/Documents/toppar/top_all36_prot.rtf

#set oldpsf [glob *psf]
set oldpsf [lindex $argv 0]
set olddcd [lindex $argv 1]
set newpsf my.psf
mol new $oldpsf
mol addfile $olddcd first 0 last 0 waitfor all

sleep 1

set all [atomselect top all]
$all num
puts "wtf"
$all writepdb tmp.pdb 

mol delete all

readpsf $oldpsf
coordpdb tmp.pdb
mol new $oldpsf
mol addfile tmp.pdb

set sel1 [atomselect top "protein"]
set sel2 [atomselect top "not protein"]

set indices [$sel1 get index] 

puts "Your new dcd will have [$sel1 num] atoms"
sleep 4

set file [open my.ind w] 
foreach i $indices { 
    puts $file $i 
} 
  
flush $file 
close $file 

# set nseg 1
# set chains [lsort -unique [$sel1 get segid]]
# puts "$chains"
# foreach ch $chains {
    
#     set selch [atomselect top "segid $ch"]
#     $selch writepdb chain_$ch.pdb
# }

# foreach ch $chains {
#     set segid V$nseg
#     segment $segid {
# 	first NONE
# 	last NONE
# 	pdb chain_$ch.pdb
#     }
#     coordpdb chain_$ch.pdb $segid
#     incr nseg
# }

# guesscoord
# writepsf my.psf
# writepdb my.pdb

# readpsf $oldpsf
# coordpdb tmp.pdb


# foreach segid [lsort -unique [$sel2 get segid]] {
#     foreach resid [lsort -unique [$sel2 get resid]] {
# 	foreach atomname [lsort -unique [$sel2 get name]] { 
#             delatom $segid $resid $atomname
# 	}
#     }
# }

puts "Writing your new psf!!!!"
$sel1 writepsf my.psf
exit


