#!/usr/bin/env bash

# Project-specific shell functions and commands.
#
# Roberto Masocco <robmasocco@gmail.com>
# Intelligent Systems Lab <isl.torvergata@gmail.com>
#
# April 4, 2023

# Add yours, some convenient ones are provided below.
# You can also source other files from sub-units included by this project.

# Routine to convert an angle in degrees [-180° +180°] to radians [-PI +PI]
function degrad {
  if [[ $# -ne 1 ]] || [[ $1 -lt -180 ]] || [[ $1 -gt 180 ]]; then
    echo >&2 "Usage:"
    echo >&2 "    degrad ANGLE"
    echo >&2 "ANGLE must be in degrees and in [-180° +180°]"
    return 1
  fi
  local OP
  local FIRST
  local SECOND
  local RES
  OP="scale=6;$1*3.14159265359/180.0"
  RES="$(bc <<<"$OP")"
  FIRST="${RES:0:1}"
  SECOND="${RES:1:1}"
  if [[ $FIRST == "." ]]; then
    RES="0${RES}"
  fi
  if [[ $FIRST == "-" ]] && [[ $SECOND == "." ]]; then
    RES="-0.${RES:2:6}"
  fi
  echo "$RES"
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
