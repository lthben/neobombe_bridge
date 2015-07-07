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
Serial port_T1, port_T2, port_T3, port_T4, port_T5, port_T6, port_M1, port_M2, port_M3, port_B1, port_B2, port_B3;

boolean is_motors_on, prev_motors_state; //tracks on-off state of motors
boolean is_motors_on2, prev_motors_state2;

//set the portnames here
String portname_prefix = "/dev/cu.usbmodem";

String port_T1_num = "14112131";
String port_T2_num = "14112141";
String port_T3_num = "14112111";
String port_T4_num = "14141";
String port_T5_num = "14121";
String port_T6_num = "141141";
String port_M1_num = "1411221";
String port_M2_num = "1411231";
String port_M3_num = "141131";
String port_B1_num = "14112121";
String port_B2_num = "14131";

void setup() {
        size(400, 400);

        frameRate(5);

        oscP5 = new OscP5(this, 7770);

        for (int i=0; i<Serial.list ().length; i++) {
                String this_portname = Serial.list()[i];
                println(this_portname);
        }

        //        myPort_1 = new Serial(this, portname_1, 9600);
        //        println("\nportname 1: " + portname_1);
        port_T1 = new Serial(this, portname_prefix + port_T1_num, 9600); 
        port_T2 = new Serial(this, portname_prefix + port_T2_num, 9600); 
        port_T3 = new Serial(this, portname_prefix + port_T3_num, 9600); 
        port_T4 = new Serial(this, portname_prefix + port_T4_num, 9600); 
        port_T5 = new Serial(this, portname_prefix + port_T5_num, 9600); 
        port_T6 = new Serial(this, portname_prefix + port_T6_num, 9600); 
        port_M1 = new Serial(this, portname_prefix + port_M1_num, 9600); 
        port_M2 = new Serial(this, portname_prefix + port_M2_num, 9600); 
        port_M3 = new Serial(this, portname_prefix + port_M3_num, 9600); 
        port_B1 = new Serial(this, portname_prefix + port_B1_num, 9600); 
        port_B2 = new Serial(this, portname_prefix + port_B2_num, 9600); 

}


void draw() {
        background(0);

        if (is_motors_on != prev_motors_state) {
                if (is_motors_on == true) {
                        write_all_ports('A');
                } else {
                        write_all_ports('B');
                }
        }
        if (is_motors_on2 != prev_motors_state2) {
                if (is_motors_on2 == true) {
                        write_all_ports('A');
                } else {
                        write_all_ports('B');
                }
        }
        prev_motors_state = is_motors_on;
        prev_motors_state2 = is_motors_on2;
}

float motorAngle, motorSpeed;

void oscEvent(OscMessage theOscMessage) {
        String addrPattern = theOscMessage.addrPattern();    
        //              print(" typetag: "+theOscMessage.typetag());
        motorAngle = theOscMessage.get(0).floatValue();
        motorSpeed = theOscMessage.get(1).floatValue();

        if (addrPattern.equals("/rotor/9") && motorSpeed != 0.0) {
                print(addrPattern);
                print(" " + motorAngle);
                println(" " + motorSpeed);
        }

        if (motorSpeed > 0) {
                is_motors_on = true;
        } else {
                is_motors_on = false;
        }

        //            print("\t frameCount: " + frameCount);
        //            println("\t is_motors_on: " + is_motors_on);
}

void keyPressed() {
        if (key == ESC) {
                stop();
                exit();
        }   


        if (key == '1') {
                is_motors_on2 = !is_motors_on2;
                println("is motors on_2: " + is_motors_on2);
        }
}

void stop() {
        oscP5.stop();
        oscP5 = null;
        super.stop();
}

void write_all_ports(char the_byte) {
        port_T1.write(the_byte);
        port_T2.write(the_byte);
        port_T3.write(the_byte);
        port_T4.write(the_byte);
        port_T5.write(the_byte);
        port_T6.write(the_byte);
        port_M1.write(the_byte);
        port_M2.write(the_byte);
        port_M3.write(the_byte);
        port_B1.write(the_byte);
        port_B2.write(the_byte);
}

