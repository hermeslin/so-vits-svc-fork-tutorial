FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-devel

USER root
RUN ["apt", "update"]
RUN ["apt", "install", "-y", "build-essential"]
RUN ["pip", "install", "-U", "pip", "setuptools==69.2.0", "wheel==0.43.0"]
RUN ["pip", "install", "-U", "so-vits-svc-fork==4.1.58", "psutil==5.9.8"]

WORKDIR /workspace/storage

ENTRYPOINT [ "svc" ]
