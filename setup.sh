# =============================================================================
# GLAST ground software group .cshrc script
# -----------------------------------------------------------------------------
#
# Assumes:
#
# 1) The variable "interactive" has been properly set
#
# =============================================================================

# =============================================================================
# Begin group setup (run for both interactive and non-interactive sessions).
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Set up access to the GLAST (both flight and ground) applications.
# -----------------------------------------------------------------------------

export GLASTROOT=/sdf/group/fermi/a #Old path: /afs/slac.stanford.edu/g/glast

export GROUPSCRIPTS=${GLASTROOT}/ground/scripts

export PATH=${PATH}:${GLASTROOT}/applications/install/@sys/usr/bin:${GLASTROOT}/ground/releases:${GROUPSCRIPTS}:${GROUPSCRIPTS}/ReleaseManager

# -----------------------------------------------------------------------------
# Set the NFS file creation mask.  This makes files created in group NFS space
# writeable by all group members, not just the author.  Has no effect in AFS
# space where file access is controlled by AFS mechanisms.
#
# There is claimed to be some CVS benefit from this as well, though the flight
# software group seems to operate perfectly happily without it.
# -----------------------------------------------------------------------------
umask 002

# -----------------------------------------------------------------------------
# Set up access to the ground software CVS repository.
# -----------------------------------------------------------------------------
export CVSROOT=/sdf/group/fermi/g/glast_ground/cvs/ # Old path: /nfs/slac/g/glast/ground/cvs
export CVS_RSH=ssh

# -----------------------------------------------------------------------------
# set up access to calibration files
# -----------------------------------------------------------------------------
export LATCalibRoot=/sdf/group/fermi/a/ground/releases/calibrations/ #Old path: /afs/slac.stanford.edu/g/glast/ground/releases/calibrations/
export LATMonRoot=/sdf/group/fermi/a/ground/releases/monitor/ #Old path: /afs/slac.stanford.edu/g/glast/ground/releases/monitor/

# -----------------------------------------------------------------------------
# Set up access to CMT:
#
# 1) Set up the CMT site name
# 2) Source the CMT setup script
# 3) Set up the directory where CMT accessed external libraries are located
# -----------------------------------------------------------------------------
#if test `uname` = "SunOS"; then
#    export CMTSITE="SLAC_Solaris"
#else
#    export CMTSITE="SLAC_UNIX"
#fi

#if test "$CMTVERSION" = "";  then
#   setenv CMTVERSION v1r8
#   setenv CMTVERSION v1r8p1
#    setenv CMTVERSION v1r9p20010927
#    setenv CMTVERSION v1r10p20011126
#    setenv CMTVERSION v1r12p20020606
#    setenv CMTVERSION v1r12p20021129
#	export CMTVERSION=v1r16p20040701
#    export CMTVERSION=v1r18p20061003
#fi

###if test "$CMTBASE" = ""; then
###   export CMTBASE=/afs/slac.stanford.edu/g/glast/applications/CMT
###fi

###source ${CMTBASE}/${CMTVERSION}/mgr/setup.sh

unameVersion=`uname -r`

###if test `expr match "$unameVersion" '2.6.9'` -gt '0';
###    then export CMTCONFIG=rhel4_gcc34opt
###elif test `expr match "$unameVersion" '2.4.21'` -gt '0';
###    then export CMTCONFIG=rh9_gcc32opt
###elif test `expr match "$unameVersion" '2.6.18'` -gt '0';  # RHEL5
###    then export CMTCONFIG=rhel4_gcc34opt
###else
###    echo "OS version unrecognized, CMTCONFIG left unset"
###fi

#case `uname` in        #Operating system-specific 
#    Linux )
#           export CMTCONFIG=rh9_gcc32 # correct for RHEL3 as well
#esac

# setenv GLAST_EXT ${GLASTROOT}/ground/external_libraries_tarballs/${CMTCONFIG}/v2
###export GLAST_EXT=/afs/slac/g/glast/ground/GLAST_EXT/${CMTCONFIG}
###export BUILDS=/nfs/farm/g/glast/u09/builds/

