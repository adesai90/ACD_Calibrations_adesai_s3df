# =============================================================================
# CODE to install ACD calibrations in user directory
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
chmod +x ${MY_DIR}/ACD_calib_github_software/gcc_linker
chmod +x ${MY_DIR}/ACD_calib_github_software/gpp_linker

# Delete past builds
echo "Current working Directory: ${MY_DIR}"
read -p "Delete Past Build, removes files in releases, python and workdir? (yes/no): " answer
if [ "$answer" = "yes" ]; then
    rm -rf releases/GR-20-09-10/*
    rm -rf python/*
    rm -rf workdir/*
fi

# Setting up environments

cd releases/GR-20-09-10/
read -p "Add calibGebACD, mootcore and links to home directory? (yes/no): " answer
if [ "$answer" = "yes" ]; then
    cvs checkout calibGenACD
    cvs checkout mootCore
    perl -i -pe "s/if 'CHS' in progEnv\.Dictionary\(\)\['CPPDEFINES'\]:/\#if 'CHS' in progEnv.Dictionary()['CPPDEFINES']:\nif True:/g" mootCore/SConscript
fi

# Linking all the libraries correctly!


cd ${MY_DIR}
export CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"

# SCONS_MAKE FILE
read -p "Run Scons, this will take some time? (yes/no): " answer
if [ "$answer" = "yes" ]; then
    echo "Starting Scons build...do not interrupt!"
    scons -i -C ${PARENT} --variant=redhat6-x86_64-64bit-gcc44-Optimized --cxxflags="-D_GLIBCXX_USE_CXX11_ABI=0"\
    --with-GLAST-EXT=${GLAST_EXT} --duplicate=soft-copy \
    --exclude=workdir --supersede=${RELEASE} --rm --compile-opt \
    --with-cc=${MY_DIR}/ACD_calib_github_software/gcc_linker \
    --with-cxx=${MY_DIR}/ACD_calib_github_software/gpp_linker --debug=explain $* > build_out.log 2> build_err.log
fi
