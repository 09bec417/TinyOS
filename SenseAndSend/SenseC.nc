#include <Timer.h>

configuration SenseC
{
}

implementation
{
	components SenseP, MainC, LedsC;
	components new TimerMilliC() as Timer;
	components ActiveMessageC;
	components new AMSenderC(AM_BLINKTORADIO);
    components new SensirionSht11C() as SHT11C;
    components new HamamatsuS1087ParC() as LightC;
    
    
	SenseP.Boot -> MainC.Boot;
	SenseP.Leds -> LedsC.Leds;
	SenseP.Timer -> Timer.Timer;
	SenseP.Packet -> AMSenderC;
	SenseP.AMSend -> AMSenderC;
	SenseP.AMControl -> ActiveMessageC.SplitControl;
    SenseP.Temperature -> SHT11C.Temperature;
    SenseP.Humidity -> SHT11C.Humidity;
    SenseP.Light -> LightC;
    
}
