This script performs 
### Reference based mapping of fastq reads against a fasta reference, snp and indel calling and consensus calling.
It expects the reads and reference in a folder [project]_data

Before execution of the script it might be necessary to 

create a new virtual environment with [bioconda](http://bioconda.github.io/) from the package-list in this repository:

```bash
 conda create -y -n samtools=0.1.19 --file package-list.txt
```

Activate the virtual environment with (only once for each session)

```
 source activate samtools=0.1.19
```bash

And run the script with

```bash 
 ./reference_based_mapping.sh name_of_sample name_of_reference
```
Both names should by given without ending
