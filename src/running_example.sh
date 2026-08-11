#!/bin/bash

# Directory with input files: tar file with fasta files and a one with OPG genes.
PATH_TO_DATA=$1

# Path where to store results of makeblastdb and blastn search
PATH_TO_RESULTS=$2

# Control if parameters are provided
if [ -z "$PATH_TO_DATA" ] || [ -z "$PATH_TO_RESULTS" ]; then
    echo "Usage: $0 <path_to_data> <path_to_results>"
    exit 1
fi

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
mkdir -p $PATH_TO_RESULTS/OPG_blast_db

# Create results for blastn search
mkdir -p $PATH_TO_RESULTS/blast_results

# Create BLAST database from the OPG_genes.fasta file
makeblastdb -in $PATH_TO_DATA/OPG_genes.fasta -dbtype nucl -out $PATH_TO_RESULTS/OPG_blast_db/OPG_genes_db 

# untar the fasta files to be searched against the OPG genes database
tar -xzf $PATH_TO_DATA/fasta_files.tar.gz -C $PATH_TO_DATA

echo "Running BLAST search for each fasta file against the OPG genes database..."
num_files=$(ls -1 $PATH_TO_DATA/fasta_files/*.fasta | wc -l)
echo "Number of fasta files to be processed: $num_files"

for fasta_file in $PATH_TO_DATA/fasta_files/*.fasta; do
    # Get the base name of the fasta file (without path and extension)
    base_name=$(basename "$fasta_file" .fasta)

    # Run BLAST search against the OPG genes database
    blastn -query "$fasta_file" -db $PATH_TO_RESULTS/OPG_blast_db/OPG_genes_db \
                                -out $PATH_TO_RESULTS/blast_results/"$base_name"_blast_results.txt \
                                -evalue 1e-5 -num_threads 4 -max_target_seqs 5 \
                                -outfmt 6

done
echo "BLAST search completed. Results are stored in $PATH_TO_RESULTS/blast_results/"
# After processing, detele the untarred fasta files to save space
rm -rf $PATH_TO_DATA/fasta_files

