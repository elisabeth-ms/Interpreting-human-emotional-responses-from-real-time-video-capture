#!/bin/bash
set -e

source /opt/ros/melodic/setup.bash
source /home/default/catkin_ws/devel/setup.bash

exec "$@"
