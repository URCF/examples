#!/bin/bash

#SBATCH --job-name=array
#SBATCH --array=1-20
#SBATCH --time=00:05:00
#SBATCH --account=urcfprj
#SBATCH --partition=def-sm
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --output=log/array_%A-%a.out

input_num=$(cat data/input.${SLURM_ARRAY_TASK_ID})

srun bash -c "sleep 20; echo ${input_num} > data/input.${SLURM_ARRAY_JOB_ID}.${SLURM_ARRAY_TASK_ID}"
