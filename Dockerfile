# Specify your base image here
FROM dtr.thefacebook.com/ayush29feb/pytorch
ARG CONDA_PYTHON_VERSION=3
ARG CONDA_DIR=/opt/conda
ARG USERNAME=docker
ARG USERID=1000
ARG DEBIAN_FRONTEND=noninteractive
# Instal basic utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends fish sudo openssh-server ffmpeg libsm6 libxext6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN $CONDA_DIR/bin/python -m pip install git+https://github.com/NVlabs/nvdiffrast/
RUN $CONDA_DIR/bin/python -m pip install git+https://github.com/facebookresearch/pytorch3d.git

WORKDIR /home/$USERNAME
RUN wget https://raw.githubusercontent.com/ayush29feb/nerf2mesh/main/requirements.txt
RUN $CONDA_DIR/bin/python -m pip install -r requirements.txt
