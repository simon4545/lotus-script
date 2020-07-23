#!/bin/sh
#SBATCH --job-name worker
#SBATCH --error=job-%j.err
#SBATCH --partition=amd
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64

module load singularity/3.5.3-thc

nohup singularity exec bin.sif lotus-seal-worker run --address 10.10.24.155:2333 >> worker.log 2>&1 &
wait
