# Docker File for Jupyterhub used by Dawn-team members(https://dawn-team.github.io)
# Will be invoked by dockerspawner
# Technical Requirement:
#     - [√] Nvidia Cards Support
#     - [√] Python3 Support
#     - [√] Notebook
#     - [√] Numpy
#     - [√] Tensorflow GPU Support
#     - [ ] Keras Support
#     - [ ] Octave
#     - [ ] Pytorch
#     - [?] Bash Shell Client
# 

FROM tensorflow/tensorflow:1.6.0-gpu-py3

MAINTAINER Arvin Si.Chuan "arvinsc@foxmail.com"

ENV REFRESHED_AT 2018-03-27-09:20:00 
ENV VERSION V1.0.0.alpha

# Step 1. Prepare demostic sources list.
COPY ["sources/sources.list","/etc/apt/sources.list"]

# Step 2. Update apt repositories.
RUN apt-get update -yqq

# Step 3. Install whole `apt` support.
RUN apt-get install -yqq \
    apt-utils 

# Step 4. Enimilate problems caused by dialog missing
RUN apt-get install -yqq \
    dialog 

# Step 5. Install system level packages.
RUN apt-get install -yqq \
    net-tools \
    git \
    openssh-server \
    python3 python3-pip \
    vim 
    
# Step 6. Install `python3-pip` and upgrade it to the latest
RUN pip3 install pqi
RUN pqi use tuna
RUN pip3 install --upgrade pip


# Step 7. Install application level packages from `python3-pip`
RUN pip3 install \
    babel \
    conda \
    faker \ 
    h5py \
    ipywidgets \
    jupyterhub jupyter_contrib_nbextensions \
    matplotlib music21 \
    numpy \
    pandas  pydub \
    sklearn scipy \
    virtualenv
    
# Waiting for basic tests till insall *** keras pytorch ***

# Step 8. Change default shell
# ln -sf /bin/bash /bin/sh
# ln -sf /bin/sh.distrib /bin/sh  
# ln -sf /usr/share/man/man1/sh.distrib.1.gz /usr/share/man/man1/sh.1.gz

# Step 9. Enable nbextension, choose `--system` due to the docker env.
RUN jupyter contrib nbextension install --system

# Step A. create a user, since we don't want to run as root
RUN useradd -m jovyan
ENV HOME=/home/jovyan
WORKDIR $HOME
USER jovyan

# Step B. Copy startup shell scripts.
COPY start-singleuser.sh /usr/local/bin/
COPY start.sh /usr/local/bin/

# Step C. Set entrypoint
ENTRYPOINT ["/bin/bash"]
CMD ["start-singleuser.sh"]


# Step D. Set labels
LABEL version="1.0.0.alpha" location="Shanghai, China." role="Team Computaion Platform."
