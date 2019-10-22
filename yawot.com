
//yawot.com
//enjoy our free solutions

// Load Wi-Fi library
#include <ESP8266WiFi.h>

// Replace with your network credentials
const char* ssid     = "xxxxxx";
const char* password = "xxxxxx";

// Set web server port number to 80
WiFiServer server(80);

// Variable to store the HTTP request
String header;

// Auxiliar variables to store the current output state
String output5State = "off";
String output4State = "off";
String output3State = "off";



String output2State = "off";
String output1State = "off";
String output0State = "off";
String output6State = "off";
String output7State = "off";
String output8State = "off";
String output9State = "off";
String output10State = "off";


// Assign output variables to GPIO pins
const int output5 = 14;
const int output4 = 12;
const int output3 = 13;

const int output2 = 15;
const int output1 = 2;
const int output0 = 0;
const int output6 = 4;
const int output7 = 5;
const int output8 = 16;
const int output9 = 1;
const int output10 = 3;


// Current time
unsigned long currentTime = millis();
// Previous time
unsigned long previousTime = 0; 
// Define timeout time in milliseconds (example: 2000ms = 2s)
const long timeoutTime = 2000;

void setup() {
  Serial.begin(115200);
  // Initialize the output variables as outputs
  pinMode(output5, OUTPUT);
  pinMode(output4, OUTPUT);
    pinMode(output3, OUTPUT);

pinMode(output2, OUTPUT);
  pinMode(output1, OUTPUT);
  //  pinMode(output0, OUTPUT);
    pinMode(output6, OUTPUT);
  pinMode(output7, OUTPUT);
    pinMode(output8, OUTPUT);
    pinMode(output9, OUTPUT);
  pinMode(output10, OUTPUT);
  


    
  // Set outputs to LOW
  digitalWrite(output5, LOW);
  digitalWrite(output4, LOW);
  digitalWrite(output3, LOW);


     digitalWrite(output2, LOW);
  digitalWrite(output1, LOW);
    digitalWrite(output0, LOW);
  digitalWrite(output6, LOW);
    digitalWrite(output7, LOW);
  digitalWrite(output8, LOW);
    digitalWrite(output9, LOW);
  digitalWrite(output10, LOW);
  
  // Connect to Wi-Fi network with SSID and password
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  // Print local IP address and start web server
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  server.begin();
}

