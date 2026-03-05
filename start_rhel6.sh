#!/usr/bin/bash

CONTAINERDIR=/sdf/group/fermi/sw/containers
CONTAINER_IMAGE=$CONTAINERDIR/fermi-rhel6.sif

apptainer shell -B /sdf:/sdf \
	  -B /etc:/etc \
	  -B /lscratch:/lscratch \
	  -B /sdf/group/fermi/n:/nfs/farm/g/glast \
	  -B /sdf/group/fermi/a:/afs/slac.stanford.edu/g/glast \
	  -B /sdf/group/fermi/a:/afs/slac/g/glast \
	  -B /sdf/group/fermi/sw/package:/afs/slac/package \
	  -B /sdf/group/fermi/sw/package:/afs/slac.stanford.edu/package \
	  -B /sdf/group/fermi/sw/java/jdk/jdk8:/usr/lib/jvm/jre-1.8.0-openjdk \
	  -B $CONTAINERDIR/rhel6/opt/TWWfsw:/opt/TWWfsw \
	  -B $CONTAINERDIR/rhel6/opt/intel:/opt/intel \
	  -B $CONTAINERDIR/rhel6/usr/local:/usr/local \
      -B /usr/share/fonts:/usr/share/fonts:ro \
      -B /usr/share/X11/fonts:/usr/share/X11/fonts:ro \
	  $CONTAINER_IMAGE

