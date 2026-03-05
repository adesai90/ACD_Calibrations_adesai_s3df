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
source ${MY_DIR}/ACD_calib_github_software/op2_config.sh
source ${MY_DIR}/ACD_calib_github_software/op2_setup.sh
source ${RELEASE}/_setup.sh
cd ${RELEASE}/workdir
export LD_LIBRARY_PATH=${MY_DIR}/local_libs:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH