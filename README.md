ArduPilot Software-in-the-Loop Simulator Docker Container
=========================================================

The purpose of this is to run an ArduPilot SITL from within Docker.

DockerHub
---------

A pre-built Docker image is available on DockerHub at:

https://hub.docker.com/r/furkanguvenc/ardupilot-sitl

To download it, simply:

`docker pull furkanguvenc/ardupilot-sitl`
 
and to run it:

`docker run -it --rm -p 5760:5760 furkanguvenc/ardupilot-sitl`


Quick Start
-----------

If you'd rather build the docker image yourself:

`docker build --tag ardupilot github.com/furkanguvenc/ardupilot-sitl-docker`

You can now use the `--build-arg` option to give a different id to your vehicle. 
It will be assigned to [SYSID_THISMAV parameter](https://ardupilot.org/copter/docs/parameters.html#sysid-thismav-mavlink-system-id-of-this-vehicle).
Here's an example:

`docker build --tag ardupilot --build-arg VEHICLE_ID=2 github.com/furkanguvenc/ardupilot-sitl-docker`

If no COPTER_TAG is supplied, the build will use the default defined in the Dockerfile, currently set at Copter-4.0.3

To run the image:

`docker run -it --rm -p 5760:5760 ardupilot`

This will start an ArduCopter SITL on host TCP port 5760, so to connect to it from the host, you could:

`mavproxy.py --master=tcp:localhost:5760`

Options
-------

To run the vehicle instance on port 5761, you could:

`docker run -it --rm -p 5761:5760 ardupilot`

We also have an example `env.list` file which can help you maintain your options and called like so:

`docker run -it --rm -p 5761:5760 --env-file env.list ardupilot`

The full list of options and their default values is:

```
INSTANCE    0
LAT         42.3898
LON         -71.1476
ALT         14
DIR         270
MODEL       +
SPEEDUP     1
```

So, for example, you could issue a command such as:

```
docker run -it --rm -p 5761:5760 \
   --env MODEL=singlecopter \
   --env LAT=39.9656 \
   --env LON=-75.1810 \
   --env ALT=276 \
   --env DIR=180 \
   --env SPEEDUP=2 \
   ardupilot
```
