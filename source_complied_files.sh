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
cd ..
MY_DIR=$(pwd)
export CONDA_PREFIX=/sdf/home/a/abhishek/miniconda
export PATH=${CONDA_PREFIX}/bin/:$PATH
source ${CONDA_PREFIX}/etc/profile.d/conda.sh
conda activate acd_test2
source ${MY_DIR}/ACD_calib_github_software/config.sh
source ${MY_DIR}/ACD_calib_github_software/setup.sh
source ${RELEASE}/_setup.sh
cd ${RELEASE}/workdir
export LD_LIBRARY_PATH=${MY_DIR}/local_libs:$LD_LIBRARY_PATH
export LIBGL_ALWAYS_INDIRECT=1
export LIBGL_ALWAYS_SOFTWARE=1
export MESA_LOADER_DRIVER_OVERRIDE=softpipe
export ROOTSYS_NO_GL=1
export GDK_GL=disable

# Force ROOT to use pure X11 backend
export ROOTENV_NO_OPENGL=1