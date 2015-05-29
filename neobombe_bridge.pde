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
Serial myPort_1; 

String portname_1 = "";
boolean is_motors_on;

void setup() {
    size(400, 400);
    
    frameRate(5);
    
    oscP5 = new OscP5(this, 7770);

    for (int i=0; i<Serial.list ().length; i++) {
        String this_portname = Serial.list()[i];
        //println(this_portname);
        if (this_portname.contains("cu.usbmodem")) { //for MACOSX
            portname_1 = this_portname;
        }
//        portname = "COM29"; //for Windows
//        portname = Serial.list()[0]; //default
    }

    myPort_1 = new Serial(this, portname_1, 9600);
    println("portname: " + portname_1);
}


void draw() {
    background(0);
    
    if (is_motors_on == true) {
            myPort_1.write(1);
    } else {
            myPort_1.write(0);
    }
}

float firstValue, secondValue;

void oscEvent(OscMessage theOscMessage) {
//     String addrPattern = theOscMessage.addrPattern();
//     print(" addrpattern: " + addrPattern);
//      print(" typetag: "+theOscMessage.typetag());
     firstValue = theOscMessage.get(0).floatValue();
     //print(" 1st: " + firstValue);
     secondValue = theOscMessage.get(1).floatValue();
     print(" 2nd:" + secondValue);
    
    if (secondValue > 0) {
            is_motors_on = true;
            
    } else {
            is_motors_on = false;
    }
    print(" frameCount: " + frameCount);
    println(" is_motors_on: " + is_motors_on);
}

void keyPressed() {
         if (key == ESC) {
                 stop();
                 exit();
         }       
}

void stop() {
        oscP5.stop();
        oscP5 = null;
        super.stop();
}
