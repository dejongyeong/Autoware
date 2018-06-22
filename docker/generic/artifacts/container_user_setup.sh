#!/bin/bash

if [ "$USING_DOCKER_GID" = true ]; then
    if [ "$USING_DIALOUT_GID" = true ]; then
        echo "Starting container with user: $DEV_USER, user id: $DEV_USER_ID, user group: $DEV_USER_GROUP, group id: $DEV_GROUP_ID, docker group id: $DOCKER_GROUP_ID, and dialout group id: $DIALOUT_GROUP_ID"
    fi
    elif [ "$USING_DOCKER_GID" = true ]; then
    echo "Starting container with user: $DEV_USER, user id: $DEV_USER_ID, user group: $DEV_USER_GROUP, group id: $DEV_GROUP_ID, and docker group id: $DOCKER_GROUP_ID"
    elif [ "$USING_DIALOUT_GID" = true ]; then
    echo "Starting container with user: $DEV_USER, user id: $DEV_USER_ID, user group: $DEV_USER_GROUP, group id: $DEV_GROUP_ID, and dialout group id: $DIALOUT_GROUP_ID"
else
    echo "Starting container with user: $DEV_USER, user id: $DEV_USER_ID, user group: $DEV_USER_GROUP, and group id: $DEV_GROUP_ID"
fi

addgroup --gid "$DEV_GROUP_ID" "$DEV_USER_GROUP"
if [ "$USING_DOCKER_GID" = true ]; then
    addgroup --gid "$DOCKER_GROUP_ID" "docker"
fi
if [ "$USING_DIALOUT_GID" = true ]; then
    addgroup --gid "$DIALOUT_GROUP_ID" "dialout"
fi
adduser --disabled-password \
--gecos '' "$DEV_USER" \
--uid "$DEV_USER_ID" \
--gid "$DEV_GROUP_ID" 2>/dev/null
usermod -aG sudo "$DEV_USER"
if [ "$USING_DOCKER_GID" = true ]; then
    usermod -aG docker "$DEV_USER"
fi
if [ "$USING_DIALOUT_GID" = true ]; then
    usermod -aG dialout "$DEV_USER"
fi
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
cp /root/.bashrc /home/${DEV_USER}
chown -R ${DEV_USER}:${DEV_USER_GROUP} "/home/${DEV_USER}"

# Adding devel_child_bashrc
SCRIPT="/devel_child_bashrc.sh"
PROFILE=/home/${DEV_USER}/.bashrc

if grep -Fxq "source $SCRIPT" $PROFILE
then
    echo "$SCRIPT already sourced in $PROFILE"
else
    echo "Add source $SCRIPT in $PROFILE"
    echo "source $SCRIPT" >> $PROFILE
fi

source /home/${DEV_USER}/.bashrc
