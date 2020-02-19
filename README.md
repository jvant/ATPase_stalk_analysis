# ATPase Coiled-Coil Analysis

This code uses the principle axis algorithm in VMD to calculate angular fluctuations of atom selections.  To run this analysis you will need to have VMD installed and python installed.

# Running
To run the analysis run the following command in this terminal.

$ /path/to/exec/vmd -dispdev text -e MasterMod.tcl -args -psf <psffile> -dcd <dcdfile>

Run the executable pca.py to perform a principle component analysis dimentional reduction.

$ ./pca.py

More functionality is coming soon.
