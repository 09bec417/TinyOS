#!/bin/bash
#
#please put this file alongside your .nc files and makefile
#a building script for TinysOS for telosb sensing node
#plug the USB in before 
#please attach the id(default=1) after ./makeTiny.sh
if [ -z $1 ]
then
	yourid='1' 
else 
	yourid=$1 
fi
echo "your id is " $yourid
echo .....
rm -r build
make telosb
motelist
sudo chmod 777 /dev/ttyUSB0
sudo chmod 777 /dev/ttyUSB1
make telosb install,$yourid /dev/ttyUSB0
