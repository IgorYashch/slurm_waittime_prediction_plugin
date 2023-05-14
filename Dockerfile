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
USER slurm

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


