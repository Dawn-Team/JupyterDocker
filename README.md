# JupyterDocker
Customized docker image for shared computation platform

Base Image: tensorflow/tensorflow:latest-gpu-py3
Lisence to the base images are here:  
- [tensorflow/tensorflow:latest-gpu-py3](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/docker/README.md)
# Installation
1. From docker hub
```shell
docker pull dawnteam/jupyterhub-single
```

2. Local build
```shell
git clone git@github.com:Dawn-Team/JupyterDocker.git
docker build -t="dawnteam/jupyterhub-singles"
```


# Usage

```shell
docker run -it -p 8001:8888  dawnteam/jupyterhub-single jupyter-lab --ip=0.0.0.0
```
