# Purpose

This script performs 
-  *Reference based mapping of paired-end fastq reads against a fasta reference*
-  *SNP and indel calling*
-  *Consensus calling*


It expects the reads and reference in a folder [project]_data

# Dependencies

- [Bioconda](http://www.bioconda.github.io)

Further dependencies are described in package-list.txt. A virtual environment can be created with

```bash
conda create -y -n samtools=0.1.19 --file package-list.txt
```

Activate the virtual environment with (only once for each session)

```bash
source activate samtools=0.1.19
```
# Execution

Change the permission of the script
```bash
chmod 755 reference_based_mapping_PE.sh
```

The folder /test_data/ contains test files. The test can be run with

```bash
./reference_based_mapping_PE.sh Test TestRef
```

For your own samples, create a folder [project]_data and store your samples and reference there.

Run the script with

```bash 
./reference_based_mapping_PE.sh name_of_sample name_of_reference
```

Both names should by given *without* ending(.fastq,.fna or .fas)

# Remarks
- Adjust the parameters of every tool to your need in the bash script
- The script does not include quality control or quality trimming
- You can filter the resulting vcf files if necessary, for example with varscan.
```bash
varscan filter -h
```
will give you a number of options
