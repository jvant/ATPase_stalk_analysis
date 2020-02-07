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
set wd [lindex $argv 2]
set topdir [pwd]
set newpsf my.psf

cd $wd

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

puts "Writing your new psf!!!!"
$sel1 writepsf my.psf

cd $topdir

exit


