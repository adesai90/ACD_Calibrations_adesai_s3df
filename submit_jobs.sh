#!/bin/bash                                                                                                                                                                            

INPUT_VALUE=${1}
INPUT_PATH=${2} #Keep input path same as base directory.                                                                                                                               

# Create jobs directory if it doesn't exist                                                                                                                                            
if [ ! -d "$INPUT_PATH/releases/GR-20-09-10/workdir/submitted_jobs" ]; then
    echo "Creating jobs directory at $INPUT_PATH/releases/GR-20-09-10/workdir/submitted_jobs"
    mkdir -p "$INPUT_PATH/releases/GR-20-09-10/workdir/submitted_jobs"
fi
if [ ! -d "$INPUT_PATH/releases/GR-20-09-10/workdir/submitted_jobs/week_${INPUT_VALUE}" ]; then
    echo "Creating jobs directory at $INPUT_PATH/releases/GR-20-09-10/workdir/submitted_jobs/week_${INPUT_VALUE}"
    mkdir -p "$INPUT_PATH/releases/GR-20-09-10/workdir/submitted_jobs/week_${INPUT_VALUE}"
fi

sbatch \
    --account=fermi \
    --time 10:00:00 \
    --partition milano \
    --nodes 1 \
    --cpus-per-task 2 \
    --requeue \
    --job-name acd_calibrations_week_${INPUT_VALUE} \
    --output $INPUT_PATH/releases/GR-20-09-10/workdir/submitted_jobs/week_${INPUT_VALUE}/acd_calibrations_week_${INPUT_VALUE}.out \
    --wrap="bash $INPUT_PATH/run_job_wrapper.sh ${INPUT_VALUE} ${INPUT_PATH}"
    