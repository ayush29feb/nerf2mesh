# Specify your base image here
FROM nvcr.io/nvidia/pytorch:22.05-py3

ARG GROUP_ID=1001
ARG GROUP_NAME=photoreal
ARG CUDA_ARCH="7.0 7.5 8.0 8.6+PTX"
ARG CONDA_PYTHON_VERSION=3
ARG CONDA_DIR=/opt/conda
ARG USER_NAME=docker
ARG USER_ID=1000
ARG DEBIAN_FRONTEND=noninteractive

# Instal basic utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends fish sudo openssh-server ffmpeg libsm6 libxext6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set-up user and env variables
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME}
RUN useradd -m --no-log-init --system  --uid ${USER_ID} ${USER_NAME} -g ${GROUP_NAME} && \
    usermod -a -G sudo ${USER_NAME} && \
    usermod -a -G users ${USER_NAME} && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ${USER_NAME}:${GROUP_NAME}

# Set-up folders used by VSCode
RUN mkdir -p /home/$USER_NAME/.vscode-server/extensions && \
    chown -R $USER_NAME /home/$USER_NAME/.vscode-server

ENV TORCH_CUDA_ARCH_LIST=$CUDA_ARCH
ENV IABN_FORCE_CUDA=1
ENV FORCE_CUDA=1

# Copy files
WORKDIR /home/${USER_NAME}

# Install Python libraries
RUN python -m pip install \
    torch \
    numpy  \
    scipy \
    pandas \
    torch-ema \
    tensorboardX \
    torchmetrics

RUN python -m pip install \
    rich \
    tqdm \
    ninja \
    lpips \
    trimesh \
    PyMCubes \
    dearpygui \
    packaging \
    matplotlib

RUN python -m pip install \
    opencv-python \
    imageio \
    imageio-ffmpeg \
    pymeshlab \
    xatlas \
    scikit-learn

# Install VSCode dependencies
ENV PATH=/home/$USER_NAME/.local/bin:$PATH
RUN python -m pip install flake8 yapf

# Install pytorch3d from git
RUN python -m pip install torch-scatter
RUN python -m pip install git+https://github.com/NVlabs/nvdiffrast/ --use-feature=in-tree-build
RUN python -m pip install git+https://github.com/facebookresearch/pytorch3d.git --use-feature=in-tree-build