# Environment variable for production (vanilla) Engineering Model calibrations
export EMcalibroot=/sdf/group/fermi/a/ground/EMCalibData #Old path: /afs/slac.stanford.edu/g/glast/ground/EMCalibData

# Set up a default CMTPATH - caveat emptor - users should be careful
# about setting their own, based on which GLAST applications they want 
# to run 
#
# --- most recent version DOSEN'T set this (commented out below)
# setting CMTPATH is currently users responsibility 


###if test "$CMTPATH" = ""; then
###    export CMTPATH
###fi

# setenv CMTPATH ${CMTPATH}:/afs/slac.stanford.edu/g/glast/ground/releases/GaudiSys_v7:/afs/slac.stanford.edu/g/glast/ground/releases/gismosys_v5r4p1

# -----------------------------------------------------------------------------
# End-Station A Maintained libraries (for testbeam).
# -----------------------------------------------------------------------------
# HMK 20100209 Likely no longer used
#export ESALIBPATH=/afs/slac.stanford.edu/g/esa/glast/exp/pro-28Jan00/genlib
#export ESAINCLUDES=/afs/slac.stanford.edu/g/esa

# -----------------------------------------------------------------------------
# Set up the Adaptive Communications Environment (ACE).
# -----------------------------------------------------------------------------
# HMK 20100209 Just for testbeam setup
#export ACE_ROOT=${GLASTROOT}/ground/glastsoft/externals/${CMTCONFIG}/ACE_wrappers

#if ( ${?LD_LIBRARY_PATH} != 1 ) then
#    setenv LD_LIBRARY_PATH
#fi

# setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${ACE_ROOT}/ace

# -----------------------------------------------------------------------------
# Set up Root.
# HMK No longer setting up ROOT due to possible conflict with ROOT version
# used by software set up via CMT
# -----------------------------------------------------------------------------
#setenv ROOTSYS         ${GLASTROOT}/applications/Root/302.07/${CMTCONFIG}
#setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${ROOTSYS}/lib
#setenv PATH            ${PATH}:${ROOTSYS}/bin
#setenv ROOTFILES       /nfs/farm/g/glast/u01/rootfiles/v1.2/
#setenv CLEANFILES      /nfs/farm/g/glast/u01/cleanruns/

# Point to GLAST supported version of xrootd copy
alias xrdcp='~/miniconda/envs/acd_test/bin/xrdcp' # NOTE: REPLACE WITH GROUP CONDA ENV!!! Old path: '/afs/slac/g/glast/applications/xrootd/PROD/bin/xrdcp'

# -----------------------------------------------------------------------------
# Set up Oracle (only possible on Sun).
# -----------------------------------------------------------------------------
# if ( "`uname`" == "SunOS" ) then
#     alias  ORA-UNIX 'setenv TWO_TASK SLAC_TCP'
#     setenv TWO_TASK SLAC_TCP
#     source /usr/local/bin/coraenvp
# fi

# =============================================================================
#  Begin group setup (run for interactive sessions only).
# -----------------------------------------------------------------------------
#if ( "${interactive}" == "1" ) then

    # =========================================================================
    # System setup (interactive only).
    # =========================================================================

    # -------------------------------------------------------------------------
    # No AFS token? Get one! (It's possible to get this far without an AFS
    # token if the login was authenticated by RSA.  Note the this function
    # should be located -very carefully- in the interactive only part of
    # the .cshrc script).
    # -------------------------------------------------------------------------
 #   if ( "`which tokens | grep 'not found'`" == "" ) then
  #      if ( "`tokens | sed -n '/(AFS ID .*Expires/='`" == "" ) then
   #         klog
    #    fi
   # fi

    # Check if you are on the list of users of this script.
    # If not, add yourself to list.
    # This list is maintained for the purpose of letting people know when this 
    # script changes.  Disabled temporarily.
     
#   ${GLASTROOT}/ground/scripts/check_user

#fi

# -----------------------------------------------------------------------------
# End group setup (run for interactive sessions only).
# =============================================================================
