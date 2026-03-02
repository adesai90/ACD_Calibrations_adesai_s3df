# ACD Calibration directory legend:
- calibGenACD-master: Directory containing Github master branch copy from https://github.com/fermi-lat/calibGenACD/tree/master
 (note this this is a copy of a Fermi-LAT owned repository, see below for copyright)
- setup.sh: setup to be used for working (in devlopment)  ACD calibrations
- DGreen_ACD_Calib_Constants_Memo.pdf: Memo from David Green regarding setup of ACD calibrations in previous (afs) setup from https://confluence.slac.stanford.edu/spaces/SCIGRPS/pages/132221608/ACD+Calibrations+Monthly+Update




# Steps:
- Download github folder on slac
- Setup conda environment using (setup.sh for now), later make it accessible by all
- Create Conda environment for install using \\ conda create -n acd_test2 -c conda-forge python=2.7.18 root=6.16.00 xrootd=4.9.1 scons=3.1.2 f2c gcc_linux-64=7 gxx_linux-64=7 gfortran_linux-64=7 libtiff \\
- Check and run setup_package.sh which should do eveything for you! 
- Note that the ACD files are run using for example $RELEASE/calibGenACD/python/AcdWeeklyReport.py in the workdirectory if required.
- The ACD codes try to write in the /sdf/group directory currently

# Possbile errors:
- MAKE SURE you run cvs checkout in the $RELEASE directory
- Also make sure scons package has the correct python linked to it in the first line 
- See full logfile which lists steps taken to move the code to s3df.


# Copyright (Fermi ACD software labeled calibGenACD-master)
Copyright 2019 Fermi-LAT Collaboration

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


