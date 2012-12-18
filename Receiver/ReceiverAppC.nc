#include "TempRadio.h"

configuration ReceiverAppC {}

implementation {

	components ReceiverC as App;
	components MainC, LedsC;
	components ActiveMessageC as Radio;
	components SerialActiveMessageC as Serial;
	
	App.Boot -> MainC.Boot;
	App.Leds -> LedsC.Leds;
	App.Packet -> Serial.Packet;
	App.AMSend -> Serial.AMSend[AM_TEMPERATURE_MSG];
	App.Receive -> Radio.Receive[AM_TEMPERATURE_MSG];
	App.RadioControl -> Radio.SplitControl;
	App.SerialControl -> Serial.SplitControl;
}
