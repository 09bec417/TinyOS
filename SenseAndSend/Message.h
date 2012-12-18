#ifndef MESSAGE_H
#define MESSAGE_H

typedef nx_struct MyMessage
{
	nx_uint16_t nodeid;
	nx_uint16_t temperature;
	nx_uint16_t humidity;
	nx_uint16_t light;
} MyMessage;

enum{
    SAMPLE_FREQUENCY = 6000,
    AM_BLINKTORADIO = 6
};

#endif
