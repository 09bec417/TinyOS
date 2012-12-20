package Displayer;
import java.util.*;
import java.io.*;
public class Message {
    public Message(String ss) {
	s = ss;
    }
    public String getNodeid() {
	return s.substring(16, 20);
    }
    public String getTemperature() {
	return s.substring(20, 24);
    }
    public String getHumidity() {
	return s.substring(24, 28);
    }
    public String getLight() {
	return s.substring(28, 32);
    }
    public String getFlag() {
	return s.substring(32, 36);
    }
    public String toString() {
	return "Nodeid = " + getNodeid() + " Temperature = " + getTemperature() + " Humidity = " + getHumidity() + " Light = " +  getLight() + " flags = " + getFlag() + "\n";
    }
    String s;
}

