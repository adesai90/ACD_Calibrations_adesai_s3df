#!/bin/bash

INPUT_VALUE=$1
INPUT_PATH=$2
INPUT_DIGI_RECON_DATE=$3

ssh iana
cd $INPUT_PATH
source source_compiled_files.sh

## Verify environment was set                                                                                                                                                          
#echo "After sourcing:"                                                                                                                                                                
#echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"                                                                                                                                              
#echo "CONDA_DEFAULT_ENV: $CONDA_DEFAULT_ENV"                                                                                                                                          
#echo "PWD: $(pwd)"          

#echo "=== NODE: $(hostname) ==="                                                                                                                                                      
#echo "=== LD_LIBRARY_PATH ==="                                                                                                                                                        
#echo $LD_LIBRARY_PATH | tr ':' '\n'                                                                                                                                                   
#echo "=== libcrypto location ==="                                                                                                                                                     
#ldconfig -p | grep libcrypto                                                                                                                                                          
#echo "=== ldd on executable ==="                                                                                                                                                      
#ldd $INPUT_PATH/releases/GR-20-09-10/exe/redhat6-x86_64-64bit-gcc44-Optimized/runVetoCalib | grep crypto                                                                              
#echo "=== filesystem check ==="                                                                                                                                                       
#ls /sdf/home/a/abhishek/miniconda/envs/acd_test2/lib/libcrypto* 2>&1     

# Now run the Python job   
cd $INPUT_PATH/releases/GR-20-09-10/workdir/submitted_jobs/week_${INPUT_VALUE}/     
cp $INPUT_PATH/releases/GR-20-09-10/workdir/.rootrc .                                                                                                                                                    
python $INPUT_PATH/releases/GR-20-09-10/calibGenACD/python/AcdWeeklyReport.py 'run' -w ${INPUT_VALUE} $INPUT_PATH/releases/GR-20-09-10/workdir/DIGI_${INPUT_DIGI_RECON_DATE}.table $INPUT_PATH/releases/GR-20-09-10/workdir/RECON_${INPUT_DIGI_RECON_DATE}.table
