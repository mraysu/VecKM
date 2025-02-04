FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

## apt installs
RUN apt update && apt-get upgrade -y
RUN apt-get update
RUN apt-get install -y ffmpeg libsm6 libxext6
RUN apt-get install -y wget
RUN apt-get install -y git

RUN wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh && \
    bash Anaconda3-2024.10-1-Linux-x86_64.sh -b

ENV PATH="$PATH:/root/anaconda3/bin/"

RUN git clone --depth=1 https://github.com/mraysu/VecKM /root/VecKM

RUN conda create -n veckm python=3.12 -y
RUN conda init bash

WORKDIR /root/VecKM

COPY requirements.txt .

# make RUN commands use the new environment
SHELL ["conda", "run", "--no-capture-output", "-n", "veckm", "/bin/bash", "-c"]

RUN yes | pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

RUN yes | pip install --default-timeout=100 -r requirements.txt && \
yes | apt-get install p7zip-full && \ 
yes | apt-get install vim && \
yes | apt-get install tmux

RUN echo "conda activate veckm" >> /root/.bashrcpip