#!/bin/sh

# Build Docker Image
ROS_VERSION=${1:-"kinetic"}
if [ "$ROS_VERSION" = "kinetic" ] || [ "$ROS_VERSION" = "indigo" ]
then
    echo "Use $ROS_VERSION"
    nvidia-docker build -t gcr.io/auro-robotics/autoware-$ROS_VERSION -f Dockerfile.$ROS_VERSION . --no-cache
else
    echo "Select distribution, kinetic|indigo"
fi
