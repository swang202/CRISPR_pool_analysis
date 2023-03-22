#!/bin/bash
#$ -cwd    ## use current working directory
#$ -pe smp 1
#$ -l mem_free=2G
#$ -l scratch=10G
#$ -l h_rt=10:00:00
#$ -N crispr

cd /gladstone/bioinformatics/projects/GB-SW-1337_Shijie_crispr_2023/data/Alignment_2/20221205_115002/Fastq

#concatenate samples from 4 lanes
cat Finkbeiner-SW-4039-02_S2_L001_R1_001.fastq.gz Finkbeiner-SW-4039-02_S2_L002_R1_001.fastq.gz Finkbeiner-SW-4039-02_S2_L003_R1_001.fastq.gz Finkbeiner-SW-4039-02_S2_L004_R1_001.fastq.gz > Finkbeiner-SW-4039-02_S2_R1_001.fastq.gz
cat Finkbeiner-SW-4039-01_S1_L001_R1_001.fastq.gz Finkbeiner-SW-4039-01_S1_L002_R1_001.fastq.gz Finkbeiner-SW-4039-01_S1_L003_R1_001.fastq.gz Finkbeiner-SW-4039-01_S1_L004_R1_001.fastq.gz > Finkbeiner-SW-4039-01_S1_R1_001.fastq.gz

##QC fastq files
#load wynton modules
module load CBI
module load fastqc
#run fastqc
fastqc Finkbeiner-SW-4039-01_S1_R1_001.fastq.gz
fastqc Finkbeiner-SW-4039-02_S2_R1_001.fastq.gz

##load singularity

scriptDir=/gladstone/bioinformatics/projects/GB-SW-1337_Shijie_crispr_2023/scripts
containerDir=/gladstone/bioinformatics/containers
dataDir=/gladstone/bioinformatics/projects/GB-SW-1337_Shijie_crispr_2023/data/Alignment_2/20221205_115002/Fastq
export SINGULARITY_BINDPATH="$containerDir,$scriptDir,$dataDir"


singularity exec $containerDir/mageck_Feb2023.sif mageck count --pdf-report -l library.csv -n sw1337 --sample-label "Zach,Shijie" --fastq Finkbeiner-SW-4039-01_S1_R1_001.fastq.gz Finkbeiner-SW-4039-02_S2_R1_001.fastq.gz
