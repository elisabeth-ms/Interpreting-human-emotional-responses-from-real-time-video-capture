FROM ros:noetic-ros-base-focal



ARG USERNAME=default
ARG PASSWORD=default
RUN apt update --fix-missing && apt install -y --no-install-recommends ca-certificates git sudo curl && \
    apt clean                                                                                        && \
    rm -rf /var/lib/apt/lists/*                                                                      && \
    useradd -rm -d /home/default -s /bin/bash -g root -G sudo -u 1000 $USERNAME                      && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd                                                        && \
    echo "Set disable_coredump false" >> /etc/sudo.conf                                              && \
    touch /home/$USERNAME/.sudo_as_admin_successful

RUN apt update && apt install -y \
    libgl1-mesa-glx \
    libglib2.0-0
RUN apt-get install -y ros-$ROS_DISTRO-cv-bridge net-tools




# Head over to https://docs.conda.io/en/latest/miniconda.html#linux-installers to grab the link for Miniconda
# ARG MINICONDA_DOWNLOAD_LINK=https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
# ARG MINICONDA_INSTALL_PATH=/home/$USERNAME

# WORKDIR $MINICONDA_INSTALL_PATH
# ENV PATH  ${MINICONDA_INSTALL_PATH}/miniconda3/bin:$PATH

# 1. Install Miniconda and update packges to latest
# ("conda init" is optional as above ENV adds the required PATH)
# 2. Install PyTorch and any other required packages
# 3. Clear conda/pip cache
# RUN curl $MINICONDA_DOWNLOAD_LINK --create-dirs -o Miniconda.sh                && \
#     bash Miniconda.sh -b -p ./miniconda3                                       && \
#     rm Miniconda.sh                                                            && \
#     conda init                                                                 && \
#     conda update -y --all                                                      && \
#     pip install numpy                                                          && \
#     conda install -y pytorch torchvision cudatoolkit=11.1 -c pytorch -c nvidia && \
#     conda clean -afy                                                           && \
#     rm -rf .cache


WORKDIR /home/$USERNAME

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.8 get-pip.py
RUN python3.8 -m pip install torch==1.8.1+cu111 torchvision==0.9.1+cu111 -f https://download.pytorch.org/whl/torch_stable.html
RUN python3.8 -m pip install scikit-learn==1.0.1
RUN python3.8 -m pip install matplotlib==3.4.3
RUN python3.8 -m pip install pandas==1.3.4
RUN python3.8 -m pip install numpy==1.20.2
RUN python3.8 -m pip install opencv_python
RUN python3.8 -m pip install torchvision==0.9.1
RUN python3.8 -m pip install pillow==8.2.0

RUN mkdir repos

