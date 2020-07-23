#!/bin/sh
#SBATCH --job-name host
#SBATCH --error=job-%j.err
#SBATCH --partition=amd
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64

module load singularity/3.5.3-thc

nohup singularity exec bin.sif lotus daemon >> daemon.log 2>&1 &
sleep 30s
nohup singularity exec bin.sif lotus-storage-miner run >> miner.log 2>&1 &
wait
