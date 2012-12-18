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
    public String toString() {
	return "Nodeid = " + getNodeid() + " Temperature = " + getTemperature();
    }
    String s;
}

