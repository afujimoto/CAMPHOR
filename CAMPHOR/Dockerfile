FROM ubuntu:20.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
  && apt-get -y --no-install-recommends install \
    curl \
    python3 \
    python3-pip \
    samtools \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

RUN pip3 install numpy pysam

RUN curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/rmsk.txt.gz | zcat | grep Simple_repeat | gzip -c > /rmsk.txt.gz
RUN curl -LO http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/simpleRepeat.txt.gz
RUN curl -LO http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/genomicSuperDups.txt.gz
RUN curl -LO http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/chainSelf.txt.gz

RUN mkdir -p /CAMPHOR/data
COPY ./ /CAMPHOR

WORKDIR /CAMPHOR

RUN zcat /rmsk.txt.gz | python3 /CAMPHOR/src/repeat/rmsk.py /dev/stdin > /CAMPHOR/data/rmsk.txt
RUN zcat /simpleRepeat.txt.gz | python3 /CAMPHOR/src/repeat/simpleRepeat.py /dev/stdin | sort -k1,1 -k2,2g > /CAMPHOR/data/simplerepeat.txt
RUN zcat /genomicSuperDups.txt.gz | python3 /CAMPHOR/src/repeat/seg_dup.py /dev/stdin | sort -k1,1 -k2,2g > /CAMPHOR/data/seg_dup.txt
RUN zcat /chainSelf.txt.gz | python3 /CAMPHOR/src/repeat/ucsc_selfchain.py /dev/stdin | sort -k1,1 -k2,2g > /CAMPHOR/data/chainSelf.txt

CMD sh CAMPHOR.sh ./example/NA18943.chr22.sort_by_name.test.bam ./example/NA18943.chr22.sort.test.bam ./example/NA18943.chr22.sort.test.fastq /out
