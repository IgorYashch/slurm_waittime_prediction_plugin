# Base image
FROM ubuntu:20.04

LABEL maintainer="Igor Yashchenko: yashch.igor@gmail.com"

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Create a new user "slurm"
RUN useradd -ms /bin/bash slurm

# Set password for the "slurm" user (you may want to change 'slurmPassword' with a password of your choice)
RUN echo 'slurm:slurm' | chpasswd

# Add "slurm" user to sudoers
RUN adduser slurm sudo

# Make sure we won't be asked for the "slurm" user password while using sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    apt-utils \
    dialog \
    munge \
    curl \
    wget \
    gcc \
    make \
    bzip2 \
    supervisor \
    python3-pip \
    python3-dev \
    python-is-python3 \
    build-essential \
    libncurses-dev \
    libssl-dev \
    libmysqlclient-dev \
    libssh2-1-dev \
    libjson-c-dev \
    libjemalloc-dev \
    git \
    autoconf \
    libtool \
    pkg-config \
    libglib2.0-dev \
    libgtk2.0-dev \
    gawk \
    binutils \
    libnuma-dev \
    libpam0g-dev \
    liblz4-dev \
    libcurl4-openssl-dev \
    libhdf5-dev \
    lua5.3 \
    man2html \
    check \
    libc-dev


# Set the workdir
WORKDIR /home/slurm

# Clone the Slurm Simulator repository
RUN git clone https://github.com/BSC-RM/slurm_simulator_tools.git

WORKDIR /home/slurm/slurm_simulator_tools

# Make the installation script executable
RUN chmod +x install_slurm_sim.sh

# Install slurm simulator and tools
RUN ./install_slurm_sim.sh

# Install python packages
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install jupyter jupyterlab mysqlclient numpy Flask pandas scikit-learn catboost torch


# USER slurm
# Здесь устанавливаются пакеты, необходимые для Анализа и удобной разработки
# Всё это можно закоментировать


# Install R packages
RUN apt-get update &&\
    apt-get install -y r-base r-cran-rcpp --fix-missing

WORKDIR /home/slurm
RUN git clone https://github.com/ubccr-slurm-simulator/slurm_sim_tools.git
# Install packages for working with R vizualization
# It is from another simualtor (https://github.com/ubccr-slurm-simulator/slurm_sim_tools) 
RUN Rscript /home/slurm/slurm_sim_tools/docker/slurm_sim/package_install.R
RUN rm -rf /home/slurm/slurm_sim_tools

RUN echo "N" | apt-get install -y sudo
# USER slurm

RUN Rscript -e 'install.packages(c("repr", "IRdisplay", "IRkernel"), type = "source", repos="https://cran.rstudio.com");'
RUN export PATH="$PATH:$HOME/.local/bin"
# RUN pip install 
RUN Rscript -e 'install.packages("jupyter-client", repos="https://cran.rstudio.com")'
RUN Rscript -e 'IRkernel::installspec(user=FALSE)'


# Установим библиотеку, чтобы запускать R в JУстановим JupyterLab и ядро для языка R
# Пример:
#       import rpy2
#       %load_ext rpy2.ipython
#       %%R s <- "Hello world"
RUN python3 -m pip install rpy2

USER slurm

