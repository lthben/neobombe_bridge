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

boolean is_motors_on, prev_motors_state;

//USER SETTINGS
boolean is_debug_mode = false; //set the debug mode here
String portname_1 = "/dev/cu.usbmodem1411"; //set the portnames here

void setup() {
        size(400, 400);

        frameRate(5);

        oscP5 = new OscP5(this, 7770);

        for (int i=0; i<Serial.list ().length; i++) {
                String this_portname = Serial.list()[i];
                println(this_portname);
        }

        myPort_1 = new Serial(this, portname_1, 9600);
        println("\nportname 1: " + portname_1);
        println("debug mode: " + is_debug_mode);
}


void draw() {
        background(0);

        if (is_motors_on != prev_motors_state) {
                if (is_motors_on == true) {
                myPort_1.write('A');
                } else {
                myPort_1.write('B');
                }
        }
        prev_motors_state = is_motors_on;
}

float motorNum, motorSpeed;

void oscEvent(OscMessage theOscMessage) {
        //     String addrPattern = theOscMessage.addrPattern();
        //     print(" addrpattern: " + addrPattern);
        //      print(" typetag: "+theOscMessage.typetag());
        motorNum = theOscMessage.get(0).floatValue();
        //print(" motor num: " + motorNum);
        motorSpeed = theOscMessage.get(1).floatValue();

        if (is_debug_mode == false) {
                if (motorSpeed > 0) {
                        is_motors_on = true;
                } else {
                        is_motors_on = false;
                }
        }

        if (is_debug_mode == true) {
                 print(" speed: " + motorSpeed);
            print("\t frameCount: " + frameCount);
            println("\t is_motors_on: " + is_motors_on);
        }
}

void keyPressed() {
        if (key == ESC) {
                stop();
                exit();
        }   

        if (is_debug_mode == true) {
                if (key == '1') {
                        is_motors_on = !is_motors_on;
                }
        }
}

void stop() {
        oscP5.stop();
        oscP5 = null;
        super.stop();
}

