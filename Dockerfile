# Specify your base image here
FROM nvcr.io/nvidia/pytorch:22.05-py3
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

RUN useradd --create-home -s /bin/bash --no-user-group -u $USERID $USERNAME && \
    chown $USERNAME $CONDA_DIR -R && \
    adduser $USERNAME sudo && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install miniconda
ENV PATH $CONDA_DIR/bin:$PATH
# RUN wget --quiet \
#     https://repo.continuum.io/miniconda/Miniconda$CONDA_PYTHON_VERSION-latest-Linux-x86_64.sh && \
#     echo 'export PATH=$CONDA_DIR/bin:$PATH' > /etc/profile.d/conda.sh && \
#     /bin/bash Miniconda3-latest-Linux-x86_64.sh -b -p $CONDA_DIR && \
#     rm -rf /tmp/*


# ARG CONDA_PYTHON_VERSION=3
# ARG CONDA_DIR=/opt/conda
# ARG USERNAME=docker
# ARG USERID=1000
# ARG DEBIAN_FRONTEND=noninteractive

USER $USERNAME
WORKDIR /home/$USERNAME

RUN wget https://raw.githubusercontent.com/ayush29feb/nerf2mesh/main/environment.yml
RUN cat environment.yml
RUN conda env create -f environment.yml
RUN conda init bash
RUN echo "conda activate nerf2mesh" >> ~/.bashrc

RUN conda install --name nerf2mesh pytorch-scatter -c pyg
# RUN conda install --name nerf2mesh pytorch3d -c pytorch3d

# RUN wget https://raw.githubusercontent.com/ayush29feb/nerf2mesh/main/requirements.txt
# RUN $CONDA_DIR/bin/python -m pip install -r requirements.txt
# RUN $CONDA_DIR/bin/python -m pip install pytorch3d

RUN git clone https://github.com/facebookresearch/pytorch3d.git
# RUN $CONDA_DIR/bin/python -m pip install git+https://github.com/NVlabs/nvdiffrast/
