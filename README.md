# UART
#### Configurable UART Implementation

The UART Core 'UART_TOP' consists of 3 main components, RX, TX, and Baud Generator. 

### The Baud Generator 
The baud_gen is configurable. The characteristics can be changed in the package 'defs' such as "the working frequency, the values of baud rates).
It is asserted a 2-bits value selecting the required baud rate of the available 4 values and it generated it on the 'tick' output.

### Frame Configuration
* 1-bit 'd_num' signal specifying the length of the data which can be 7 bits (logic '0') or 8 bits (logic '1').   
* 1-bit 's_num' signal specifying the number of the end bits which can be 1 bit (logic '0') or 2 bits (logic '1').    
* 2-bits 'par' signal specifying the desired parity scheme, which can be odd parity (decimal '1'), or even parity (decimal '2'); otherwise, no parity.  

### Error Detection and Flags
All signals are active high.
* For TX:
  * 1-bit 'tx_active' indicating an in-transmitting process.
  * 1-bit 'tx_done' indicating a completed transmission of a frame
* For RX:
  * 1-bit 'rx_done' indicating a completed receiption of a frame.
  * 1-bit 'frame_error' detecting any error the received frame of bits.
  * 1-bit 'parity_error' detecting error concerning the parity.
