/**
 * (./) udp.pde - how to use UDP library as unicast connection
 * (cc) 2006, Cousot stephane for The Atelier Hypermedia
 * (->) http://hypermedia.loeil.org/processing/
 *
 * Create a communication between Processing<->Pure Data @ http://puredata.info/
 * This program also requires to run a small program on Pd to exchange data  
 * (hum!!! for a complete experimentation), you can find the related Pd patch
 * at http://hypermedia.loeil.org/processing/udp.pd
 * 
 * -- note that all Pd input/output messages are completed with the characters 
 * ";\n". Don't refer to this notation for a normal use. --
 */

// import UDP library
import hypermedia.net.*;


UDP udp;  // define the UDP object

/**
 * init
 */
void setup() {
size(300, 300);
  // create a new datagram connection on port 6000
  // and wait for incomming message
  udp = new UDP( this, 6000 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

//process events
void draw() {;}

void mouseMoved() {
    String ip1      = "10.1.20.84";  // the remote IP address
    String ip2       = "10.1.20.172";  // the remote IP address
    int port        = 8888;    // the destination port
    
    // formats the message for Pd
    String message1 = round(map( mouseX,0,300,0,180))+"";
    String message2 = round(map( mouseX,0,300,180,0))+"";
    println(message1+ "  " +message2);
    // send the message
    udp.send( message1, ip1, port );
 udp.send( message2, ip2, port );

}
/**
 * To perform any action on datagram reception, you need to implement this 
 * handler in your code. This method will be automatically called by the UDP 
 * object each time he receive a nonnull message.
 * By default, this method have just one argument (the received message as 
 * byte[] array), but in addition, two arguments (representing in order the 
 * sender IP address and his port) can be set like below.
 */
// void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  
  
  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  String message = new String( data );
  
  // print the result
  println( "receive: \""+message+"\" from "+ip+" on port "+port );
}

