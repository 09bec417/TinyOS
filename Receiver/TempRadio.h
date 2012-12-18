#ifndef TEMPERATURE_MSG_H
#define TEMPERATURE_MSG_H

typedef nx_struct temperature_msg {
	nx_uint16_t temperature;
} temperature_msg_t;

enum { AM_TEMPERATURE_MSG };

#endif
