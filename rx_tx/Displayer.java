package Displayer;
import java.util.*;
import java.io.*;
public class Displayer {
    public Displayer() {
    }
    public static void skipLines(int kk) {
	//I found that this method turns out to be useless
	String s;
	try {
	    while (true && kk > 0) {
		s = br.readLine();
		if (s != null) {
		    System.out.println(s + "!");
		    kk--;
		}
	    }
	}catch (IOException e) {
	    
	}
    }
    public static void main(String[] args) {
        try {
            br = new BufferedReader(new InputStreamReader(System.in));
	    String s;
	    while (true) {
		s = br.readLine();
		if (s != null) {
		    System.out.println("raw data :" + s);
		    s = s.replaceAll(" ", "");
		    Message mes = new Message(s);
		    System.out.println(mes.toString());
		}
	    }
	}catch (IOException e) {
	    
	}
    }
    static BufferedReader br;
}