void loop(){
  WiFiClient client = server.available();   // Listen for incoming clients

  if (client) {                             // If a new client connects,
    Serial.println("New Client.");          // print a message out in the serial port
    String currentLine = "";                // make a String to hold incoming data from the client
    currentTime = millis();
    previousTime = currentTime;
    while (client.connected() && currentTime - previousTime <= timeoutTime) { // loop while the client's connected
      currentTime = millis();         
      if (client.available()) {             // if there's bytes to read from the client,
        char c = client.read();             // read a byte, then
        Serial.write(c);                    // print it out the serial monitor
        header += c;
        if (c == '\n') {                    // if the byte is a newline character
          // if the current line is blank, you got two newline characters in a row.
          // that's the end of the client HTTP request, so send a response:
          if (currentLine.length() == 0) {
            // HTTP headers always start with a response code (e.g. HTTP/1.1 200 OK)
            // and a content-type so the client knows what's coming, then a blank line:
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println("Connection: close");
            client.println();
             // it is OK for multiple small client.print/write,
  

            // turns the GPIOs on and off
            if (header.indexOf("GET /5/on") >= 0) {
              Serial.println("D5 on");
              output5State = "on";
              digitalWrite(output5, HIGH);
            } else if (header.indexOf("GET /5/off") >= 0) {
              Serial.println("D5 off");
              output5State = "off";
              digitalWrite(output5, LOW);
            } else if (header.indexOf("GET /4/on") >= 0) {
              Serial.println("D6 on");
              output4State = "on";
              digitalWrite(output4, HIGH);
            } else if (header.indexOf("GET /4/off") >= 0) {
              Serial.println("D6 off");
              output4State = "off";
              digitalWrite(output4, LOW);


              } else if (header.indexOf("GET /3/on") >= 0) {
              Serial.println("D7 on");
              output3State = "on";
              digitalWrite(output3, HIGH);
            } else if (header.indexOf("GET /3/off") >= 0) {
              Serial.println("D7 off");
              output3State = "off";
              digitalWrite(output3, LOW);
         



  } else if (header.indexOf("GET /2/on") >= 0) {
              Serial.println("D10 on");
              output2State = "on";
              digitalWrite(output2, HIGH);
            } else if (header.indexOf("GET /2/off") >= 0) {
              Serial.println("D10 off");
              output2State = "off";
              digitalWrite(output2, LOW);

              } else if (header.indexOf("GET /1/on") >= 0) {
              Serial.println("D9 on");
              output1State = "on";
              digitalWrite(output1, HIGH);
            } else if (header.indexOf("GET /1/off") >= 0) {
              Serial.println("D9 off");
              output1State = "off";
              digitalWrite(output1, LOW);

                 } else if (header.indexOf("GET /0/on") >= 0) {
              Serial.println("D8 on");
              output0State = "on";
              digitalWrite(output0, HIGH);
            } else if (header.indexOf("GET /0/off") >= 0) {
              Serial.println("D8 off");
              output0State = "off";
              digitalWrite(output0, LOW);
            

  } else if (header.indexOf("GET /6/on") >= 0) {
              Serial.println("D14 on");
              output6State = "on";
              digitalWrite(output6, HIGH);
            } else if (header.indexOf("GET /6/off") >= 0) {
              Serial.println("D14 off");
              output6State = "off";
              digitalWrite(output6, LOW);
            
   } else if (header.indexOf("GET /7/on") >= 0) {
              Serial.println("D15 on");
              output7State = "on";
              digitalWrite(output7, HIGH);
            } else if (header.indexOf("GET /7/off") >= 0) {
              Serial.println("D15 off");
              output7State = "off";
              digitalWrite(output7, LOW);
  } else if (header.indexOf("GET /8/on") >= 0) {
              Serial.println("D2 on");
              output8State = "on";
              digitalWrite(output8, HIGH);
            } else if (header.indexOf("GET /8/off") >= 0) {
              Serial.println("D2 off");
              output8State = "off";
              digitalWrite(output8, LOW);

  } else if (header.indexOf("GET /9/on") >= 0) {
              Serial.println("D1 on");
              output9State = "on";
              digitalWrite(output9, HIGH);
            } else if (header.indexOf("GET /9/off") >= 0) {
              Serial.println("D1 off");
              output9State = "off";
              digitalWrite(output9, LOW);

  } else if (header.indexOf("GET /10/on") >= 0) {
              Serial.println("D0 on");
              output10State = "on";
              digitalWrite(output10, HIGH);
            } else if (header.indexOf("GET /10/off") >= 0) {
              Serial.println("D0 off");
              output10State = "off";
              digitalWrite(output10, LOW);

            }













            
            // Display the HTML web page
            client.println("<!DOCTYPE html><html>");
            client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
            client.println("<link rel=\"icon\" href=\"data:,\">");
            // CSS to style the on/off buttons 
            // Feel free to change the background-color and font-size attributes to fit your preferences
            client.println("<style>html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center;}");
            client.println(".button { background-color: #195B6A; border: none; color: white; padding: 16px 40px;");
            client.println("text-decoration: none; font-size: 30px; margin: 2px; cursor: pointer;}");
            client.println(".button2 {background-color: #00878A;}</style></head>");
            
            // Web Page Heading
            client.println("<body><h1>ESP8266 Web Server</h1>");
            
            // Display current state, and ON/OFF buttons for GPIO 5  
            client.println("<p>D5 - State " + output5State + "</p>");
            // If the output5State is off, it displays the ON button       
            if (output5State=="off") {
              client.println("<p><a href=\"/5/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/5/off\"><button class=\"button button2\">OFF</button></a></p>");
            } 
               
           client.println("<p>D6 - State " + output3State + "</p>");
            // If the output4State is off, it displays the ON button       
            if (output4State=="off") {
              client.println("<p><a href=\"/4/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/4/off\"><button class=\"button button2\">OFF</button></a></p>");
            }

 client.println("<p>D7 - State " + output3State + "</p>");
            // If the output3State is off, it displays the ON button       
            if (output3State=="off") {
              client.println("<p><a href=\"/3/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/3/off\"><button class=\"button button2\">OFF</button></a></p>");
            }


 client.println("<p>D10 - State " + output2State + "</p>");
            // If the output2State is off, it displays the ON button       
            if (output2State=="off") {
              client.println("<p><a href=\"/2/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/2/off\"><button class=\"button button2\">OFF</button></a></p>");
            }

 client.println("<p>D9 - State " + output1State + "</p>");
            // If the output1State is off, it displays the ON button       
            if (output1State=="off") {
              client.println("<br><p><a href=\"/1/on\"><button class=\"button\">ON</button></a></p><br/>");
            } else {
              client.println("<br><p><a href=\"/1/off\"><button class=\"button button2\">OFF</button></a></p><br/>");
            }


 client.println("<p>D8 - State " + output0State + "</p>");
            // If the output0State is off, it displays the ON button       
            if (output0State=="off") {
              client.println("<p><a href=\"/0/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/0/off\"><button class=\"button button2\">OFF</button></a></p>");
            }

 client.println("<p>D14- State " + output6State + "</p>");
            // If the output6State is off, it displays the ON button       
            if (output6State=="off") {
              client.println("<p><a href=\"/6/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/6/off\"><button class=\"button button2\">OFF</button></a></p>");
            }
 
 client.println("<p>D15 - State " + output7State + "</p>");
            // If the output7State is off, it displays the ON button       
            if (output7State=="off") {
              client.println("<p><a href=\"/7/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/7/off\"><button class=\"button button2\">OFF</button></a></p>");
            }
 client.println("<p>D2 - State " + output8State + "</p>");
            // If the output8State is off, it displays the ON button       
            if (output8State=="off") {
              client.println("<p><a href=\"/8/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/8/off\"><button class=\"button button2\">OFF</button></a></p>");
            }
 client.println("<p>D1 - State " + output9State + "</p>");
            // If the output9State is off, it displays the ON button       
            if (output9State=="off") {
              client.println("<p><a href=\"/9/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/9/off\"><button class=\"button button2\">OFF</button></a></p>");
            }







 client.println("<p>D0 - State " + output10State + "</p>");
            // If the outpu7State is off, it displays the ON button       
            if (output10State=="off") {
              client.println("<p><a href=\"/10/on\"><button class=\"button\">ON</button></a></p>");
            } else {
              client.println("<p><a href=\"/10/off\"><button class=\"button button2\">OFF</button></a></p>");
            }
            client.println("</body></html>");
            
            // The HTTP response ends with another blank line
            client.println();
            // Break out of the while loop
            break;
          } else { // if you got a newline, then clear currentLine
            currentLine = "";
          }
        } else if (c != '\r') {  // if you got anything else but a carriage return character,
          currentLine += c;      // add it to the end of the currentLine
        }
      }
    }
    // Clear the header variable
    header = "";
    // Close the connection
    client.stop();
    Serial.println("Client disconnected.");
    Serial.println("");
    }
    }
    
