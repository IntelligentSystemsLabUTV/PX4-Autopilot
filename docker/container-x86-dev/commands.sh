#!/usr/bin/env bash

# Project-specific shell functions and commands.
#
# Roberto Masocco <r.masocco@dotxautomation.com>
#
# June 13, 2024

# Copyright 2024 dotX Automation s.r.l.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Add yours, some convenient ones are provided below.
# You can also source other files from sub-units included by this project.

# shellcheck disable=SC1090

# Source DUA commands
source ~/.dua_submod.sh
source ~/.dua_subtree.sh

# Routine to convert an angle in degrees [-180° +180°] to radians [-PI +PI].
function degrad {
  local angle_in_degrees="$1"
  angle_in_radians=$(python3 -c "import sys, math; angle=float(sys.argv[1]); print(math.radians((angle + 180) % 360 - 180))" "$angle_in_degrees")
  echo "$angle_in_radians"
}

# Routine to update dua-utils.
function utils-update {
  CURR_SHELL=$(ps -p $$ | awk 'NR==2 {print $4}')

  pushd || return
  cd /opt/ros/dua-utils || return
  git pull
  git submodule update --init --recursive
  rm -rf install
  colcon build --merge-install
  rm -rf build log
  source "install/local_setup.$CURR_SHELL"
  popd || return
}

# Routine to build the PX4 firmware default targets.
function builddefault {
  PYTHONPATH_OLD="${PYTHONPATH}"
  export PYTHONPATH=/usr/local/lib/python3.10/dist-packages:${PYTHONPATH}

  cd /home/neo/workspace || return 1
  make px4_fmu-v5_default "-j$(nproc --all)"
  make px4_fmu-v6c_default "-j$(nproc --all)"
  make px4_sitl_default "-j$(nproc --all)"
  make px4_sitl_default sitl_gazebo "-j$(nproc --all)"

  export PYTHONPATH="${PYTHONPATH_OLD}"
}

# Routine to build the PX4 firmware for FMU v5.
function buildfmuv5 {
  cd /home/neo/workspace || return 1
  PYTHONPATH=/usr/local/lib/python3.10/dist-packages:${PYTHONPATH} \
    make px4_fmu-v5_rtps "-j$(nproc --all)"
}

# Routine to build the PX4 firmware for FMU v6C.
function buildfmuv6c {
  cd /home/neo/workspace || return 1
  PYTHONPATH=/usr/local/lib/python3.10/dist-packages:${PYTHONPATH} \
    make px4_fmu-v6c_rtps "-j$(nproc --all)"
}

# Routine to build the PX4 SITL target.
function buildsitl {
  cd /home/neo/workspace || return 1
  PYTHONPATH=/usr/local/lib/python3.10/dist-packages:${PYTHONPATH} \
    make px4_sitl_rtps "-j$(nproc --all)" && \
    make px4_sitl_rtps sitl_gazebo "-j$(nproc --all)"
}

# Routine to start the STIL PX4 executable.
function px4 {
  # Check input arguments
  if [[ $# -eq 1 ]]; then
    if [[ "$1" == "stanis23" ]]; then
      export PX4_SIM_MODEL=stanis23
      /home/neo/workspace/build/px4_sitl_rtps/bin/px4 \
        /home/neo/workspace/build/px4_sitl_rtps/etc \
        -w /home/neo/workspace/build/px4_sitl_rtps/sitl_stanis23 \
        -s /home/neo/workspace/build/px4_sitl_rtps/etc/init.d-posix-isl/rcS
    fi
  else
    # Launch a default simulation with the Iris model
    export PX4_SIM_MODEL=iris
    /home/neo/workspace/build/px4_sitl_rtps/bin/px4 \
      /home/neo/workspace/build/px4_sitl_rtps/etc \
      -w /home/neo/workspace/build/px4_sitl_rtps/sitl_iris_0 \
      -s /home/neo/workspace/build/px4_sitl_rtps/etc/init.d-posix/rcS
  fi
}

# Routine to kill all running PX4 and Gazebo instances.
function px4kill {
	pkill -x px4
	pkill gzclient
	pkill gzserver
}
