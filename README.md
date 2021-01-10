# CAMPHOR
SV caller for long-reads

Overview
1. Extract reads suggesting SVs from a bam file
2. Indetify SV candidates supported by several support reads 
3. Filter SV candidates with repeat infmrmation and number of support reads

## Requirement
python3

perl

samtools (0.1.18 or higher)

## Input file
** Two bam files (bam sorted by read nume and bam sorted by genome coordinate)

** Fastq file of the sequence data

## Output file format
vcf file of SVs (SV.vcf)

## Usage
cd <path to CAMPHOR>
sh CAMPHOR.sh <bam(sorted by read name)> <bam(sorted by genome coordinate)> <fastq> <output>

## Example
git clone https://github.com/afujimoto/CAMPHOR.git
cd CAMPHOR
sh CAMPHOR.sh 例を書く

## Parameter setting in configuration file
We consider the parameter set in the provided configuration apprppreate for 20x coverage WGS data.
If you would like to use different parameters, please make changes in the parm.config file.
In the current file, minimum vadinat alele frequency (MIN_VAF), minimu number of reads (MIN_READ_NUMBER) and minimum indel length (MIN_INDEL_LENGTH) are set ot 0.15, 2 and 100.
For greater depth of coverage data, larger MIN_READ_NUMBER sould be apprppreate. 
We developed this method with nanopore sequence data basecalled by albacore (total error rate =~ 15%), and set minimum indel length to 100bp to remove false potitives. But newer basecaller increases the accuracy and minimum indel length can be set to 50bp or smaller.

## Repeat filtering
If repeat infmarmaiton files are privided, our method filter SV candisates with following repeat infromation (Repeat masker, Tandm repeat finder, Segmental duplication, Self-chain).
This filter can increase specitficity.

## Preformance
Performance of this tool is provided in Fujimoto et al. (in rivision).

## Licence
GPL

## Contact

Akihiro Fujimoto - afujimoto@m.u-tokyo.ac.jp

http://www.humgenet.m.u-tokyo.ac.jp/index.en.html
