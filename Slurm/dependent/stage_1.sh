#!/bin/bash

#SBATCH -t 00:05:00
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --job-name=stage1

echo "Main job started at: " `date`
sleep 180
echo "Main job finished at: " `date`
