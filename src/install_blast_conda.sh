#"#/bin/bash"


# Install BLAST+ using conda 
if ! command -v conda &> /dev/null
then
    echo "conda could not be found. Please install conda first."
    exit 1
fi

# Control the conda environment to avoid conflicts with other packages
if conda info --envs | grep -q "blast_env"; then
    echo "The conda environment 'blast_env' already exists."
    echo "Use next command to remove it"
    echo "conda env remove -n blast_env"
    exit 1
fi

# Create a new conda environment for BLAST+, and isntall BLAST+ in it
conda create -n blast_env -c bioconda blast -y

# Check in environment was created successfully
if [ $? -ne 0 ]; then
    echo "Failed to create conda environment 'blast_env'."
    exit 1
fi

# Activate the environment to use BLAST+
eval "$(conda shell.bash hook)"
conda activate blast_env

# Print the BLAST+ version to verify installation
echo "BLAST+ installation completed. The installed version is:"
blastn -version