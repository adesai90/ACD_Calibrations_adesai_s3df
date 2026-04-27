# =============================================================================
# CODE to install ACD calibrations in user directory
# -----------------------------------------------------------------------------
#
# Assumes you have a working conda environment
#
# If not use: 
#
# conda create -n acd_test2 -c conda-forge python=2.7.18 root=6.16.00 xrootd=4.9.1 scons=3.1.2 f2c gcc_linux-64=7 gxx_linux-64=7 gfortran_linux-64=7 libtiff swig
# 
#
# Initialize:


git_dir=$(pwd)
echo "Git dir is ${git_dir}"

if [ -d "${git_dir}/calibGenACD-master" ]; then
    echo "Fermi calibGenACD git directory found."
else
    echo "The repository should exist! If you clone a new one, Make sure the paths on the cloned repositoiry are correct"
    #git clone "https://github.com/fermi-lat/calibGenACD.git" calibGenACD-master #(incorrect paths!)
fi

cd ..
MY_DIR=$(pwd)

/Users/aadesai1/Desktop/In_use/ACD_calibrations/calibGenACD-master/src/AcdCalibMap.cxx
# Delete past builds
# This portion is to be run with cvs checkout calibgenacd and NOT github calibgenacd.
read -p "Update AcdCalibBase and AcdJobConfig files? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        cp ${git_dir}/calibGenACD-master/src/AcdCalibBase.cxx ${git_dir}/calibGenACD-master/src/AcdCalibBase_org.cxx
        cp ${git_dir}/calibGenACD-master/src/AcdJobConfig.cxx ${git_dir}/calibGenACD-master/src/AcdJobConfig_org.cxx
        cp ${git_dir}/calibGenACD-master/src/AcdJobConfig.h ${git_dir}/calibGenACD-master/src/AcdJobConfig_org.h
        cp ${git_dir}/support_files/AcdCalibBase.cxx ${git_dir}/calibGenACD-master/src/AcdCalibBase.cxx
        cp ${git_dir}/support_files/AcdJobConfig.cxx ${git_dir}/calibGenACD-master/src/AcdJobConfig.cxx
        cp ${git_dir}/support_files/AcdJobConfig.h ${git_dir}/calibGenACD-master/src/AcdJobConfig.h
        echo "----modified----"
    fi
echo "----done----"

echo "There are two options for the setup of ACD calibrations software."
echo "1. Setup using links to /sdf/group/fermi/"
echo "   - This will follow a setup which requires a user based conda environment along with a setup which uses conda based installs built for the sole purpose of running ACD Calibration codes."
echo "2. Using a container which links to the old /afs paths by using bind mount"
echo "   - This will follow a setup which uses containerization to replicate the old environment. This is similar to the other software run on s3df"

