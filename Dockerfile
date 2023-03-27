# Specify your base image here
FROM dtr.thefacebook.com/ayush29feb/base

ARG CONDA_PYTHON_VERSION=3
ARG CONDA_DIR=/opt/conda
ARG USERNAME=docker
ARG USERID=1000
ARG DEBIAN_FRONTEND=noninteractive

USER $USERNAME
WORKDIR /home/$USERNAME

RUN wget https://raw.githubusercontent.com/ayush29feb/nerf2mesh/main/environment.yml
RUN conda env create -f environment.yml
# RUN wget https://raw.githubusercontent.com/ayush29feb/nerf2mesh/main/requirements.txt
# RUN $CONDA_DIR/bin/python -m pip install -r requirements.txt
# RUN $CONDA_DIR/bin/python -m pip install pytorch3d

# RUN git clone https://github.com/facebookresearch/pytorch3d.git
# RUN $CONDA_DIR/bin/python -m pip install git+https://github.com/NVlabs/nvdiffrast/
