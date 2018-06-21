#!/bin/bash
set -e
addgroup --gid "$DEV_GROUP_ID" "$DEV_USER"
 
adduser --disabled-password \
  --gecos '' "$DEV_USER" \
  --uid "$DEV_USER_ID" \
  --gid "$DEV_GROUP_ID" 2>/dev/null
usermod -aG sudo "$DEV_USER"
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
cp -r /etc/skel/. /home/${DOCKER_USER}
chown -R ${DEV_USER}:${DEV_USER} "/home/${DEV_USER}"
echo 'if [ -e "/home/${DOCKER_USER}/Autoware/ros/devel/setup.bash" ]; then source /home/${DOCKER_USER}/Autoware/ros/devel/setup.bash; fi' >> "/home/${DOCKER_USER}/.bashrc"
echo "ulimit -c unlimited" >> /home/${DOCKER_USER}/.bashrc

exec "$@"




 



