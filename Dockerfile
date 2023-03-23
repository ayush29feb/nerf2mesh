# Specify your base image here
FROM nvidia/cuda:11.6.0-base-ubuntu18.04
ARG CONDA_PYTHON_VERSION=3
ARG CONDA_DIR=/opt/conda
ARG USERNAME=docker
ARG USERID=1000
ARG DEBIAN_FRONTEND=noninteractive
# Instal basic utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget unzip bzip2 sudo build-essential ca-certificates openssh-server vim ffmpeg libsm6 libxext6 python3-opencv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Install miniconda
ENV PATH $CONDA_DIR/bin:$PATH
RUN wget --quiet \
    https://repo.continuum.io/miniconda/Miniconda$CONDA_PYTHON_VERSION-latest-Linux-x86_64.sh && \
    echo 'export PATH=$CONDA_DIR/bin:$PATH' > /etc/profile.d/conda.sh && \
    /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p $CONDA_DIR && \
    rm -rf /tmp/*
# Create the user
RUN useradd --create-home -s /bin/bash --no-user-group -u $USERID $USERNAME && \
    chown $USERNAME $CONDA_DIR -R && \
    adduser $USERNAME sudo && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER $USERNAME

RUN $CONDA_DIR/bin/conda install pytorch torchvision torchaudio cudatoolkit=11.6 -c pytorch -c conda-forge

RUN $CONDA_DIR/bin/python -m pip install tqdm scikit-image opencv-python configargparse lpips imageio-ffmpeg kornia lpips tensorboard
RUN $CONDA_DIR/bin/python -m pip install imageio easydict matplotlib scipy kornia plyfile joblib
RUN $CONDA_DIR/bin/python -m pip install timm
