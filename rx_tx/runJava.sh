#!/bin/bash
#the $1 is the current device name
if [ -z $1 ]
then
	yourid='0' 
else 
	yourid=$1 
fi
echo running java
sudo chmod 777 /dev/ttyUSB0
sudo chmod 777 /dev/ttyUSB1
javac -d . *.java
java net.tinyos.tools.Listen -comm serial@/dev/ttyUSB$yourid:telosb | java Displayer.Displayer

