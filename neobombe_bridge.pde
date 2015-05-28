/**
 Author: Benjamin Low (Lthben@gmail.com)
 Date: May 2015
 Description: A bridge program that listens at localhost 7770 for 108 rotor speeds. This 
 reads data from Jacky's simulation program downloaded at https://github.com/jackyb/neobombe-sim
 This bridge program processes the data and then sends out the processed output via
 Serial to the Arduino which controls the steppers. Only the top 3 rows are used from the
 simulation. 
 */

import oscP5.*;
import netP5.*;
import processing.serial.*;

OscP5 oscP5; 
Serial myPort;



void setup() {
    size(400, 400);
    oscP5 = new OscP5(this, 7770);

    String portname = "";

    for (int i=0; i<Serial.list ().length; i++) {
        String this_portname = Serial.list()[i];
        println(this_portname);
        if (this_portname.contains("cu.usbmodem")) { //for MACOSX
            portname = this_portname;
        }
        portname = "COM29"; //for Windows
    }

    myPort = new Serial(this, portname, 9600);
    println("portname: " + portname);
}


void draw() {
    background(0);
}

float rotSpeed_1, rotSpeed_2, rotSpeed_3;


void oscEvent(OscMessage theOscMessage) {
    // String addrPattern = theOscMessage.addrPattern();
    // print(" addrpattern: " + addrPattern);
    //  println(" typetag: "+theOscMessage.typetag());
    // float rotorSpeed = theOscMessage.get(1).floatValue();
    // println(" speed: " + rotorSpeed);
    println("decrypting... ...");
    myPort.write(1);
}
