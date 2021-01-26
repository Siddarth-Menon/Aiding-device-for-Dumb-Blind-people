# Aiding-device-for-Dumb-Blind-people

## Software / Apps used

1. Code Vision AVR
2. AVR studio
3. Realterm (For testing)
4. ASL Application
5. Serial Bluetooth Terminal

## Hardware used

1. ATMEGA-32 Microcontroller
2. Two ADXL-335 3-axis modules (Accelerometer sensor)
3. Dual Motor driver module
4. Two Vibration motors
5. HC05 Bluetooth Tranceiver Module

## Working

This device works using UART protocols and also uses the concept of interrupts to switch between modes with the help of the inbuilt push button of the microcontroller.

**1. Dumb People Aider Mode**

- This mode is enabled when the push button of the microcontroller is pressed once. 
- Here the dumb person holds one sensor in each hand and depending on the patterns made by the orientation combinations (3-dimensional) of the 2 sensors, the corresponding data is sent to the microcontrollor in the form of analog signals.
- The microcontroller then converts the analog signals to digital signals using its inbuilt Analog-to-Digital converter.
- Now this digital data is compared with the data stored in its memory and the corresponding word or message based on a set of rules (refer code for this) is sent to the bluetooth module. 
- The bluetooth module then sends this message to the paired phone, the ASL application reads the message and speaks out this message with the help of its inbuilt text to speech converter. 
- Now any person can understand what the dumb person is trying to convey even if they don't understand sign language.

NOTE: This mode is not based on American sign Language (ASL), we are just using an android ASL application which is available on apk sites. The sign language rules are defined by us and it can be changed by just modifying the code depending on users wish.

**2. Blind people Aider Mode**

- This mode is enabled when the push button of the microcontroller is pressed twice.
- Here the blind person hold one vibrator in each hand.
- Now the person who wants to convey his/her message sends it with the help of the bluetooth terminal app which is installed on his/her phone. (The phone should be paired to the bluetooth module for this step to work).
- The bluetooth module then receives the data and transmits this data to the microcontroller.
- The microocontroller then activates the vibration motors via the motor driver circuit board and depending on the letter in the english alphabet, a correspnding vibration pattern is made.
- The blind person feels this vibration and based on the set of rules (refer code for this) he/she understands the message being conveyed.

NOTE: Here the rules are defined by us, but it can be changed by just modifying the code depending on the user's wish.

## Application

This device can be used in schools, hospitals & homes so that teachers, doctors & family members respectively understand what a dumb or blind person is trying to say or vice versa.

