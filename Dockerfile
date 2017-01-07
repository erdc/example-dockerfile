FROM andrewosh/binder-base

MAINTAINER Andrew Osheroff <andrewosh@gmail.com>

USER root

# Add Julia dependencies
RUN apt-get update
RUN apt-get install -y julia libnettle4 && apt-get clean

RUN REPO=http://cdn-fastly.deb.debian.org \
    && echo "deb $REPO/debian jessie main\ndeb $REPO/debian-security jessie/updates main" > /etc/apt/sources.list \
    && apt-get update && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends --fix-missing \
    git \
    vim \
    jed \
    emacs \
    wget \
    build-essential \
    python-dev \
    ca-certificates \
    bzip2 \
    unzip \
    libsm6 \
    pandoc \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    sudo \
    locales \
    libxrender1 \
    libav-tools \
    libmpich2-dev \
    liblapack-dev \
    freeglut3 \
    freeglut3-dev \
    libglew1.5 \
    libglew1.5-dev \
    libglu1-mesa \
    libglu1-mesa-dev \
    libgl1-mesa-glx \
    libgl1-mesa-dev \
    curl \
    libjpeg-dev \
    m4 \
    libssl-dev \
    ssh \
    mpich2 \
    python3 \
    python3-pip \
    python3-doc \
    python3-tk \
    python3-venv \
    python3-genshi \
    python3-lxml \
    python3-openssl \
    python3-pyasn1 \
    python3.4-venv \
    python3.4-doc \
    binfmt-support \
    python3-dev \
    python3-wheel \
    libffi-dev \
    python-lzma \
    python-pip \
    cmake \
    gfortran \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV NB_USER main
RUN mkdir /home/$NB_USER/.jupyter && \
    mkdir /home/$NB_USER/.hashdist && \
    echo "cacert=/etc/ssl/certs/ca-certificates.crt" > /home/$NB_USER/.curlrc

ADD https://dl.dropboxusercontent.com/u/26353144/hashdist_config_jovyan.yaml /home/$NB_USER/.hashdist/config.yaml

RUN chown -R $NB_USER:users /home/$NB_USER

USER main

RUN cat /home/$NB_USER/.hashdist/config.yaml && \
    git clone https://github.com/erdc-cm/proteus && \
    cd proteus && \
    make hashdist stack stack/default.yaml && \
    cd stack && \
    PATH=/usr/bin:$PATH ../hashdist/bin/hit build default.yaml -v

ENV CC mpicc
ENV CXX mpicxx
ENV F77 mpif77
ENV F90 mpif90

RUN cd proteus && PATH=/usr/bin:$PATH which python && PATH=/usr/bin:$PATH make develop

USER root

RUN /home/$NB_USER/proteus/linux2/bin/jupyter kernelspec install-self  && jupyter kernelspec list 

USER main