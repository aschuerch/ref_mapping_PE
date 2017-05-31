# This small script performs reference based mapping, snp and indel calling and consensus calling.
# t, define the folder where the input files are located. Set up the folder structure like this
# project_data/
# project_src/
# project_env/
# The script expects the reads and reference in [project]_data
# Before execution of the script it might be necessary to 
# create a new virtual environment with bioconda:

 conda create -y -n samtools=0.1.19 --file package-list.txt

# Activate the virtual environment with (only once for each session)

 source activate samtools=0.1.19

# And run the script with

 ./reference_based_mapping.sh name_of_sample name_of_reference

# Both names should by given without ending
# Anita Schurch May 2017
