#!/bin/bash
#
if [ -z $1 ]
then
	yourid='0' 
else 
	yourid=$1 
fi
echo running java
echo java net.tinyos.tools.Listen –comm serial@/dev/ttyUSB$yourid:telosb
sudo chmod 777 /dev/ttyUSB0
sudo chmod 777 /dev/ttyUSB1
javac Displayer.java
java net.tinyos.tools.Listen -comm serial@/dev/ttyUSB$yourid:telosb | java Displayer
echo 'exit'
