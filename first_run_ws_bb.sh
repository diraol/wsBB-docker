#!/bin/bash
docker run -it --net host --cpuset-cpus 0 --memory 512mb -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v /dev/shm:/dev/shm --name bb-pj --restart=on-failure:1 diraol-ws-bb
