# IntelligentSystemsLabUTV/PX4-Autopilot

## Contents

**This is a fork of [PX4/PX4-Autopilot](https://github.com/PX4/PX4-Autopilot/tree/main).** The purpose of this fork is to provide a working environment for internal projects of the Intelligent Systems Lab research group.

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
