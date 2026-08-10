#!/bin/bash

# Directory with input files: tar file with fasta files and a one with OPG genes.
PATH_TO_DATA=$1

# Path where to store results of makeblastdb and blastn search
PATH_TO_RESULTS=$2



# Check blast_env conda environment exists, if not run install_blast_conda.sh to install BLAST+ in a conda environment
if ! conda info --envs | grep -q "blast_env"; then
    echo "The conda environment 'blast_env' does not exist."
    echo "Please run install_blast_conda.sh to install BLAST+ in a conda environment."
    exit 1
fi

# Activate the conda environment to use BLAST+
eval "$(conda shell.bash hook)"
conda activate blast_env

# Create dir for blast dbs
mkdir -p $PATH_TO_RESULTS/blast_dbs

# Create results for blastn search
mkdir -p $PATH_TO_RESULTS/blast_results


