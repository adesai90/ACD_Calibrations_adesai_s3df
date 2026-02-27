# =============================================================================
# CODE to install ACD calibrations in user directory
# -----------------------------------------------------------------------------
#
# Assumes you have a working conda environment
#
# If not use: 
#
# conda create -n acd_test2 -c conda-forge python=2.7.18 root=6.16.00 xrootd=4.9.1 scons=3.1.2 f2c gcc_linux-64=7 gxx_linux-64=7 gfortran_linux-64=7 libtiff
# 
#
# Initialize:
git_dir=$(pwd)
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

echo "Scons command ran, check build files for log and error, fixing some harcoded paths now"

cp -r ${git_dir}/fermi_ground_bin_files PN

perl -i -pe 's|/afs/slac/g/glast/ground/bin/|${RELEASE}/fermi_ground_bin_files|g' \
    ${MY_DIR}/releases/GR-20-09-10/calibGenACD/python/ParseFileListNew.py \
    ${MY_DIR}/releases/GR-20-09-10/calibGenACD/python/ParseFileList.py \
    ${MY_DIR}/releases/GR-20-09-10/mootCore/cmt/requirements

# If you want to manually check if there are /afs paths, run grep -rn "/afs/slac/g/glast/" /sdf/home/a/abhishek/ACD_calib/releases/GR-20-09-10/ 2>/dev/null

cd ${MY_DIR}/releases/GR-20-09-10/calibGenACD/python/
perl -i -pe 's|/Data/Flight/Level1/LPA/ > %s|/Data/Flight/Level1/LPA/ 2>\\/dev\\/null \| grep \x27^root:\\/\\/\x27 > %s|' ParseFileListNew.py


read -p "Modify AcdReportUtil.py, to writte to local working directory instead of latmonroot? (yes/no): " answer
if [ "$answer" = "yes" ]; then
    LOCAL_OUT="./acd_output"
    FILE=${MY_DIR}/releases/GR-20-09-10/calibGenACD/python/AcdReportUtil.py
    perl -i -pe 's|(ACDMONROOT = os\.path\.join.*\n)|$1LOCAL_OUTDIR = os.environ.get("ACD_LOCAL_OUT", "./acd_output")\n os.makedirs(LOCAL_OUTDIR) if not os.path.exists(LOCAL_OUTDIR) else None\n|' $FILE
    perl -i -pe 's|(    outFileName = inFileName \+ ".bak")|    #$1\n    outFileName = os.path.join(LOCAL_OUTDIR, os.path.basename(inFileName) + ".bak")|g' $FILE
    perl -i -pe 's|(    outFileName = indexFileName \+ ".bak")|    #$1\n    outFileName = os.path.join(LOCAL_OUTDIR, os.path.basename(indexFileName) + ".bak")|g' $FILE
    perl -i -pe 's|^(    os\.rename\(outFileName,inFileName\))|    #$1|g' $FILE
    perl -i -pe 's|^(    os\.rename\(outFileName,indexFileName\))|    #$1|g' $FILE
    perl -i -pe 's|^(        os\.rename\(os\.path\.join.*\))|        #$1|g' $FILE
    echo "Changes made!"

read -p "Add links to local libraries? (yes/no): " answer
if [ "$answer" = "yes" ]; then
    mkdir -p ${MY_DIR}/local_libs
    ln -sf /lib64/libcrypto.so.3 ${MY_DIR}/local_libs/libcrypto.so.10
    ln -sf /lib64/libssl.so.3 ${MY_DIR}/local_libs/libssl.so.10
    export LD_LIBRARY_PATH=${MY_DIR}/local_libs:$LD_LIBRARY_PATH

read -p "Add to root paths to make sure there are no error? (yes/no): " answer
if [ "$answer" = "yes" ]; then
    cd $git_dir
    ./update_canvas_code.pl ${MY_DIR}/releases/GR-20-09-10/calibGenACD/src/AcdCalibUtil.cxx ${MY_DIR}/releases/GR-20-09-10/calibGenACD/src/AcdPadMap.cxx