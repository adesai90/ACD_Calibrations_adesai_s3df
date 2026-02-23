# =============================================================================
# CODE to setup ACD calibrations in user directory
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
cvs checkout calibGenACD
cvs checkout mootCore
sed -i "s/if 'CHS' in progEnv.Dictionary()\['CPPDEFINES'\]:/#if 'CHS' in progEnv.Dictionary()['CPPDEFINES']:\n    if True:/" mootCore/SConscript.sh

# Linking all the libraries correctly!
PARENT_LIB=/sdf/group/fermi/n/u52/ReleaseManagerBuild/redhat6-x86_64-64bit-gcc44/Optimized/GlastRelease/20-09-10/lib/redhat6-x86_64-64bit-gcc44-Optimized/
LOCAL_LIB=${MY_DIR}/releases/GR-20-09-10/lib/redhat8-x86_64-64bit-gcc44-Optimized/
cd $LOCAL_LIB
for lib in $PARENT_LIB/lib*.so $PARENT_LIB/lib*.a; do     ln -sf $lib $LOCAL_LIB/$(basename $lib); done


cd ${MY_DIR}
export CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"

# SCONS_MAKE FILE
read -p "Run Scons? (yes/no): " answer
if [ "$answer" = "yes" ]; then
    scons -i -C ${PARENT} --with-GLAST-EXT=${GLAST_EXT} --duplicate=soft-copy \
    --exclude=workdir --supersede=${RELEASE} --rm --compile-opt \
    --with-cc=${MY_DIR}/ACD_calib_github_software/gcc_linker \
    --with-cxx=${MY_DIR}/ACD_calib_github_software/gpp_linker --debug=explain $* > ${MY_DIR}/ACD_calib/build_out.log 2> ${MY_DIR}/ACD_calib/build_err.log
fi
