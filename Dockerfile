# Run Warsaw in a container

# First run:
#
# ./first_run_ws_bb.sh
#
# OR
#
# docker run -it \
#    --net host \ # may as well YOLO
#    --cpuset-cpus 0 \ # control the cpu
#    --memory 512mb \ # max memory it can use
#    -v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
#    -e DISPLAY=unix$DISPLAY \
#    --device /dev/snd \ # so we have sound
#    -v /dev/shm:/dev/shm \
#    --name bb-pj \
#    --restart=on-failure:1
#    diraol-ws-bb
#
# Other run:
#
# docker start bb-pj

# Base docker image
FROM ubuntu:latest
LABEL maintainer "Fabio Rodrigues Ribeiro <farribeiro@gmail.com>"

# Install Firefox
RUN apt-get update \
	&& apt-get -o Acquire::ForceIPv4=true upgrade -y \
	&& apt-get -o Acquire::ForceIPv4=true install -y \
	language-pack-pt \
	openssl \
	libnss3-tools \
	firefox \
	firefox-locale-pt \
	xauth \
	--no-install-recommends \
	# firefox -CreateProfile default
	&& apt-get purge --auto-remove -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /src/*.deb

RUN apt-get -o Acquire::ForceIPv4=true update

# Warsaw for CEF
ADD https://cloud.gastecnologia.com.br/cef/warsaw/install/GBPCEFwr64.deb /src/
# Warsaw for BB
# ADD https://cloud.gastecnologia.com.br/bb/downloads/ws/warsaw_setup64.deb /src/warsaw_setup64.deb
COPY startup.sh /home/ff/

# A3 Cert signing module from BB.
# To run this module it is necessary to install JAVA
# ADD https://www14.bancobrasil.com.br/bbsmartcard/bb_modulo_assinatura_linux.jar /src/bb_modulo_assinatura_linux.jar

# Add ff  user
RUN groupadd -g 1000 -r ff \
	&& useradd -u 1000 -r -g ff -G audio,video ff \
	&& mkdir -p /home/ff \
	&& chmod 744 /home/ff/startup.sh \
	&& chown -R ff:ff /home/ff \
	&& passwd -d root


# Run firefox as non privileged user
USER ff

# Autorun chrome
CMD [ "/home/ff/startup.sh" ]
