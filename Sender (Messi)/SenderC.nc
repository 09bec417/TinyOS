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
		interface Read<uint16_t>;
	}
}
implementation{
	message_t packet;
	bool busy;

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

	event void Timer.fired(){ // start reading temperature.
		call Leds.led2On();
		call Read.read();
	}

	event message_t* Receive.receive(message_t* msg, void* pl, uint8_t len) {
		call Leds.led0Toggle();
		/*		
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
				if(sizeof(payload2) > (call Packet.maxPayloadLength())){
					return NULL;
				}
				
				if((call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(temperature_msg_t))) == SUCCESS){
					call Leds.led0On();
					busy = TRUE;
				}
				return msg;
			}
		}
		*/
		return msg;
	}	

	event void AMSend.sendDone(message_t *msg, error_t error){
		
		if(msg == &packet){
			busy = FALSE;
		}
		call Leds.led2Off();
	}

	event void Read.readDone(error_t result, uint16_t val){ // fill packet's payload and ready for transfer.
		
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
		payload->temperature = val;
		
		if((call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(temperature_msg_t))) == SUCCESS){
			busy = TRUE;
		}
	}
}
