# Docker File for Jupyterhub used by Dawn-team members(https://dawn-team.github.io)
# Will be invoked by dockerspawner
# Technical Requirement:
#     - PaaS
#     - Nvidia Cards Support
#     - Python3 Support
#     - Numpy
#     - Tensorflow Support
#     - Keras Support
#     - Octave
#     - Pytorch
# 

FROM nvidia/cuda:9.0-runtime

MAINTAINER Arvin Si.Chuan "arvinsc@foxmail.com"

ENV REFRESHED_AT 2018-03-20 

# Step 1. Install system level packages
RUN apt-get update -yqq
RUN apt-get upgrade -yqq
RUN apt-get install -yqq \
    git \
    nodejs-legacy npm \ 
    python3 python3-pip 

# Step 2. Install application level packages from python3-pip
RUN pip3 install \
    babel \
    dqpm \
    faker \ 
    h5py \
    matplotlib music21 \
    notebook numpy  \
    pandas  pydub \
    sklearn scipy 
    
# Waiting for basic tests till insall *** keras pytorch tensorflow-gpu ***



# Step 3. create a user, since we don't want to run as root
RUN useradd -m jovyan
ENV HOME=/home/jovyan
WORKDIR $HOME
USER jovyan

# Command to run when being started.
CMD ["jupyterhub-singleuser"]

# Labels
LABEL version="1.0.0-alpha" location="Shanghai, China." role="Team Computaion Platform."