// Jose Carlo Doliner & Chris Collins
//Logic Devices Programming CET
// This is an ADC/Shift register code that takes an analog input in pin A0 and converts it to its digital equivalent
// This digital equivalent is then shifted bit by bit while setting appropriate clock signals for communication with
// the max ten board

int ADC_Val;
const int DIGITAL_OUT=9;
const int ENABLE=10;
const int sequence_clk=11;
void setup() {
  // put your setup code here, to run once:
pinMode(A0,INPUT);//ANALOG VOLTAGE INPUT
pinMode(DIGITAL_OUT,OUTPUT);//DIGITAL OUTPUT
pinMode(ENABLE,OUTPUT);//CLOCK enable
pinMode(sequence_clk,OUTPUT);
Serial.begin(9600); // Starts the Console serial communication
digitalWrite(ENABLE,LOW);
digitalWrite(DIGITAL_OUT,LOW);
digitalWrite(sequence_clk,LOW);
}

void loop() {
 //sets clock high for ADC conversion
 digitalWrite(ENABLE,HIGH);//sets ENABLE High
 ADC_Val=analogRead(A0); //Reads ADC Value
 Serial.println(ADC_Val);//prints ADC Value to Console
 //Reads each bit from the ADC (10-bits) for control in the MAX 10 Board
 delay(5);
 for (int i=0;i<10;i++){
 digitalWrite(sequence_clk,LOW);
 delay(5);
 digitalWrite(DIGITAL_OUT,bitRead(ADC_Val,i));
 Serial.println(bitRead(ADC_Val,i));
 delay(1);
 digitalWrite(sequence_clk,HIGH);
 delay(5); 
 }
 digitalWrite(DIGITAL_OUT,LOW);
 digitalWrite(sequence_clk,LOW);
 digitalWrite(ENABLE,LOW);//sets ENABLE LOW
 delay(10);
}