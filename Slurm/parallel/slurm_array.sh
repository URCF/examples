#!/bin/bash

#SBATCH --job-name=array
#SBATCH --array=1-20
#SBATCH --time=00:05:00
#SBATCH --account=urcfprj
#SBATCH --partition=def-sm
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --output=log/array_%A-%a.out

random_num=$((1 + RANDOM % 100))
srun bash -c "sleep 20; echo ${random_num} > data/input.${SLURM_ARRAY_TASK_ID}"
