# ACD Calibration directory legend for main files:
- setup_package.sh: setup to be used for working (in devlopment)  ACD calibrations
- DGreen_ACD_Calib_Constants_Memo.pdf: Memo from David Green regarding setup of ACD calibrations in previous (afs) setup from https://confluence.slac.stanford.edu/spaces/SCIGRPS/pages/132221608/ACD+Calibrations+Monthly+Update
- Other supplimentary files include the fermi_ground_bin_files are supplemntary files used to help with the install.




# INSTALLATION:
- Make a folder on SLAC where you want the ACD_Calibration to live, for example: 
```bash 
mkdir ACD_Calibration
``` 
- INSIDE this FOLDER, Download this github repository. Make sure this is done INSIDE the folder, as the github setup uses cd .. and then installs all the directories there. This is done by 
```bash 
cd ACD_Calibration
``` 
and 
```bash
git clone git@github.com:adesai90/ACD_Calibrations_adesai_s3df.git ACD_calib_github_software
``` 
> [!NOTE]
> Make sure the github folder name is set to "ACD_calib_github_software". 

FOLLOW THESE STEPS BEFORE INSTALLING: 
- Before Setup, You NEED a conda environment. In the default case, miniconda is used, with a setup pointing to the directory of the user abhishek. You need to:
    1. Install miniconda (If you use anything other than miniconda, make the changes in the setup.sh file too, namely In setup_package.sh, change CONDA_PREFIX path from "$HOME/miniconda" to your directory with the newly installed conda)
    2. You also need to create a special conda environemnt called "acd_env" which will be used by this code. (Note you can use some other name, if you use anything other than acd_env, make the changes in setup_package.sh) After activating conda run:
    ```bash 
    conda create -n acd_env -c conda-forge python=2.7.18 root=6.16.00 xrootd=4.9.1 scons=3.1.2 f2c gcc_linux-64=7 gxx_linux-64=7 gfortran_linux-64=7 libtiff swig
    ```
    > [!NOTE]
    > If everything was done correctly, source ${CONDA_PREFIX}/etc/profile.d/conda.sh should activate your conda setup, If you get a conda error during the setup, something went wrong in the setup while reading your conda environment.
- You should be ready to run the install using ```bash source setup_package.sh``` which should do eveything for you! 
- On every prompt answer yes/no as required (In an ideal install, everything is answered Yes)
- Check the error and install logs, if everything went well your build_err log will be empty! 
Note: If you get minor warnings you can ignore, but in case of major errors please contact the developers.


# USAGE (NOTE: INITIAL SETUP FOR TESTING AND NORMAL USE CASES ARE DIFFERENT, DEFAULT is TESTING):
As a failsafe, by default the codes are set to write only in your home directory and not update </sdf/group/fermi/ground/releases/monitor/ACD>, this is to make sure that the code is running properly before the files are written in the main ACD Calibrations directory.

### For Testing (By default all of there are already commented out, just check to make sure before running):
- In your install directory, ``` {path to directory..}\releases/GR-20-09-10/calibGenACD/python/AcdReportUtil``` , lines 270 to 283 (from 
```python  
if not os.path.exists(toDir): #HF 
``` 
 to 
 ```python
 addStore(idFt,options.tag,options.comment,htmlName)
 ```  
 should be commented out 
- In your install directory, ``` {path to directory..}\releases/GR-20-09-10/calibGenACD/python/AcdReportTrend``` , lines 126 to 133 (from 
```python 
sysCom = "mkdir -p %s" % saveDir 
```  
to 
```python 
os.system(sysCom)
```  
should be commented out 
###For Running Normally:
- Uncomment the lines that were commented out for TESTING (see above) in  AcdReportUtil and AcdReportTrend 


## How to run (This process is the same for Testing or Normal cases):
- Go to the folder where the setup is installed and run 
```bash 
source source_compiled_files.sh
```
- This should get the code ready for running and take you to``` {path to directory..}/releases/GR-20-09-10/workdir```  in your install, This is your working directory
- Here, before anything you need to parse the data catalog using 
```bash 
python $RELEASE/calibGenACD/python/ParseFileListNew.py DIGI
``` 
and 
```bash 
python $RELEASE/calibGenACD/python/ParseFileListNew.py RECON
``` 
which should make 2 DIGI and 2 RECON files with a date indentifier. For this example say the names are <DIGI_260727> and <RECON_260727>. (see also DGreen_ACD_Calib_Constants_Memo.pdf for more details)
- NOTE: In case of the above code gives an error with parsefiles, check to see that the datacatbin is pointing to the right directory in Parsefilenew.py, it should be 
```python  
DATACATBIN = "/sdf/group/fermi/a/ground/bin/datacat" 
``` 
- Next you can go back to your install directory by using 
```bash 
cd ../../../
```
- Here you can submit a job directly to the cluster to run your code. Example job submission for week 882 and DIGI/RECON date value of 260727 is: 
```bash 
source submit_jobs.sh "882" "/sdf/home/a/abhishek/ACD_calib_using_paths_conda" "260727"
```
- In case of testing this will save all the outputs in ``` {path to directory..}releases/GR-20-09-10/workdir/submitted_jobs/week_882/```  and in the case of running normally it will save the log in ``` {path to directory..}releases/GR-20-09-10/workdir/submitted_jobs/week_882/```  and actual calibration files in ``` /sdf/group/fermi/ground/releases/monitor/ACD``` 

##For Trend plots:
- This uses all the information saved at ``` /sdf/group/fermi/ground/releases/monitor/ACD```  and will modify the trend codes saved there if testing mode is not on.
- To run do 
```bash 
python $RELEASE/calibGenACD/python/AcdWeeklyReport.py 'trend'
```




# Possbile errors :
- See full logfile for error and changes done during the move to s3df.
- Datacatbin in parlefilenew.py
- Library errors while submitting jobs. Recheck that all the local_libraries are linked properly.


# Copyright (Fermi ACD software labeled calibGenACD-master and mootcore-master)
Copyright 2019 Fermi-LAT Collaboration

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

