#define TIMER_MILLI 2000

#include "TempRadio.h"

module SenderC{
	uses{
		interface SplitControl as Control;
		interface Leds;
		interface Boot;
		interface Receive;
		interface Timer<TMilli>;
		interface AMSend;
		interface Packet;
		interface Read<uint16_t> as Temperature;
		interface Read<uint16_t> as Humidity;
		interface Read<uint16_t> as Light;
	}
}
implementation{
	message_t packet;
	bool busy;
	uint16_t temperature;
	uint16_t humidity;
	uint16_t light;
	uint16_t amark;
	uint16_t label;
	uint16_t base;
	uint16_t i;
	event void Control.stopDone(error_t error){
		
		// do nothing
	}

	event void Control.startDone(error_t error){
				
		if(error != SUCCESS){
			call Control.start();
		}
	}

	event void Boot.booted(){ // start timer when node boots
		busy = FALSE;
		call Control.start();
		call Timer.startPeriodic(TIMER_MILLI);
	}

	event void Timer.fired(){ // start reading readings.
		call Leds.led2On();
		call Temperature.read();
		call Humidity.read();
		call Light.read();
		if (!busy) {
			 temperature_msg_t* payload = (temperature_msg_t*)call Packet.getPayload(&packet, sizeof(temperature_msg_t));
		   	 if(payload == NULL){
		   		dbgerror("error", "failed to get payload\n");
						return;
						}
		
			if(call Packet.maxPayloadLength() < sizeof(temperature_msg_t)){
				dbgerror("error", "max payload size exceeded\n");
				return;
			}

			payload->nodeid = TOS_NODE_ID;
			payload->temperature = temperature;
			payload->humidity = humidity;
			payload->light = light;

			base = 1;
			for(i = 0;i < TOS_NODE_ID - 1;++i) {
				base = base * 2;
			}
                        payload->flag = base;
			if((call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(temperature_msg_t))) == SUCCESS){
			    busy = TRUE;
			}
		}

	}

	event message_t* Receive.receive(message_t* msg, void* pl, uint8_t len) {
	        //This is where you should change!!

		if(len != sizeof(temperature_msg_t)){
			return msg;
		}
		else {
			if(busy == TRUE){
				return NULL;
			} else {
				temperature_msg_t* payload1 = (temperature_msg_t *)pl;
				temperature_msg_t* payload2 = (temperature_msg_t *)call Packet.getPayload(&packet, sizeof(temperature_msg_t));
				if(payload2 == NULL){
					return NULL;
				}
				payload2->nodeid = payload1->nodeid;
				payload2->temperature = payload1->temperature;
				payload2->humidity = payload1->humidity;
				payload2->light = payload1->light;
				payload2->flag = payload1->flag;

				if(sizeof(payload2) > (call Packet.maxPayloadLength())){
					return NULL;
				}
			

				amark = payload1->flag;
				
				base = 1;
				for(i = 0;i < TOS_NODE_ID - 1;++i) {
					base = base * 2;
				}				
				
				label = amark & base;
				
				if(label == 0) {
					
					
					amark = amark + base;
					payload2->flag = amark;
					
					if((call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(temperature_msg_t))) == SUCCESS){
						call Leds.led0On();
						busy = TRUE;
					}
				}
			}
		}

		call Leds.led0Toggle();
		return msg;
	}	

	event void AMSend.sendDone(message_t *msg, error_t error){
		if(msg == &packet){
			busy = FALSE;
		}
		call Leds.led2Off();
	}

	event void Temperature.readDone(error_t error, uint16_t data)
    	{
		temperature = data;
    	}

    	event void Humidity.readDone(error_t error, uint16_t data)
    	{
		humidity = data;
    	}
	event void Light.readDone(error_t error, uint16_t data)
    	{
		light = data;
    	}
}
