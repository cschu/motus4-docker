FROM condaforge/miniforge3:24.7.1-0

LABEL maintainer="cschu1981@gmail.com"
LABEL version="4.1"
LABEL description="This is a Docker Image for motus4.1"


ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt upgrade -y

RUN apt install -y wget python3-pip git bwa samtools
RUN apt clean

RUN mkdir -p /opt/software/ && cd /opt/software/ && \
    git clone https://github.com/motu-tool/mOTUs.git motus && \
    cd motus && \
    git checkout mOTUs4.1 && \
    # pip install pysam biopython && \
    sed -i 's/^\(DEFAULT_MOTUS_MGDB_PARENT_LOCATION\) = \(.\+\)/\1 = pathlib.Path(os.environ.get("MOTUS_DB", str(\2)))/' motus/mutils.py && \
    sed -i '1i import os' motus/mutils.py && \
    # sed -i '359 s:r\[0\]:r[0].replace("/1",""):; 360 s:r\[0\]:r[0].replace("/2",""):' motus/mentities.py && \
    pip install .
    # ln -s motus.py motus/motus

ENV PATH=/opt/software/motus/motus:$PATH

# RUN mkdir -p /opt/software/ && cd /opt/software/ && \
#    wget https://sunagawalab.ethz.ch/share/MOTUS/motus-tool/v4.0.0a/mOTUsv4.0.0a.tar.gz && \
#    tar xvf mOTUsv4.0.0a.tar.gz && \
#    pip install pysam biopython && \
#    sed -i 's/^\(DEFAULT_MOTUS_MGDB_LOCATION\) = \(.\+\)/\1 = pathlib.Path(os.environ.get("MOTUS_DB", str(\2)))/' motus-tool/motus.py && \
#    sed -i '2303i\    print(f"{DEFAULT_MOTUS_MGDB_LOCATION=}")' motus-tool/motus.py && \
#    sed -i '702 s:r\[0\]:r[0].replace("/1",""):; 703 s:r\[0\]:r[0].replace("/2",""):' motus-tool/motus.py && \
#    ln -s motus.py motus-tool/motus

# ENV PATH=/opt/software/motus-tool:$PATH

