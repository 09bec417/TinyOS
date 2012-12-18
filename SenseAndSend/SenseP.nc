#include <Timer.h>
#include "Message.h"

module SenseP
{
	uses{
		interface Boot;
		interface Leds;
		interface Timer<TMilli>;
		interface SplitControl as AMControl;
		interface Packet;
        interface AMSend;
        interface Read<uint16_t> as Temperature;
        interface Read<uint16_t> as Humidity;
        interface Read<uint16_t> as Light;
        
        
	}
}


implementation
{
    message_t pkt;
    bool busy = FALSE;
    uint16_t temperature;
    uint16_t humidity;
    uint16_t light;
    
    
	event void Boot.booted()
	{
        call AMControl.start();
	}

    event void AMControl.startDone(error_t error)
    {
        if(error == SUCCESS)
            call Timer.startPeriodic(SAMPLE_FREQUENCY);
        else
            call AMControl.start();
        

    }

    event void AMControl.stopDone(error_t error)
    {
    }
    
    
	event void Timer.fired()
	{
        call Temperature.read();
        call Humidity.read();
        call Light.read();
        if(!busy)
        {
            MyMessage* msg = (MyMessage*)(call Packet.getPayload(&pkt, NULL));
            msg -> nodeid = TOS_NODE_ID;
            msg -> temperature = temperature;
            msg -> humidity = humidity;
            msg -> light = light;
            
            if((call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(MyMessage))) == SUCCESS)
            {
                busy = TRUE;
            }
            
        }
        
        
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
    

    event void AMSend.sendDone(message_t* msg, error_t error)
    {
        if(&pkt == msg)
        {
            busy = FALSE;
            
            call Leds.led2Toggle();
            
        }
        
        

    }
    

}
