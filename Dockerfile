FROM debian:testing
LABEL maintainer Diego Diez <diego10ruiz@gmail.com>

ENV VERSION=v2.3.1

RUN apt-get update -y && \
    apt-get install -y \
      build-essential \
      git \
      libtbb-dev \
      libreadline6-dev \
      zlib1g-dev \
      libtinfo-dev \
      && \

    # checkout github project and tag.
    cd /tmp && \
    git clone https://github.com/BenLangmead/bowtie2.git && \
    cd bowtie2 && \
    git checkout $VERSION && \

    # make /opt install directory.
    #sed -e "s/prefix = \/usr\/local/prefix = \/opt/" Makefile > Makefile.new && \
    #mv Makefile.new Makefile && \

    # build and install.
    EXTRA_FLAGS="-std=gnu++98" NO_TBB=0 make && \
    make prefix=/opt install && \

    # clean up.
    rm -rf /tmp/bowtie2 && \
    apt-get clean -y && \
    apt-get purge -y \
      build-essential \
      git \
      && \
    apt-get autoremove -y

ENV PATH /opt/bin:$PATH

# User.
RUN useradd -ms /bin/bash biodev
RUN echo 'biodev:biodev' | chpasswd
USER biodev
WORKDIR /home/biodev
