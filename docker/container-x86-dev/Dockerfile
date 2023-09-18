# DUA environment image.
#
# Roberto Masocco <robmasocco@gmail.com>
# Intelligent Systems Lab <isl.torvergata@gmail.com>
#
# April 5, 2023

FROM intelligentsystemslabutv/dua-foundation:x86-dev

# Change this if you encounter problems with the default user
ARG USER_UID=1000

ENV DEBIAN_FRONTEND=noninteractive

# IMAGE SETUP START #
# PX4 START #
# General dependecies to be installed must be determined by merging the contents of your DUA base
# unit of choice with the following files:
# - PX4-Autopilot/Tools/setup/ubuntu.sh
# - PX4-Autopilot/Tools/setup/requirements.txt
# - px4_ros_com/scripts/setup_system.bash
# and by fixing the inevitable compilation errors that you will get.
# They are necessary for the development of both PX4 and the microRTPS Bridge.
# Install PX4 general dependencies (also required by microRTPS Bridge)
RUN apt-get update && apt-get install -y --no-install-recommends \
  astyle \
  libxml2-dev \
  libgstreamer-plugins-base1.0-dev \
  rsync \
  python3-setuptools \
  python3-wheel && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*/apt/lists/*

# Install PX4 Python general dependencies (also required by microRTPS Bridge)
RUN yes | pip3 install -U \
  future \
  jinja2>=2.8 \
  jsonschema \
  kconfiglib \
  lxml \
  psutil \
  pygments \
  pymavlink \
  pyulog

# Install NuttX toolchain dependencies
# Get these from: PX4-Autopilot/Tools/setup/ubuntu.sh and merge with your base unit's contents
RUN apt-get update && apt-get install -y --no-install-recommends \
  automake \
  binutils-dev \
  bison \
  flex \
  g++-multilib \
	gcc-multilib \
	gdb-multiarch \
	genromfs \
	gettext \
	gperf \
  libelf-dev \
	libexpat-dev \
	libgmp-dev \
	libisl-dev \
	libmpc-dev \
	libmpfr-dev \
	libncurses5 \
	libncurses5-dev \
	libncursesw5-dev \
	libtool \
  texinfo \
  u-boot-tools \
  util-linux \
  vim-common && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*/apt/lists/*

# Download and install NuttX toolchain (pray that this remains online)
WORKDIR /opt
RUN wget -O /tmp/gcc-arm-none-eabi-9-2020-q2-update-linux.tar.bz2 https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 && \
  tar -jxf /tmp/gcc-arm-none-eabi-9-2020-q2-update-linux.tar.bz2 -C /opt/ && \
  rm /tmp/gcc-arm-none-eabi-9-2020-q2-update-linux.tar.bz2 && \
  chgrp -R internal gcc-arm-none-eabi-9-2020-q2-update && \
  chmod -R g+rw gcc-arm-none-eabi-9-2020-q2-update
ENV PATH=/opt/gcc-arm-none-eabi-9-2020-q2-update/bin:${PATH}
WORKDIR /root

# Build and install Foonathan memory allocator
WORKDIR /opt
RUN git clone --single-branch --branch 'v1.3.0' https://github.com/eProsima/foonathan_memory_vendor.git && \
  cd foonathan_memory_vendor && \
  mkdir build && \
  cd build && \
  cmake .. && \
  cmake --build . --target install && \
  cd ../.. && \
  chgrp -R internal foonathan_memory_vendor && \
  chmod -R g+rw foonathan_memory_vendor
WORKDIR /root

# Build and install Fast-DDS-Gen (required by microRTPS Bridge)
WORKDIR /opt
RUN git clone --recursive --single-branch --branch 'v2.4.0' https://github.com/eProsima/Fast-DDS-Gen.git && \
  cd Fast-DDS-Gen && \
  ./gradlew assemble && \
  ln -s /opt/Fast-DDS-Gen/scripts/fastddsgen scripts/fastrtpsgen && \
  cd .. && \
  chgrp -R internal Fast-DDS-Gen && \
  chmod -R g+rw Fast-DDS-Gen
WORKDIR /root
ENV PATH=/opt/Fast-DDS-Gen/scripts:${PATH}

# Build and install Fast-CDR
WORKDIR /opt
RUN git clone --single-branch --branch 'v1.1.1' https://github.com/eProsima/Fast-CDR.git && \
  cd Fast-CDR && \
  mkdir build && \
  cd build && \
  cmake .. && \
  make -j$(nproc --all) && \
  make install -j$(nproc --all) && \
  cd ../.. && \
  chgrp -R internal Fast-CDR && \
  chmod -R g+rw Fast-CDR
WORKDIR /root

# Build and install Fast-DDS
WORKDIR /opt
RUN git clone --single-branch --branch 'v2.10.1' https://github.com/eProsima/Fast-DDS.git && \
  cd Fast-DDS && \
  mkdir build && \
  cd build && \
  cmake -DTHIRDPARTY=ON .. && \
  make -j$(nproc --all) && \
  make install -j$(nproc --all) && \
  cd ../.. && \
  chgrp -R internal Fast-DDS && \
  chmod -R g+rw Fast-DDS
WORKDIR /root
# PX4 END #
# IMAGE SETUP END #

# Create a user with Zsh as shell, hashed password, and add it to the sudoers
# To generate the hashed password, run:
#   mkpasswd -m sha-512 -S PASSWORD intelsyslab
RUN useradd -r -m -s /usr/bin/zsh -u ${USER_UID} -G adm,dialout,internal,plugdev,sudo,tty,video -p '$6$intelsyslab$DVn8eT24upAB4SSgZMpYiv29SewU3ueUjBMaj3ublhs0NKQCItbKNmIOS/Skie.vQbqlfOvlo2Yoeu4OeUypk0' neo
ENV HOME=/home/neo

# Create workspace directory: host workspaces will be mounted here
RUN mkdir ${HOME}/workspace && \
    chown neo:neo ${HOME}/workspace

# Create directory for shell history file
RUN mkdir ${HOME}/zsh_history && \
    chown neo:neo ${HOME}/zsh_history

# Create SSH directory for user
RUN mkdir ${HOME}/.ssh

# Switch to internal user
USER neo
WORKDIR ${HOME}

# Copy user configuration files
COPY --chown=neo:neo ./aliases.sh ./.aliases.sh
COPY --chown=neo:neo ./bashrc ./.bashrc
COPY --chown=neo:neo ./colcon-defaults.yaml /home/neo/.colcon/defaults.yaml
COPY --chown=neo:neo ./commands.sh ./.commands.sh
COPY --chown=neo:neo ./nanorc ./.nanorc
COPY --chown=neo:neo ./ros2.sh ./.ros2.sh
COPY --chown=neo:neo ./vimrc ./.vimrc

# Configure Zsh for internal user
ENV ZSH=${HOME}/.oh-my-zsh
ENV ZSH_CUSTOM=${ZSH}/custom
ENV ZSH_PLUGINS=${ZSH_CUSTOM}/plugins
ENV ZSH_THEMES=${ZSH_CUSTOM}/themes
RUN wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh || true
RUN git clone --single-branch --branch 'master' --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS}/zsh-syntax-highlighting \
    && git clone --single-branch --branch 'master' --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_PLUGINS}/zsh-autosuggestions \
    && git clone --single-branch --depth 1 https://github.com/romkatv/powerlevel10k.git ${ZSH_THEMES}/powerlevel10k
COPY --chown=neo:neo ./p10k.zsh ./.p10k.zsh
COPY --chown=neo:neo ./zshrc ./.zshrc

ENV DEBIAN_FRONTEND=dialog

# Add image information
LABEL author.name="Roberto Masocco"
LABEL author.email="robmasocco@gmail.com"
LABEL organization.name="Intelligent Systems Lab"
LABEL organization.email="isl.torvergata@gmail.com"

# By default, start a basic shell
CMD ["bash"]
