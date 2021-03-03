FROM ubuntu:20.04

RUN apt-get update \
  && apt-get -y --no-install-recommends install \
    curl \
    python3 \
    python3-pip \
    samtools \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

RUN pip3 install numpy pysam

RUN mkdir -p /CAMPHOR/data
COPY ./ /CAMPHOR

WORKDIR /CAMPHOR

RUN curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/rmsk.txt.gz \
  | zcat | grep Simple_repeat | python3 /CAMPHOR/src/repeat/rmsk.py /dev/stdin > /CAMPHOR/data/rmsk.txt

RUN curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/simpleRepeat.txt.gz \
  | zcat | python3 /CAMPHOR/src/repeat/simpleRepeat.py /dev/stdin | sort -k1,1 -k2,2g > /CAMPHOR/data/simplerepeat.txt

RUN curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/genomicSuperDups.txt.gz \
  | zcat | python3 /CAMPHOR/src/repeat/seg_dup.py /dev/stdin | sort -k1,1 -k2,2g > /CAMPHOR/data/seg_dup.txt

RUN curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/chainSelf.txt.gz \
  | zcat | python3 /CAMPHOR/src/repeat/ucsc_selfchain.py /dev/stdin | sort -k1,1 -k2,2g > /CAMPHOR/data/seg_dup.txt

CMD sh CAMPHOR.sh ./example/NA18943.chr22.sort_by_name.test.bam ./example/NA18943.chr22.sort.test.bam ./example/NA18943.chr22.sort.test.fastq /out