read -p "Select (1 or 2): " answer
if [ "$answer" = "1" ]; then
    echo "Running option 1. Setup using links to /sdf/group/fermi/"
    export CONDA_PREFIX=/sdf/home/a/abhishek/miniconda
    export PATH=${CONDA_PREFIX}/bin/:$PATH
    source ${CONDA_PREFIX}/etc/profile.d/conda.sh
    conda activate acd_test2
    source ${MY_DIR}/ACD_calib_github_software/op1_config.sh
    source ${MY_DIR}/ACD_calib_github_software/op1_setup.sh
    chmod +x ${MY_DIR}/ACD_calib_github_software/gcc_linker
    chmod +x ${MY_DIR}/ACD_calib_github_software/gpp_linker

    # FIX ROOT to make sure glast root is used!
    export ROOTSYS=/sdf/group/fermi/a/ground/GLAST_EXT/redhat6-x86_64-64bit-gcc44/ROOT/v5.26.00a-gl2/gcc44
    #export PATH=$ROOTSYS/bin:$(echo $PATH | tr ':' '\n' | grep -v miniconda | grep -v conda | tr '\n' ':')
    export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH
    unset CONDA_PREFIX_ROOT
    unset ROOTSYS_CONDA

    hash -r

    echo "Using GLAST ROOT:"
    which root-config
    root-config --version
    export GLAST_ROOT_OVERRIDE=1

    echo "ROOTSYS=$ROOTSYS"
    which root-config
    root-config --version
    root-config --libdir
    

    # Delete past builds
    echo "Current working Directory: ${MY_DIR}"
    read -p "Delete Past Build, removes files in releases, python and workdir? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        rm -rf ${MY_DIR}/releases/GR-20-09-10/
        rm -rf ${MY_DIR}/releases/GR-20-09-10/python/
        rm -rf ${MY_DIR}/releases/GR-20-09-10/workdir/
        mkdir ${MY_DIR}/releases/
        mkdir ${MY_DIR}/releases/GR-20-09-10/
        mkdir ${MY_DIR}/releases/GR-20-09-10/python/
        mkdir ${MY_DIR}/releases/GR-20-09-10/workdir/
    fi

    # Setting up environments

    cd ${MY_DIR}/releases/GR-20-09-10/
    read -p "Add calibGebACD, mootcore and links to home directory? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        #cvs checkout calibGenACD
        mkdir ${MY_DIR}/releases/GR-20-09-10/calibGenACD/
        cp -r ${git_dir}/calibGenACD-master/* ${MY_DIR}/releases/GR-20-09-10/calibGenACD/
        chmod -R +x ${MY_DIR}/releases/GR-20-09-10/calibGenACD/
        cvs checkout mootCore
        #chmod -R +x ${MY_DIR}/releases/GR-20-09-10/mootCore/*
        perl -i -pe "s/if 'CHS' in progEnv\.Dictionary\(\)\['CPPDEFINES'\]:/\#if 'CHS' in progEnv.Dictionary()['CPPDEFINES']:\nif True:/g" mootCore/SConscript #This is from the installation instructions on DGreen
    fi


    #cp ${git_dir}/support_files/AcdCalibBase.cxx ${MY_DIR}/releases/GR-20-09-10/calibGenACD/src/AcdCalibBase.cxx
    #cp ${git_dir}/support_files/AcdJobConfig.cxx ${MY_DIR}/releases/GR-20-09-10/calibGenACD/src/AcdJobConfig.cxx
    #cp ${git_dir}/support_files/AcdJobConfig.h ${MY_DIR}/releases/GR-20-09-10/calibGenACD/src/AcdJobConfig.h
    # Linking all the libraries correctly!


    cd ${MY_DIR}
    export CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"
    
    #export PATH=~/miniconda/envs/acd_test2/bin/root:$PATH
    #export PATH=/sdf/group/fermi/a/ground/GLAST_EXT/redhat6-x86_64-64bit-gcc44/ROOT/v5.34.03-gr01/bin/:$PATH #For some reason root was not loading so added this
    #export LD_LIBRARY_PATH=/sdf/group/fermi/a/ground/GLAST_EXT/redhat6-x86_64-64bit-gcc44/openssl/1.0.2/lib:$LD_LIBRARY_PATH
    
    ln -s /sdf/group/fermi/a/ground/GLAST_EXT/redhat6-x86_64-64bit-gcc44/f2c/3.4-gl2/gcc44 /sdf/group/fermi/a/ground/GLAST_EXT/redhat6-x86_64-64bit-gcc44/f2c/3.4-gl2/gcc85
    # SCONS_MAKE FILE
    read -p "Run Scons, this will take some time? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        echo "Starting Scons build...do not interrupt!"
        scons -i -C ${PARENT} --variant=redhat6-x86_64-64bit-gcc44-Optimized --cxxflags="-D_GLIBCXX_USE_CXX11_ABI=0"\
        --with-GLAST-EXT=${GLAST_EXT} --duplicate=soft-copy --with-root-dir=${ROOTSYS}\
        --exclude=workdir --supersede=${RELEASE} --rm --compile-opt \
        --with-cc=${MY_DIR}/ACD_calib_github_software/gcc_linker \
        --with-cxx=${MY_DIR}/ACD_calib_github_software/gpp_linker --debug=explain $* > build_out.log 2> build_err.log
    fi

    echo "Scons command ran, check build files for log and error, fixing some harcoded paths now"

    #cvs checkout calibGenACD
    #cp -r ${git_dir}/calibGenACD-master/* ${MY_DIR}/releases/GR-20-09-10/calibGenACD/
    #chmod -R +x ${MY_DIR}/releases/GR-20-09-10/calibGenACD/
    #echo "Rebuilding Scons with modified files"
    #scons -i -C ${PARENT} --variant=redhat6-x86_64-64bit-gcc44-Optimized --cxxflags="-D_GLIBCXX_USE_CXX11_ABI=0"\
    #    --with-GLAST-EXT=${GLAST_EXT} --duplicate=soft-copy \
    #    --exclude=workdir --supersede=${RELEASE} --rm --compile-opt \
    #    --with-cc=${MY_DIR}/ACD_calib_github_software/gcc_linker \
    #    --with-cxx=${MY_DIR}/ACD_calib_github_software/gpp_linker --debug=explain $* > build_ou2.log 2> build_err2.log
   
        
    
    perl -i -pe 's|/afs/slac/g/glast/ground/bin/|${RELEASE}/fermi_ground_bin_files|g' \
        ${MY_DIR}/releases/GR-20-09-10/calibGenACD/python/ParseFileListNew.py \
        ${MY_DIR}/releases/GR-20-09-10/calibGenACD/python/ParseFileList.py \
        ${MY_DIR}/releases/GR-20-09-10/mootCore/cmt/requirements

    # If you want to manually check if there are /afs paths, run grep -rn "/afs/slac/g/glast/" /sdf/home/a/abhishek/ACD_calib/releases/GR-20-09-10/ 2>/dev/null

    cd ${MY_DIR}/releases/GR-20-09-10/calibGenACD/python/
    perl -i -pe 's|/Data/Flight/Level1/LPA/ > %s|/Data/Flight/Level1/LPA/ 2>\\/dev\\/null \| grep \x27^root:\\/\\/\x27 > %s|' ParseFileListNew.py

    
    #read -p "Modify AcdReportUtil.py, to writte to local working directory instead of latmonroot? (yes/no): " answer
    #if [ "$answer" = "yes" ]; then
    #    LOCAL_OUT="./acd_output"
    #    FILE=${MY_DIR}/releases/GR-20-09-10/calibGenACD/python/AcdReportUtil.py
    #    perl -i -pe 's|(ACDMONROOT = os\.path\.join.*\n)|$1LOCAL_OUTDIR = os.environ.get("ACD_LOCAL_OUT", "./acd_output")\n os.makedirs(LOCAL_OUTDIR) if not os.path.exists(LOCAL_OUTDIR) else None\n|' $FILE
    #    perl -i -pe 's|(    outFileName = inFileName \+ ".bak")|    #$1\n    outFileName = os.path.join(LOCAL_OUTDIR, os.path.basename(inFileName) + ".bak")|g' $FILE
    #    perl -i -pe 's|(    outFileName = indexFileName \+ ".bak")|    #$1\n    outFileName = os.path.join(LOCAL_OUTDIR, os.path.basename(indexFileName) + ".bak")|g' $FILE
    #    perl -i -pe 's|^(    os\.rename\(outFileName,inFileName\))|    #$1|g' $FILE
    #    perl -i -pe 's|^(    os\.rename\(outFileName,indexFileName\))|    #$1|g' $FILE
    #    perl -i -pe 's|^(        os\.rename\(os\.path\.join.*\))|        #$1|g' $FILE
    #    echo "Changes made!"

    read -p "Add links to local libraries? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        mkdir -p ${MY_DIR}/local_libs
        ln -sf /lib64/libcrypto.so.3 ${MY_DIR}/local_libs/libcrypto.so.10
        ln -sf /lib64/libssl.so.3 ${MY_DIR}/local_libs/libssl.so.10
        export LD_LIBRARY_PATH=${MY_DIR}/local_libs:$LD_LIBRARY_PATH
    fi
    read -p "Add to root paths to make sure there are no error? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        cd $git_dir
        ./update_canvas_code.pl
    fi

    cp ${MY_DIR}/releases/GR-20-09-10/bin/redhat6-x86_64-64bit-gcc44-Optimized/_setup.sh ${MY_DIR}/releases/GR-20-09-10/
    cp ${git_dir}/op1_source_complied_files.sh ${MY_DIR}/source_compiled_files.sh
    #cp ${git_dir}/calibGenACD-master/python/Acd* ${MY_DIR}/releases/GR-20-09-10/calibGenACD/python/
    cp ${MY_DIR}/releases/GR-20-09-10/mootCore/build/redhat6-x86_64-64bit-gcc44-Optimized/src/py_mootCore.py ${MY_DIR}/releases/GR-20-09-10/python/


else
    echo "Running option 2. Using a container which links to the old /afs paths by using bind mount"
    echo "######################################################################"
    echo "Run ${git_dir}/start_rhel6.sh before starting this"
    echo "Also need to install scons using cd /afs/slac/g/glast/applications/SCons/scons-2.1.0/"
    echo "               and  python setup.py install --user"
    echo "               and export PATH=/sdf/home/a/abhishek/.local/bin:$PATH"
    echo "######################################################################"
    source ${MY_DIR}/ACD_calib_github_software/op2_config.sh
    source ${MY_DIR}/ACD_calib_github_software/op2_setup.sh
    
    

    read -p "Are you on container (yes/no):  " answer
    if [ "$answer" = "yes" ]; then
        echo "Continuing.."
    fi


    # Delete past builds
    echo "Current working Directory: ${MY_DIR}"
    read -p "Delete Past Build, removes files in releases, python and workdir? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        rm -rf ${MY_DIR}/releases/GR-20-09-10/
        rm -rf ${MY_DIR}/python/
        rm -rf ${MY_DIR}/workdir/
        mkdir ${MY_DIR}/releases/
        mkdir ${MY_DIR}/releases/GR-20-09-10/
        mkdir ${MY_DIR}/python/
        mkdir ${MY_DIR}/workdir/
    fi

    # Setting up environments

    cd releases/GR-20-09-10/
    export CVSROOT=/sdf/group/fermi/g/glast_ground/cvs/
    read -p "Add calibGebACD, mootcore and links to home directory? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        cvs checkout calibGenACD
        cvs checkout mootCore
        perl -i -pe "s/if 'CHS' in progEnv\.Dictionary\(\)\['CPPDEFINES'\]:/\#if 'CHS' in progEnv.Dictionary()['CPPDEFINES']:\nif True:/g" mootCore/SConscript #This is from the installation instructions on DGreen
    fi

    cd ${MY_DIR}
    export PATH=/sdf/home/a/abhishek/.local/bin:$PATH
    # SCONS_MAKE FILE
    echo "current directory $(pwd) which shouls be ${MY_DIR}"
    read -p "Run Scons, this will take some time? (yes/no): " answer
    if [ "$answer" = "yes" ]; then
        echo "Starting Scons build...do not interrupt!"
        scons -i -C ${PARENT} \
        CPPPATH=/sdf/home/i/imereu/.conda/envs/fermipy/include \
        LIBPATH=/sdf/home/i/imereu/.conda/envs/fermipy/lib \
        CLHEP_ROOT=/sdf/home/i/imereu/.conda/envs/fermipy \
        --with-GLAST-EXT=${GLAST_EXT} --duplicate=soft-copy \
        --exclude=workdir --supersede=${RELEASE} --rm --compile-opt \
        --with-cc=${MY_DIR}/ACD_calib_github_software/gcc_linker \
        --with-cxx=${MY_DIR}/ACD_calib_github_software/gpp_linker --debug=explain $* > build_out.log 2> build_err.log
    fi

    echo "Scons command ran, check build files for log and error, fixing some harcoded paths now"
    
    cp ${git_dir}/op2_source_complied_files.sh ${MY_DIR}/source_compiled_files.sh
fi
