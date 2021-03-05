# CAMPHOR

SV caller for long-reads

Overview
1. Extract reads suggesting SVs from a bam file
2. Identify SV candidates
3. Filter SV candidates with repeat information and number of support reads

## Requirement

* python3
* pysam module of python
* numpy
* perl
* samtools (0.1.18 or higher)

## Input file

* Two bam files (one bam sorted by read name and another sorted by genome coordinates)
* Index file (.bai) for bam file sorted by genome coordinate
* Fastq file of the sequence data

If samtools is not installed in the environment, the path to the execution file of samtools can be specified within the config file (pram.config).

## Output file format
vcf file of SVs (SV.vcf)

## Usage

```shell
$ git clone https://github.com/afujimoto/CAMPHOR
$ cd CAMPHOR/CAMPHOR
$ sh CAMPHOR.sh <bam(sorted by read name)> <bam(sorted by genome coordinate)> <fastq> <output>
```

## Example

```shell
$ git clone https://github.com/afujimoto/CAMPHOR
$ cd CAMPHOR/CAMPHOR
$ sh CAMPHOR.sh ./example/NA18943.chr22.sort_by_name.test.bam ./example/NA18943.chr22.sort.test.bam ./example/NA18943.chr22.sort.test.fastq test
```
## Installation and usage via Docker

Install Docker in yor computer, and run the below commands to install and run test.

```shell
$ git clone https://github.com/afujimoto/CAMPHOR
$ cd CAMPHOR/CAMPHOR
$ docker build -t camphor .
$ docker run --rm -it -v $PWD:/out camphor
```

If you want to run for your own data, please run the below commands.

```shell
$ git clone https://github.com/afujimoto/CAMPHOR
$ cd CAMPHOR/CAMPHOR
$ docker build -t camphor .
$ docker run --rm -it -v <path to output directory>:/out -v <path to input directory>:/input camphor sh CAMPHOR.sh /input/NA18943.chr22.sort_by_name.test.bam /input/NA18943.chr22.sort.test.bam /input/NA18943.chr22.sort.test.fastq /out/
```

## Parameter setting in configuration file

We consider the parameter set in the provided configuration appropriate for 20x coverage WGS data.
If you would like to use different parameters, please make changes in the parm.config file.
In the current file, minimum variant allele frequency (MIN_VAF), minimum number of reads (MIN_READ_NUMBER) and minimum indel length (MIN_INDEL_LENGTH) (bp) are set to 0.15, 2 and 100, respectively.
For greater depth of coverage, larger minimum number of reads should be appropriate.

We developed this method with nanopore sequence data base-called by albacore (total error rate =~ 15%), and set the minimum indel length to 100bp to remove false positives. However, newer basecallers have increased accuracy, and smaller minimum indel length (50bp or smaller) as well as lower minimum variant allele frequency (0.1 or lower) can be used.

## Repeat filtering

If repeat information files are provided, our method filters SV candidates with the provided repeat information (Repeat masker, Tandem repeat finder, Segmental duplication, Self-chain). The filtering can increase the specificity.
Please prepare annotation files with the following procedures.

### Repeat masker

Download rmsk.txt from http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/

```shell
$ grep Simple_repeat <path to rmsk.txt>|python .src/repeat/rmsk.py /dev/stdin > ./data/rmsk.txt
```

### Tandem repeat

Download simpleRepeat.txt from http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/　　

```shell
$ python ./src/repeat/simpleRepeat.py <path to simpleRepeat.txt>|sort -k1,1 -k2,2g > ./data/simplerepeat.txt
```

### Segmental duplication

Download genomicSuperDups.txt from http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/　　

```shell
$ python ./src/repeat/seg_dup.py <path to genomicSuperDups.txt>|sort -k1,1 -k2,2g > ./data/seg_dup.txt
```

### Self-chain

Download chainSelf.txt file from http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/

```shell
$ python .src/repeat/ucsc_selfchain.py <path to chainSelf.txt> | sort -k1,1 -k2,2g > ./data/chainSelf.txt
```

Automatic obtaining the annotation data used from UCSC
Download and format change for repeat information can be performed with the commands below.

```shell
$ cd CAMPHOR/CAMPHOR
$ mkdir ./data/
$ curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/rmsk.txt.gz | zcat | grep Simple_repeat | python3 ./src/repeat/rmsk.py /dev/stdin > ./data/rmsk.txt
$ curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/simpleRepeat.txt.gz | zcat | python3 ./src/repeat/simpleRepeat.py /dev/stdin | sort -k1,1 -k2,2g > ./data/simplerepeat.txt
$ curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/genomicSuperDups.txt.gz | zcat | python3 ./src/repeat/seg_dup.py /dev/stdin | sort -k1,1 -k2,2g > ./data/seg_dup.txt
$ curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/chainSelf.txt.gz | zcat | python3 ./src/repeat/ucsc_selfchain.py /dev/stdin | sort -k1,1 -k2,2g > ./data/chainSelf.txt
```   
   
## Performance

Performance of this tool is provided in Fujimoto et al. (in revision).

## Licence

GPLv3

## Contact

Akihiro Fujimoto - afujimoto@m.u-tokyo.ac.jp

http://www.humgenet.m.u-tokyo.ac.jp/index.en.html
