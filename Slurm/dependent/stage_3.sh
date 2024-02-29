#!/bin/bash

#SBATCH -t 00:05:00
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --job-name=stage3

echo "Dependent job ran at: " `date` "after failure"
