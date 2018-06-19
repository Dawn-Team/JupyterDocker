# Docker File for Jupyterhub used by Dawn-team members(https://dawn-team.github.io)
# Will be invoked by dockerspawner
# Technical Requirement:
#     - [√] Nvidia Cards Support
#     - [√] Python3 Support
#     - [√] Notebook
#     - [√] Numpy
#     - [√] Tensorflow GPU Support
#     - [√] Keras Support
#     - [√] Octave
#     - [√] Pytorch
#     - [√] Bash Shell Client
# 

FROM tensorflow/tensorflow:latest-gpu-py3

MAINTAINER Arvin Si.Chuan "arvinsc@foxmail.com"

# Version Tag
# Env INFO
ENV REFRESHED_AT 2018-06-15_15:20:00 
ENV VERSION V1.1.2
ENV SHELL bash



# Step 1. Prepare demostic sources list.
COPY ["sources/sources.list","/etc/apt/"]
# move cuda list to bak see later to restore
RUN \
    rm /etc/apt/sources.list.d/* && \
    apt-get update && \
    apt-get install apt-transport-https
COPY ["sources/sources.list.d/*","/etc/apt/sources.list.d/"]
RUN \
   apt-get clean && \
   rm -rf /etc/lib/apt/lists/* &&\
   rm \
       /etc/apt/sources.list.d/cuda-checkpoint.list \
       /etc/apt/sources.list.d/nvidia-ml-checkpoint.list



# Step 2. Update apt repositories.
# Step 3. Install whole `apt` support.
# Step 4. Enimilate problems caused by dialog missing
# Step 5. Install system level packages.
# Step 6. Clean Installation
RUN \
    DEBIAN_FRONTEND=noninteractive curl -sL https://deb.nodesource.com/setup_8.x | bash - && \ 
    DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:git-core/ppa && \
    DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:octave/stable && \
    DEBIAN_FRONTEND=noninteractive apt-get update -yqq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
        apt-utils && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
        dialog  && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
        bash-completion \
        language-pack-en locales \
        net-tools nodejs\
        git graphviz\
        openssh-server \
        octave \
        python3 python3-pip \
        tzdata \
        vim && \
    DEBIAN_FRONTEND=noninteractive apt-get -yqq upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -yqq dist-upgrade &&\
    DEBIAN_FRONTEND=noninteractive apt-get -yqq autoremove && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
    
# Step 7. Update LOCALE and TIMEZONE
ENV LANG en_HK.UTF-8 
RUN update-locale LANG="en_HK.UTF-8" LANGUAGE=en_HK:en
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone &&\
    dpkg-reconfigure --frontend noninteractive tzdata

# Step 8. Install `python3-pip` and upgrade it to the latest
RUN pip3 install --no-cache-dir --upgrade  pip && \
    pip3 install --no-cache-dir pqi &&\
    pqi use tuna 

# Step 9.0 Prepare Pytorch installation
RUN pip3 install http://download.pytorch.org/whl/cu90/torch-0.4.0-cp35-cp35m-linux_x86_64.whl


# Step 9.1 Install application level packages from `python3-pip`
COPY requirement.txt /home/requirement.txt
RUN pip3 install  -r  /home/requirement.txt  
    

# # Step A. Change default shell
# RUN ln -sf /bin/bash /bin/sh

# Step B. Enable nbextension, choose `--system` due to the docker env.
RUN \
    jupyter contrib nbextension install --system && \
    jupyter labextension install @jupyterlab/hub-extension

# Step C. create a user, since we don't want to run as root
RUN useradd -m -s /bin/bash jovyan
RUN bash
ENV HOME=/home/jovyan
WORKDIR $HOME
USER jovyan

# Step D. Copy startup shell scripts.
COPY start-singleuser.sh /usr/local/bin/
COPY start.sh /usr/local/bin/

# Step E. Set entrypoint
# ENTRYPOINT ["/bin/bash"]
CMD ["start-singleuser.sh"]


# Step F. Set labels
LABEL version="1.1.2" location="Shanghai, China." role="Team Computaion Platform."