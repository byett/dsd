# Lab 1: Seven-Segment Decoder

* Built a single-digit (4-bit) hex counter to display its value on eight-digit common anode seven-segment LED displays (See Section 9.1 Seven-Segment Display of the [Reference Manual]( https://reference.digilentinc.com/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf))

![a7.png](a7.png)

![7s.png](7s.png)

* A '0' on the cathode turns a segment on

| Four-Bit Input | Hex Digit | LED Segment Code CA-CG |
| :---: | :---: | :---: |
| 0000 | 0 | 0000001 |
| 0001 | 1 | 1001111 |
| 0010 | 2 | 0010010 |
| 0011 | 3 | 0000110 |
| 0100 | 4 | 1001100 |
| 0101 | 5 | 0100100 |
| 0110 | 6 | 0100000 |
| 0111 | 7 | 0001111 |
| 1000 | 8 | 0000000 |
| 1001 | 9 | 0000100 |
| 1010 | A | 0001000 |
| 1011 | b | 1100000 |
| 1100 | C | 0110001 |
| 1101 | d | 1000010 |
| 1110 | E | 0110000 |
| 1111 | F | 0111000 |

## Project 1 - LED Decoder

### 1. Create a new RTL project called _leddec_ in Vivado Quick Start

* Vivado > Quick Start > Create Project > Create a New Vivado Project > Next

* Project name > **_leddec_**

  * Project location > C:/Users/... > Next

* RTL Project > Next

* Add Sources > Target language > VHDL > Simulator language > VHDL > Create File > Create a new source file of file type VHDL called _**leddec**_ > Next

* Add Constraints > Create File > Create a new constraint file of file type XDC called **_leddec_** > Next

* Default Part > Boards > Vendor: digilentinc.com > Name: Nexys A7-100T (Part: xc7a100tcsg324-1) > Click to highlight Nexys A7-100T > Next

* New Project Summary > Finish

* Define Module > OK > Yes

* Sources > Design Sources > Right click to open, copy, and paste leddec.vhd from the GitHub Raw > Save File

* Sources > Constraints > Right click to open, copy, and paste leddec.xdc from the GitHub Raw > Save File

* As an alternative, you can instead download files from Github and import them into your project when creating the project. The source file or files would still be imported during the Source step, and the constraint file or files would still be imported during the Constraints step.

### 2. Run synthesis

### 3. Run implementation 

### 3b. (optional, generally not recommended as it is difficult to extract information from and can cause Vivado shutdown) Open implemented design

### 4. Generate bitstream, open hardware manager, and program device

* Click 'Generate Bitstream'

* Connect the Nexys A7-100T board to the computer and switch the power ON

* Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'

* Click 'Program Device' then xc7a100t_0 to download leddec.runs/impl_1/leddec.bit to the Nexys A7-100T board

* Note: as you make modifications to the code, you may be prompted to re-do this process (synthesis, implementation, and bitstream). You DO have to do this for your new code to take effect.

### 5. Slide switches on the Nexys A7-100T board

* Slide switches 13, 14, and 15 to determine which display is illuminated (see [modifications](/Modifications))

* Slide switches 0, 1, 2, and 3 to display the value of 4-bit hex digit from 0 to F

* Slide only one switch at a time to display the [Gray code](https://en.wikipedia.org/wiki/Gray_code) from 0 to F, i.e., 0-1-3-2-6-7-5-4-C-d-F-E-A-b-9-8

### 6. Close project (only once completely done with testing)

* File > Close Project

## Project 2 - Hex Counter

* Build a 4-bit counter to display a hex character

![cnt.png](cnt.png)

* The counter module builds a 29-bit binary counter cnt clocked by the input clk
* Bits 25 to 28 generate a 4-bit value count used to drive the LED decoder
* For the input clock running at 100 MHz, the value of count changes at a frequency of 100 MHz / 2<sup>25</sup> ≈ 2.98 Hz with a complete cylce taking approximately 16 / 2.98 ≈ 5.37 seconds

### 1. Create a new project called _hexcount_ in Vivado

* Vivado > Quick Start > Create Project > Create a New Vivado Project > Next

* Project name > **_hexcount_**

  * Project location > C:/Users/... > Next

* RTL Project > Next

* Add Sources > Target language > VHDL > Simulator language > VHDL > Create File > Create three new source files of file type VHDL called _**leddec**_, **_counter_**, and **_hexcount_** > Next

* Add Constraints > Create File > Create a new constraint file of file type XDC called **_hexcount_** > Next

* Default Part > Boards > Vendor: digilentinc.com > Name: Nexys A7-100T > Click Nexys A7-100T > Next

* New Project Summary > Finish

* Define Module > OK > Yes

* Sources > Design Sources > Right click to open, copy, and paste leddec.vhd, counter.vhd, and hexcount.vhd from the GitHub Raw, and save files

* Sources > Constraints > Right click to open, copy, and paste hexcount.xdc from the GitHub Raw, and save file

* As an alternative, you can instead download files from Github and import them into your project when creating the project. The source file or files would still be imported during the Source step, and the constraint file or files would still be imported during the Constraints step.

### 2. Run synthesis

### 3. Run implementation

### 3b. (optional, generally not recommended as it is difficult to extract information from and can cause Vivado shutdown) Open implemented design

### 4. Generate bitstream, open hardware manager, and program device

* Click 'Generate Bitstream'

* Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'

* Click 'Program Device' then xc7a100t_0 to download hexconter.runs/impl_1/hexcount.bit to the Nexys A7-100T board

* The least significant 7-segment decoder counts cycles from 0 to F

* Note: as you make modifications to the code, you may be prompted to re-do this process (synthesis, implementation, and bitstream). You DO have to do this for your new code to take effect.

### 5. Work on and edit code with the following modifications (this will be your Lab 1 Extension/Submission!)

* Speed up OR slow down the rate at which different hex values appear on the board
* Some behavior of your choosing to change the location where the hex value appears on your board (rotating through all spots, bouncing back and forth between 2 spots, location controlled by 1 or more switches, etc.)
  * This is expected to be a "live" change (aka something that occurs as the program is running, not just an initial change to the code that changes the location only at the start of the program) 

### 6. Close project (only once completely done with testing)

* File > Close Project
