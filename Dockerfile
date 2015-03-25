FROM ubuntu:14.04
MAINTAINER Erik Pearson <epearson@nmdp.org>

RUN groupadd -g 1043 nextflow \
  && useradd -m -u 1043 -g 1043 nextflow

RUN apt-get update -qy \
  && apt-get install -qy build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev openjdk-7-jre-headless \
  && curl -O https://repo1.maven.org/maven2/org/nmdp/ngs/ngs-tools/1.7/ngs-tools-1.7.deb \
  && dpkg --install ngs-tools-1.7.deb \
  && mkdir -p /mnt/common/nextflow \
  && chown nextflow.nextflow /mnt/common/nextflow \
  && su nextflow -c \
     'echo yes | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)" \
     && export PATH=/home/nextflow/.linuxbrew/bin:$PATH \
     && brew tap homebrew/science \
     && brew install ssake \
     && brew install samtools --without-curses \
     && brew install bwa' \
  && apt-get purge -qy build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev \
  && apt-get autoremove -qy \
  && apt-get autoclean -qy

USER nextflow

ENV PATH /home/nextflow/.linuxbrew/bin:$PATH

ENV NXF_HOME /mnt/common/nextflow/.nextflow
ENV NXF_WORK /mnt/common/nextflow

VOLUME /mnt/common/nextflow

WORKDIR /mnt/common/nextflow

CMD ["/bin/bash"]
