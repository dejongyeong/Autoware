#!/bin/bash

XSOCK=/tmp/.X11-unix
XAUTH=/home/$USER/.Xauthority
AUTOWARE_PATH=$( dirname $( dirname $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) ) )
echo "AUTOWARE_PATH $AUTOWARE_PATH"

nvidia-docker run \
    -d --rm \
    --net=host \
    --privileged \
    --volume=$XSOCK:$XSOCK:rw \
    --volume=$XAUTH:$XAUTH:rw \
    --volume=$HOST_DIR:$SHARED_DIR:rw \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY=${DISPLAY}" \
    --env="DEV_USER=${USER}" \
    --env="DEV_USER_ID=$(id -u)" \
    --env="DEV_USER_GROUP=$(id -g -n)" \
    --env="DEV_GROUP_ID=$(id -g)" \
    -v /dev:/dev \
    --volume=/run/user/$(id -u)/pulse:/run/pulse \
    -v "${AUTOWARE_PATH}":/home/$USER/Autoware \
    -v /media:/media \
    -w /home/$USER/Autoware \
    --name auro_autoware_container \
    gcr.io/auro-robotics/autoware

nvidia-docker exec auro_autoware_container bash -c /container_user_setup.sh
nvidia-docker exec -it --user $USER auro_autoware_container bash
