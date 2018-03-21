# Docker File for Jupyterhub used by Dawn-team members(https://dawn-team.github.io)
# Will be invoked by dockerspawner
# Technical Requirement:
#     - [?] Nvidia Cards Support
#     - [?] Python3 Support
#     - [?] Notebook
#     - [?] Numpy
#     - [ ] Tensorflow GPU Support
#     - [ ] Keras Support
#     - [ ] Octave
#     - [ ] Pytorch
# 

FROM nvidia/cuda:9.0-runtime

MAINTAINER Arvin Si.Chuan "arvinsc@foxmail.com"

ENV REFRESHED_AT 2018-03-21 

# Step #. Prepare demostic sources list.
COPY ["sources/sources.list","/etc/apt/sources.list"]

# Step 1. Update apt repositories.
RUN apt-get update -yqq

# Step 2. Install whole `apt` support.
RUN apt-get install -yqq \
    apt-utils 
 
# Step 3. Install system level packages.
RUN apt-get install -yqq \
    dialog \
    net-tools \
    git \
    openssh-server \
    python3 python3-pip \
    vim 
    
# Step 4. Install python3-pip and upgrade it to the latest
RUN pip3 install pqi
RUN pqi use tuna
RUN pip3 install --upgrade pip

# Step 5. Install application level packages from python3-pip
RUN pip3 install \
    babel \
    faker \ 
    h5py \
    matplotlib music21 \
    notebook numpy  \
    pandas  pydub \
    sklearn scipy 
    
# Waiting for basic tests till insall *** keras pytorch tensorflow-gpu ***



# Step 6. create a user, since we don't want to run as root
RUN useradd -m jovyan
ENV HOME=/home/jovyan
WORKDIR $HOME
USER jovyan

# TODO, debbuged to open
# Command to run when being started.
# CMD ["jupyterhub-singleuser"]

# Labels
LABEL version="1.0.0-SNAPSHOT" location="Shanghai, China." role="Team Computaion Platform."