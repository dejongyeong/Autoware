#!/bin/sh

# Build Docker Image
ROS_VERSION=${1:-"kinetic"}
if [ "$ROS_VERSION" = "kinetic" ] || [ "$ROS_VERSION" = "indigo" ]
then
    echo "Use $ROS_VERSION"
    docker pull gcr.io/auro-robotics/autoware-$ROS_VERSION
else
    echo "Select distribution, kinetic|indigo"
fi
