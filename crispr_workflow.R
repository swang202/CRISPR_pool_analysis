##QC fastq files
module load CBI
module load fastqc
fastqc Finkbeiner-SW-4039-01_S1_R1_001.fastq.gz
fastqc Finkbeiner-SW-4039-02_S2_R1_001.fastq.gz

##pull mageck docker:
  
singularity pull mageck_Feb2023.sif docker://davidliwei/mageck

##load singularity

scriptDir=/gladstone/bioinformatics/projects/GB-SW-1337_Shijie_crispr_2023/scripts
containerDir=/gladstone/bioinformatics/containers
dataDir=/gladstone/bioinformatics/projects/GB-SW-1337_Shijie_crispr_2023/data
export SINGULARITY_BINDPATH="$containerDir,$scriptDir,$dataDir"


singularity run $containerDir/mageck_Feb2023.sif


##prepare the library file
#If you are using one of the standard GeCKO libraries, you can just download the files from MAGeCK sourceforge. 
#For non-standard libraries, you need to prepare the library file

##run the MAGeCK count command
#Place two fastq files and one library file into the same directory, and under that directory, run MAGeCK on terminal:
cd /gladstone/bioinformatics/projects/GB-SW-1337_Shijie_crispr_2023/data/Alignment_2/20221205_115002/Fastq

#concatenate samples from 4 lanes
cat Finkbeiner-SW-4039-02_S2_L001_R1_001.fastq.gz Finkbeiner-SW-4039-02_S2_L002_R1_001.fastq.gz Finkbeiner-SW-4039-02_S2_L003_R1_001.fastq.gz Finkbeiner-SW-4039-02_S2_L004_R1_001.fastq.gz > Finkbeiner-SW-4039-02_S2_R1_001.fastq.gz
cat Finkbeiner-SW-4039-01_S1_L001_R1_001.fastq.gz Finkbeiner-SW-4039-01_S1_L002_R1_001.fastq.gz Finkbeiner-SW-4039-01_S1_L003_R1_001.fastq.gz Finkbeiner-SW-4039-01_S1_L004_R1_001.fastq.gz > Finkbeiner-SW-4039-01_S1_R1_001.fastq.gz

mageck count --pdf-report -l library.csv -n sw1337 --sample-label "Zach,Shijie" --fastq Finkbeiner-SW-4039-01_S1_R1_001.fastq.gz Finkbeiner-SW-4039-02_S2_R1_001.fastq.gz

##compare samples using MAGeCK test subcommand
mageck test -k sw1337.count.txt -t Zach -c Shijie -n sw1337
