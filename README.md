# IntelligentSystemsLabUTV/PX4-Autopilot

## Abstract

**This is a fork of [PX4/PX4-Autopilot](https://github.com/PX4/PX4-Autopilot/tree/main).** The purpose of this fork is to provide a working environment for internal projects of the Intelligent Systems Lab research group.

The layout of this repository is based on the [Distributed Unified Architecture](https://github.com/IntelligentSystemsLabUTV/dua-template).

### Cloning the repository

This repository has a plethora of submodules, so it can be cloned using the following command:

```bash
git clone URL --recursive
```

If you forget to clone it recursively, you can always initialize submodules later using the following command:

```bash
git submodule update --init --recursive
```

from the repo's root directory (note the `--recursive` flag).

### Configuring development branches

The `main` branch is meant to track the upstream repository. **Do not push or merge to the `main` branch.**

In case you want to update the fork, you can use the following commands:

```bash
# Add the "upstream" remote, if it doesn't exist in your local copy
git remote add upstream git@github.com:PX4/PX4-Autopilot.git

# Fetch the latest changes from the upstream repository
git fetch upstream

# Merge the changes into your local copy
git pull --rebase upstream main
```

Other branches, like `v1.12.3-dev` or `v1.13.3-dev`, are meant to be working environments based on stable releases. When `upstream` has been fetched, a new branch can be created from a tag doing, *e.g.*,

```bash
git checkout -b v1.13.3-dev v1.13.3
```

Additional hints can be found [here](https://github.com/readme/guides/configure-git-environment).

**During all of this, submodules may give problems.** Try to clean them completely by running

```bash
git clean -fdx
```

or similar commands, inspecting the output of `git status` and `git submodule status` to see what is going on. If you are not sure about what you are doing, you can always delete the repository and clone it again.

### DUA compatibility

This project has not been developed with DUA originally, so it is not fully compatible with it. DUA provides common, replicable development environments for it, but the high reliance of PX4 on submodules makes it impossible to configure this project as an independent unit that can be included in other projects.

The directory structure of the PX4 repository is also not fully compatible with DUA, hence the following changes have been made with respect to the structure of [`dua-template`](https://github.com/IntelligentSystemsLabUTV/dua-template):

* `bin` has been renamed to `dua-bin` to avoid conflicts with the `bin` directory of PX4.
* `orig` contains folders and files of the upstream repository which conflicted with DUA's structure.

### Configuring and building a target

This sections is going to give just some hints, for a full reference please refer to the [PX4 User Guide](https://docs.px4.io/master/en/).

The build system is based on CMake, which is what the general [`Makefile`](Makefile) calls. Refer to the [`cmake`](cmake) directory for more information and some hints on how to configure the build to add new modules, drivers, etc.

All build targets are found in the [`boards`](boards) directory. The `.px4board` files there specify which modules, driver, and firwmare components each target must include, the toolchain to use, and other similar settings. Add or modify those files to configure a specific build target.

Currently supported build targets, both with and without the RTPS module, are:

* `fmuv5`: FMU v5 (Pixhawk 4) target.
* `fmuv6c`: FMU v6C (Pixhawk 6C) target.
* `sitl`: SITL (Software In The Loop) simulation target.

Build can be invoked by running the relevant [custom commands](#custom-commands) from the root directory of this repository, or by invoking `make` directly with the appropriate arguments.

Generated executables and flashable binaries will be found in the `build` directory, which is created automatically when building.

To clean after a build, run `make clean` or `git clean -fdx`, **but be careful as this will also remove all untracked files and directories**.

#### Disabled modules and components

To reduce the size of the flashable binaries for the FMU targets, some modules and components have been disabled by default, *i.e.*, specifically marked as such in the board configurations. The following modules have been disabled:

* `CAMERA` modules.
* `HEATER`
* `HYGROMETERS`
* `OSD`
* `ROBOCLAW`
* Eventual `EXAMPLES` modules.
* All `AUTOTUNE` modules, since we intend to tune our controllers manually depending on the specific airframes.
* `MICRODDS_CLIENT`, since this version is still based on RTPS and Micro-XRCE-DDS support is still highly experimental.

### Custom commands

The following commands have been added to the shell's configuration of all development targets to bypass the ones provided by the default [`Makefile`](Makefile):

* `builddefaut`: builds the default targets, *i.e.*, non-RTPS versions of FMU v5, FMU v6C, SITL.
* `buildfmuv5`: builds the FMU v5 RTPS target.
* `buildfmuv6c`: builds the FMU v6C RTPS target.
* `buildsitl`: builds the SITL (Software In The Loop) simulation RTPS target, including Gazebo plugins.
* `px4`: runs the PX4 firmware SITL RTPS target, *i.e.*, the `px4` executable alone, without any simulator, loading the default `iris` vehicle and predefined (but modifiable) init scripts.
* `px4kill`: if all goes wrong, kills all active PX4 and Gazebo processes.

## Contents

This repository holds the [PX4](http://px4.io) flight control solution for drones, with the main applications located in the [src/modules](https://github.com/PX4/PX4-Autopilot/tree/master/src/modules) directory. It also contains the PX4 Drone Middleware Platform, which provides drivers and middleware to run drones.

PX4 is highly portable, OS-independent and supports Linux, NuttX and MacOS out of the box.

* Official Website: <http://px4.io> (License: BSD 3-clause, [LICENSE](https://github.com/PX4/PX4-Autopilot/blob/master/LICENSE))
* [Supported airframes](https://docs.px4.io/master/en/airframes/airframe_reference.html) ([portfolio](http://px4.io/#airframes)):
  * [Multicopters](https://docs.px4.io/master/en/frames_multicopter/)
  * [Fixed wing](https://docs.px4.io/master/en/frames_plane/)
  * [VTOL](https://docs.px4.io/master/en/frames_vtol/)
  * [Autogyro](https://docs.px4.io/master/en/frames_autogyro/)
  * [Rover](https://docs.px4.io/master/en/frames_rover/)
  * many more experimental types (Blimps, Boats, Submarines, High altitude balloons, etc)
* Releases: [Downloads](https://github.com/PX4/PX4-Autopilot/releases)

## Building a PX4 based drone, rover, boat or robot

The [PX4 User Guide](https://docs.px4.io/master/en/) explains how to assemble [supported vehicles](https://docs.px4.io/master/en/airframes/airframe_reference.html) and fly drones with PX4.
See the [forum and chat](https://docs.px4.io/master/en/#support) if you need help!

## Supported Hardware

This repository contains code supporting Pixhawk standard boards (best supported, best tested, recommended choice) and proprietary boards.

### Pixhawk Standard Boards

* FMUv6X and FMUv6U (STM32H7, 2021)
  * Various vendors will provide FMUv6X and FMUv6U based designs Q3/2021
* FMUv5 and FMUv5X (STM32F7, 2019/20)
  * [Pixhawk 4 (FMUv5)](https://docs.px4.io/master/en/flight_controller/pixhawk4.html)
  * [Pixhawk 4 mini (FMUv5)](https://docs.px4.io/master/en/flight_controller/pixhawk4_mini.html)
  * [CUAV V5+ (FMUv5)](https://docs.px4.io/master/en/flight_controller/cuav_v5_plus.html)
  * [CUAV V5 nano (FMUv5)](https://docs.px4.io/master/en/flight_controller/cuav_v5_nano.html)
  * [Auterion Skynode (FMUv5X)](https://docs.px4.io/master/en/flight_controller/auterion_skynode.html)
* FMUv4 (STM32F4, 2015)
  * [Pixracer](https://docs.px4.io/master/en/flight_controller/pixracer.html)
  * [Pixhawk 3 Pro](https://docs.px4.io/master/en/flight_controller/pixhawk3_pro.html)
* FMUv3 (STM32F4, 2014)
  * [Pixhawk 2](https://docs.px4.io/master/en/flight_controller/pixhawk-2.html)
  * [Pixhawk Mini](https://docs.px4.io/master/en/flight_controller/pixhawk_mini.html)
  * [CUAV Pixhack v3](https://docs.px4.io/master/en/flight_controller/pixhack_v3.html)
* FMUv2 (STM32F4, 2013)
  * [Pixhawk](https://docs.px4.io/master/en/flight_controller/pixhawk.html)
  * [Pixfalcon](https://docs.px4.io/master/en/flight_controller/pixfalcon.html)

### Manufacturer and Community supported

* [Holybro Durandal](https://docs.px4.io/master/en/flight_controller/durandal.html)
* [Hex Cube Orange](https://docs.px4.io/master/en/flight_controller/cubepilot_cube_orange.html)
* [Hex Cube Yellow](https://docs.px4.io/master/en/flight_controller/cubepilot_cube_yellow.html)
* [Airmind MindPX V2.8](http://www.mindpx.net/assets/accessories/UserGuide_MindPX.pdf)
* [Airmind MindRacer V1.2](http://mindpx.net/assets/accessories/mindracer_user_guide_v1.2.pdf)
* [Bitcraze Crazyflie 2.0](https://docs.px4.io/master/en/complete_vehicles/crazyflie2.html)
* [Omnibus F4 SD](https://docs.px4.io/master/en/flight_controller/omnibus_f4_sd.html)
* [Holybro Kakute F7](https://docs.px4.io/master/en/flight_controller/kakutef7.html)
* [Raspberry PI with Navio 2](https://docs.px4.io/master/en/flight_controller/raspberry_pi_navio2.html)

Additional information about supported hardware can be found in [PX4 user Guide > Autopilot Hardware](https://docs.px4.io/master/en/flight_controller/).

---

## License

This work is licensed under the BSD 3-Clause License. See the [`LICENSE`](LICENSE) file for details.

## Copyright

Copyright (c) 2012 - 2022, PX4 Development Team

Copyright (c) 2023, Intelligent Systems Lab, University of Rome Tor Vergata
