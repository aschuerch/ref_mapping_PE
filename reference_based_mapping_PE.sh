#/bin/bash

set -e # uncomment for debugging
#set -x # uncomment for debugging


if [ $# -eq 0 ]; then
    echo "
# Anita Schurch May 2017
# This small script performs reference based mapping, snp and indel calling and consensus calling.
# The samples should be located in [project_data]/folderX/name_of_sample.R1.fastq and project_data/folderX/name_of_sample.R2.fastq
# The reference should be located in [project_data]/reference.fas
# If might be necessary to create a new virtual environment with bioconda:

 conda create -y -n samtools=0.1.19 --file package-list.txt

# Activate the virtual environment with (only once for each session)

 source activate samtools=0.1.19

# And run the script with

 ./reference_based_mapping.sh name_of_sample name_of_reference

# Both names should by given without ending
"
    exit
fi


datapath=$(pwd)

# inputfiles
#R1=($datapath/*data/*/"$1"*_R1*)
R1_gz=$(find "$datapath" -name "$1"*R1*.fastq.gz)
#R2=($datapath/*data//"$1"*_R2*.f*)
R2_gz=$(find "$datapath" -name "$1"*R2*.fastq.gz)
#ref=($datapath/*data/"$2".f*)
ref=$(find "$datapath" -name "$2".fas -or -name "$2".fna)

R1="$datapath"/"$1"_R1.fastq
R2="$datapath"/"$1"_R2.fastq

zcat $R1_gz >  "$datapath"/"$1"_R1_untrimmed.fastq
zcat $R2_gz >  "$datapath"/"$1"_R2_untrimmed.fastq

echo 'Quality control and trimming'
seqtk trimfq  "$datapath"/"$1"_R1_untrimmed.fastq >  "$R1"
seqtk trimfq  "$datapath"/"$1"_R2_untrimmed.fastq >  "$R2"


##Check for *fastqs
for i in "$R1" "$R2" "$ref"
 do
  if [[ -s "$i" ]]; then
   echo 'Found file for' "$i"
  else
   echo 'Sequence file '"$i" 'is missing'
   exit 0
  fi
 done


# The files below will be produced during analysis
output=$(find "$datapath" -type d -name '*output')
echo $output
if [[ ! -d "$output" ]];then
   output="$datapath"/output
   mkdir -p "$output"
fi
echo 'Output will be written to ' "$output"
index=${ref%.*}
sam=("$output"/"$1"_"$2"_aln.sam)
bam=("$output"/"$1"_"$2"_aln.bam)
cns=("$output"/"$1"_"$2"_cns.fq)
cnsfas=("$output"/"$1"_"$2"_cns.fas)
finalfas=("$output"/"$1"_"$2".consensus.fas)
vcfsnp=("$output"/"$1"_"$2".snp.vcf)
vcfindel=("$output"/"$1"_"$2".indel.vcf)


echo 'Mapping'
bowtie2-build -f "$ref" "$index"
bowtie2 --local --very-sensitive-local -x "$index" -1 "$R1"  -2 "$R2" -S "$sam"

samtools view -bT "$ref" "$sam" > "$bam"
samtools sort "$bam" "$bam".sorted
samtools index "$bam".sorted.bam

echo 'SNP'
samtools mpileup -d 1000 -f "$ref" "$bam".sorted.bam |varscan mpileup2snp --output-vcf --min-var-freq 0.001 > "$vcfsnp"
echo 'INDEL'
samtools mpileup -d 1000 -L 1000 -f "$ref" "$bam".sorted.bam |varscan mpileup2indel --min-var-freq 0.001 --output-vcf > "$vcfindel"


echo 'Consensus creation'
samtools mpileup -uf "$ref" "$bam".sorted.bam | bcftools view -cg - | vcfutils.pl vcf2fq > "$cns"
seqtk seq -A  "$cns" > "$finalfas"

rm "$cns"
rm "$cnsfas"
rm "$sam"
rm "$bam"

rm "$datapath"/"$1"_R1_untrimmed.fastq
rm "$datapath"/"$1"_R2_untrimmed.fastq

rm $R1
rm $R2


