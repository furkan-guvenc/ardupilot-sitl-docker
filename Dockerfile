FROM ubuntu:20.04

# install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git sudo lsb-release tzdata

# Need USER set so usermod does not fail...
RUN echo "nobody:nobody" | chpasswd && adduser nobody sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER nobody
WORKDIR /home/nobody

# Now grab ArduPilot from GitHub
RUN git clone --depth 1 https://github.com/ArduPilot/ardupilot.git ardupilot --recursive --shallow-submodules

WORKDIR ardupilot

ENV HOME=/home/nobody

RUN USER=nobody Tools/environment_install/install-prereqs-ubuntu.sh -y

# Continue build instructions from https://github.com/ArduPilot/ardupilot/blob/master/BUILD.md
RUN ./waf distclean && ./waf configure --board sitl && ./waf copter

# TCP 5760 is what the sim exposes by default
EXPOSE 5760/tcp

# Variables for simulator
ENV INSTANCE 0
ENV LAT 42.3898
ENV LON -71.1476
ENV ALT 14
ENV DIR 270
ENV MODEL +
ENV SPEEDUP 1

ARG VEHICLE_ID=1

# Assign VEHICLE_ID to SYSID_THISMAV
RUN echo "SYSID_THISMAV ${VEHICLE_ID}" >> Tools/autotest/default_params/copter.parm

# Finally the command
ENTRYPOINT Tools/autotest/sim_vehicle.py --vehicle ArduCopter -I${INSTANCE} --custom-location=${LAT},${LON},${ALT},${DIR} -w --frame ${MODEL} --no-rebuild --no-mavproxy --speedup ${SPEEDUP}
