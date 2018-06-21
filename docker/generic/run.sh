#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/home/$USER/.Xauthority
AUTOWARE_PATH=$( cd "$( dirname $( dirname $( dirname "${BASH_SOURCE[0]}" ) ) )" && pwd ) 
echo "AUTOWARE_PATH $AUTOWARE_PATH"


nvidia-docker run \
    -it --rm \
    --net=host \
    --privileged \
    --volume=$XSOCK:$XSOCK:rw \
    --volume=$XAUTH:$XAUTH:rw \
    --volume=$HOST_DIR:$SHARED_DIR:rw \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY=${DISPLAY}" \
    --env="DEV_USER=$(id -u)" \
    --env="DEV_USER_ID=$(id -u)" \
    --env="DEV_GROUP_ID=$(id -g)" \
    -v /dev:/dev \
    --volume=/run/user/$(id -u)/pulse:/run/pulse \
    -v "${AUTOWARE_PATH}":/home/$USER/Autoware \
    -v /media:/media \
    gcr.io/auro-robotics/autoware
