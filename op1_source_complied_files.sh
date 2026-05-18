# =============================================================================
# CODE to source the compled ACD install before run
# -----------------------------------------------------------------------------
#
# Assumes you have a working conda environment
#
# If not use: 
#
# conda create -n acd_test2 -c conda-forge python=2.7.18 root=6.16.00 xrootd=4.9.1 scons=3.1.2 f2c gcc_linux-64=7 gxx_linux-64=7 gfortran_linux-64=7
#
# Initialize:
MY_DIR=$(pwd)
export CONDA_PREFIX=/sdf/home/a/abhishek/miniconda
export PATH=${CONDA_PREFIX}/bin/:$PATH
source ${CONDA_PREFIX}/etc/profile.d/conda.sh
conda activate acd_test2
source ${MY_DIR}/ACD_calib_github_software/op1_config.sh
source ${MY_DIR}/ACD_calib_github_software/op1_setup.sh
source ${RELEASE}/_setup.sh
cd ${RELEASE}/workdir
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/sdf/group/fermi/a/ground/GLAST_EXT/redhat6-x86_64-64bit-gcc44/xrootd/xrootd-3.2.4/lib64:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=/sdf/group/fermi/a/ground/GLAST_EXT/redhat6-x86_64-64bit-gcc44/ROOT/v5.34.03-gr01/lib/:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${MY_DIR}/local_libs:$LD_LIBRARY_PATH


export XRD_TIMEOUTRESOLUTION=1
export XRD_CONNECTIONRETRY=10
export XRD_REQUESTTIMEOUT=1200
export XRD_STREAMTIMEOUT=1200
export XRD_RECONNECTWAIT=5