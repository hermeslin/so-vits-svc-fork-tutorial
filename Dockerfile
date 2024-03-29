FROM pytorch/pytorch:latest

USER root
RUN ["apt", "update"]
RUN ["apt", "install", "-y", "build-essential"]
RUN ["pip", "install", "-U", "pip", "setuptools", "wheel"]
RUN ["pip", "install", "-U", "so-vits-svc-fork", "psutil"]

WORKDIR /workspace/storage

ENTRYPOINT [ "svc" ]
