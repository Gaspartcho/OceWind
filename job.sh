#!/bin/bash

#SBATCH -J TestOceananigansCPU

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --account=meom

#SBATCH --mem=100000

#SBATCH --time=20:00:00
#SBATCH --output results/logs/OceWind.%j.output
#SBATCH --error  results/logs/OceWind.%j.error


julia --project=. src/OceWind.jl
