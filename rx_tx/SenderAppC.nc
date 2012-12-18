#include "TempRadio.h"

configuration SerialTestAppC{
	
}
implementation{
	components SenderC as AppC;
	components MainC, LedsC;
	components new TimerMilliC() as TimerMilli;
	components ActiveMessageC as AM;
	components new SensirionSht11C() as Sht;
	
	AppC.Boot -> MainC.Boot;
	AppC.Leds -> LedsC.Leds;
	AppC.Control -> AM.SplitControl;
	AppC.AMSend -> AM.AMSend[AM_TEMPERATURE_MSG];
	AppC.Packet -> AM.Packet;
	AppC.Timer -> TimerMilli.Timer;
	AppC.Read -> Sht.Temperature;
}
