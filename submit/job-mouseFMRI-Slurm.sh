#!/bin/sh

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=schwab@upd.unibe.ch
#SBATCH --time=1:00:00
#SBATCH --job-name=DGM-mouseFMRI
#SBATCH --mem-per-cpu=512M
#SBATCH --output=log/slurm/slurm-%j.out
#SBATCH --error=log/slurm/slurm-%j.out
#SBATCH --array=1-612

# submit is a symlink
srun DGM-mouseFMRI/submit/DGM-mouseFMRI-Slurm.R
