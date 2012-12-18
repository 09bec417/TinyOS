COMPONENT=SenderAppC
BUILD_EXTRA_DEPS += TemperatureMsg.class
CLEAN_EXTRA = *.class TemperatureMsg.java

TemperatureMsg.class: $(wildcard *.java) TemperatureMsg.java
	javac *.java
TemperatureMsg.java:
	mig java -target=null -java-classname=TemperatureMsg TempRadio.h temperature_msg -o $@

include $(MAKERULES)

