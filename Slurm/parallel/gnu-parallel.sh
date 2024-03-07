#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:08:00

module load parallel/20240222

# Parallel should launch one instance of srun per SLURM task
MY_PARALLEL_OPTS="-N 1 -j $SLURM_NTASKS"

# Use parallel to launch srun with these options
parallel $MY_PARALLEL_OPTS "sleep 30; cat {}" ::: `ls -1 data/input.{?,??}`
