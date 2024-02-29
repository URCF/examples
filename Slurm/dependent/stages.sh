#!/bin/bash

# Launch first job
JOB=`sbatch stage_1.sh | egrep -o -e "\b[0-9]+$"`

# Launch a job that should run if the first is successful
sbatch --dependency=afterok:${JOB} stage_2.sh

# Launch a job that should run if the first job is unsuccessful
sbatch --dependency=afternotok:${JOB} stage_3.sh
