FROM dustynv/pytorch:1.9-r32.7.1



ARG USERNAME=default
ARG PASSWORD=default
RUN apt update --fix-missing && apt install -y --no-install-recommends ca-certificates git sudo curl && \
    apt clean                                                                                        && \
    rm -rf /var/lib/apt/lists/*                                                                      && \
    useradd -rm -d /home/default -s /bin/bash -g root -G sudo -u 1000 $USERNAME                      && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd                                                        && \
    echo "Set disable_coredump false" >> /etc/sudo.conf                                              && \
    touch /home/$USERNAME/.sudo_as_admin_successful


RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

RUN sudo apt update && apt install -y ros-melodic-ros-base

#RUN apt-get update && apt-get install -y  python3-rosdep  python3-rosinstall  python3-rospkg  python3-catkin-pkg  python3-empy python3-rospkg-modules python3-catkin-pkg-modules


RUN sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential python3-catkin-tools python3-catkin-pkg-modules python3-rospkg-modules python3-catkin-pkg-modules

RUN sudo rosdep init
RUN rosdep update








WORKDIR /home/$USERNAME
RUN mkdir repos && cd repos
RUN git clone https://github.com/opencv/opencv.git && cd opencv && git checkout 3.4 && \
              mkdir build && cd build && cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local -D PYTHON_EXECUTABLE=/usr/bin/python3.6 .. && \ 
              make -j$(nproc) && make install


RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && mkdir -p catkin_ws/src && cd catkin_ws/src && \
                  git clone https://github.com/ros-perception/vision_opencv.git && cd vision_opencv && git checkout melodic && \
                  cd /home/$USERNAME/catkin_ws && catkin_make --cmake-args -DPYTHON_EXECUTABLE=/usr/bin/python3 \
		  -DPYTHON_INCLUDE_DIR=/usr/include/python3.6m \
                  -DPYTHON_LIBRARY=/usr/lib/aarch64-linux-gnu/libpython3.6m.so"

RUN export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.6/site-packages/cv2/python-3.6
RUN sudo apt install -y python3-matplotlib python3-pandas
RUN pip3 install torchvision

#copy entrypoint.sh /root/entrypoint.sh
#RUN chmod +x /root/entrypoint.sh

#ENTRYPOINT ["/root/entrypoint.sh"]
# catkin_make 
#&& source devel/setup.bash
#RUN curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py
#RUN python3.6 get-pip.py
#RUN python3.6 -m pip install torch
# RUN python3.6 -m pip install pandas
#RUN python3.6 -m pip install torchvision
# RUN python3.6 -m pip install pillow



