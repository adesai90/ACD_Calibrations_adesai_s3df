#!/bin/bash

INPUT_VALUE=$1
INPUT_PATH=$2

ssh iana
cd $INPUT_PATH
source source_compiled_files.sh

# Verify environment was set
echo "After sourcing:"
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
echo "CONDA_DEFAULT_ENV: $CONDA_DEFAULT_ENV"
echo "PWD: $(pwd)"

# Now run the Python job
python $INPUT_PATH/releases/GR-20-09-10/calibGenACD/python/AcdWeeklyReport.py 'run' -w ${INPUT_VALUE} $INPUT_PATH/releases/GR-20-09-10/workdir/DIGI_260504.table $INPUT_PATH/releases/GR-20-09-10/workdir/RECON_260504.table
