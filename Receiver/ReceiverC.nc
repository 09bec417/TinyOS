#include "TempRadio.h"

module ReceiverC {

	uses {
		interface Boot;
		interface Leds;
		interface AMSend;
		interface Receive;
		interface Packet;
		interface SplitControl as RadioControl;
		interface SplitControl as SerialControl;
	}
}

implementation{
	
	message_t packet;
	bool busy = FALSE;
	
	event void Boot.booted(){
		
		call RadioControl.start();
		call SerialControl.start();
		
	}
	
	event message_t* Receive.receive(message_t* msg, void* pl, uint8_t len) {
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
	}
	
	event void AMSend.sendDone(message_t* msg, error_t error) {
		if(msg == &packet){
			call Leds.led0Off();
			busy = FALSE;
		}
	}
	
	event void RadioControl.startDone( error_t error ) {
		// do nothing
	}
	
	event void RadioControl.stopDone( error_t error ) {
		// do nothing
	}
	
	event void SerialControl.startDone( error_t error ) {
		// do nothing
	}
	
	event void SerialControl.stopDone( error_t error ) {
		// do nothing
	}
}
