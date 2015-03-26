FROM ubuntu:14.04
MAINTAINER Erik Pearson <epearson@nmdp.org>

RUN groupadd -g 1043 nextflow \
  && useradd -m -u 1043 -g 1043 nextflow

# ssake 3.8.2 (3d01134002ed4127c4730053524c7f983ef836bd)
# bwa 0.7.12 (3d01134002ed4127c4730053524c7f983ef836bd)
# samtools 1.2 (3d01134002ed4127c4730053524c7f983ef836bd)

RUN apt-get update -qy \
  && apt-get install -qy build-essential curl git m4 ruby texinfo libbz2-dev \
                         libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev \
                         openjdk-7-jre-headless \
  && curl -O https://repo1.maven.org/maven2/org/nmdp/ngs/ngs-tools/1.7/ngs-tools-1.7.deb \
  && dpkg --install ngs-tools-1.7.deb \
  && rm -rf /ngs-tools-1.7.deb \
  && mkdir -p /mnt/common/nextflow \
  && chown nextflow.nextflow /mnt/common/nextflow \
  && su nextflow -c \
     'echo yes | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)" \
     && export PATH=/home/nextflow/.linuxbrew/bin:$PATH \
     && brew tap homebrew/science \
     && cd /home/nextflow/.linuxbrew/Library/Taps/homebrew/homebrew-science \
     && git checkout 3d01134002ed4127c4730053524c7f983ef836bd ssake.rb \
     && brew install ssake \
     && git checkout 01c92150fddd0452351429164f6b34fef8886aec samtools.rb \
     && brew install samtools --without-curses \
     && git checkout 09578cf6ce07c9619320debaa45b7a541c51d625 bwa.rb \
     && brew install bwa \
     && cd /home/nextflow/.linuxbrew \
     && rm -rf .git Library' \
  && apt-get purge -qy build-essential curl git m4 ruby texinfo libbz2-dev \
                       libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev \
  && apt-get autoremove -qy \
  && apt-get autoclean -qy

USER nextflow

ENV PATH /home/nextflow/.linuxbrew/bin:$PATH

ENV NXF_HOME /mnt/common/nextflow/.nextflow
ENV NXF_WORK /mnt/common/nextflow

VOLUME /mnt/common/nextflow

WORKDIR /mnt/common/nextflow

CMD ["/bin/bash"]
