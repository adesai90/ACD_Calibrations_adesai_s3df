# ACD Calibration directory legend:
- calibGenACD-master: Directory containing Github master branch copy from https://github.com/fermi-lat/calibGenACD/tree/master
- setup.sh: setup to be used for working (in devlopment)  ACD calibrations
- DGreen_ACD_Calib_Constants_Memo.pdf: Memo from David Green regarding setup of ACD calibrations in previous (afs) setup from https://confluence.slac.stanford.edu/spaces/SCIGRPS/pages/132221608/ACD+Calibrations+Monthly+Update


# Issue:
Currently, the code uses inner files of GLASTROOT (either in \afs directory or \sdf, doesnt matter) which points to internal values of \nfs. 

# Fix Feb 10 2026:
- Go though individual paths to make sure that files that are read have no issues of path.
    -
