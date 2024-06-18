# Lab 2: Four-Digit Hex Counter

* Build a four-digit (16-bit) [counter](https://en.wikipedia.org/wiki/Counter_(digital)) to display its value on 7-segment displays (See Section 9.1 Seven-Segment Display of the [Refenece Manual](https://reference.digilentinc.com/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf))

![mpx.png](mpx.png)

![counter.png](counter.png)

![hexcount.png](hexcount.png)

* The counter module generates a 16-bit count value using bits 23 to 38 of the 39-bit binary counter at a frequency of 100 MHz / 2<sup>23</sup> ≈ 12 Hz with a complete cycle taking approximately 16<sup>4</sup> / 12 ≈ 5461 seconds or 91 minutes

* The binary counter bits 17 and 18 generate a 0 to 3 count sequence at a frequency of 100 MHz / 2<sup>17</sup> ≈ 763 Hz

* The sequence repeats at a frequency of approximately 763 Hz / 4  ≈ 191 Hz that is fast enough to eliminate any visual flicker in the displays.

* This multiplexing is fast enough (at least 60 complete cycles per second) to appear as if all four displays are continuously illuminated – each with their own four bits of information.

* The mpx output from the new counter module now drives the dig input of the leddec module.

* The mpx signal is also used to select which 4-bits of the 16-bit count output should be sent to the data input of the leddec module.

* By time multiplexing the 7-segment displays that share the same cathode lines (CA to CG), four different digits can appear on one display at a time.
  * Turn on display 0 for a few milliseconds by enabling its common anode AN0 and decoding count (0~3) to drive the cathode lines.
  * Switch to display 1 for a few milliseconds by turning off AN0, turning on AN1 and decoding count (4~7) to drive the cathode lines.
  * Shift to display 2 for a few milliseconds and then finally display 3 for a few milliseconds, after that go back and start again at display 0.
  * Each digit is thus illuminated only one quarter of the time

### 1. Create a new RTL project called _hex4count_ in Vivado Quick Start

* Click 'Create File' then create three new source files of file type VHDL called **_leddec_**, **_counter_**, and **_hexcount_**

* Create a new constraint file of file type XDC called **_hexcount_**

* Default Part > Boards > Vendor: digilentinc.com > Name: Nexys A7-100T > Click Nexys A7-100T > Next

* New Project Summary > Finish

* Click design sources, copy leddec.vhd, counter.vhd, and hexcount.vhd from the GitHub Raw, and save files

* Click constraints, copy hexcount.xdc from the GitHub Raw, and save file

* As an alternative, you can instead download files from Github and import them into your project when creating the project. The source file or files would still be imported during the Source step, and the constraint file or files would still be imported during the Constraints step.

### 2. Run synthesis

### 3. Run implementation

### 3b. (optional, generally not recommended as it is difficult to extract information from and can cause Vivado shutdown) Open implemented design

* Tools > Edit Device Properties > Configuration Modes > Check "Master SPI x1"

### 4. Generate bitstream, open hardware manager, and program device

* Click 'Generate Bitstream'

* Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'

* Click 'Program Device' then xc7a100t_0 to download hex4counter.runs/impl_1/hexcount.bit to the Nexys A7-100T board

* The four digit counter counts from 0000 to FFFF (see [Modifications](/Modifications) for an eight-digit counter)

* Note: as you make modifications to the code, you may be prompted to re-do this process (synthesis, implementation, and bitstream). You DO have to do this for your new code to take effect.

### 5. Generate and boot from configuration memory, and close project

* Move the blue MODE jumper on the board from [JTAG](https://en.wikipedia.org/wiki/JTAG) to QSPI (Quad-[SPI](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface))
  * [Reference Manual](https://reference.digilentinc.com/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf) Sections 2.1, 2.2, and 3.2
* Tools > Generate Memory Configuration File
  * Format: MCS
  * Select "Memory Part" > Click ... > Manufacturer > Spansion > Density (Mb) > 128 > s25fl128sxxxxxx0-spi-x1_x2_x4 > OK
  * Filename > Recent Directories > C:/Users/.../hex4count > name a new file hex4count.runs/impl_1/hexcount.mcs > Save
  * Interface: SPIx1
  * Check "Load bitstream files > Select C:/Users/.../hex4count/hex4count.runs/impl_1/hexcount.bit > OK
  * Check "Overwrite"
  * Generate momory configuration file completed successfully > OK

* Open Hardware Manager > Add Configuration Memory Device > xc7a100t_0
  * Filter > Manufacturer > Spansion > Density (Mb) > 128
  * Configuration Memory Part > s25fl128sxxxxxx0-spi-x1_x2_x4 > OK
  * Do you want to program the configuration memory device now? > OK
      * After doing this once, it will be grayed out and you should not try to do it again!

* Program Configuration Memory Device
  * Memory Device: s25fl128sxxxxxx0-spi-x1_x2_x4
  * Configuration file > Click ... > Select C:/Users/.../hex4counter.runs/impl_1/hexcount.mcs > OK
  * PRM file > Click ... > Select C:/Users/.../hex4counter.runs/impl_1/hexcount.prm > OK
      * When I got to this step, it would not allow me to select this PRM file. The rest of the process seemed to go correctly without this step, so for now if this happens to you just move on to the next step - Prof. Yett
  * Address Range > Click V > Select "Entire Configuration Memory Device" > OK
  * Flash programming completed successfully > OK

* Right click xc7a100t_0 under "Hardware" > Boot from Configuration Memory Device > The four digit counter starts

* File > Close Hardware Manager 

* File > Close Project 

* POWER OFF > POWER ON > Wait for 10 seconds > The counter starts

![hexcounter.gif](https://github.com/byett/dsd/blob/CPE487-Spring2024/Nexys-A7/Lab-2/hexcounter.gif)

* POWER OFF > Move the blue MODE jumper on the board from QSPI to JTAG
### The above is important so that you can successfully re-reprogram the board next time!

### 6. Work on and edit code with the following modifications (this will be your Lab 2 Extension/Submission!)

* Start from the FSM you designed as part of Simulation Activity 3.
* Incorporate the core code of your FSM into the code of Lab 2 in Vivado. This should be done in the "counter" file as it already incorporates a clock process (which you can modify to also perform the updating of the present state of your FSM) and as the direction of the counter can be reversed as part of this code. Choose one of the bits of the "cnt" (make sure to think through and choose a particular bit that changes somewhat frequently but not nearly instanteously!) signal as the "input" to your FSM. The output of your FSM should modify the direction of the counter (so for example, when your output becomes 1, your counter switches from counting up to counting down or vice versa).
  * This does require some reconfiguring of your FSM. The output needs to be remembered in some way instead of just switching between 0's and 1's each state. I would recommend incorporating this memory into the process responsible for the clock and present state updating.
* A short answer on your thoughts as to why we have the "only flip between 0 and 1 one time" requirement and what might happen if we did not have that requirement.
* Other specifics of this intentionally left open-ended to allow for different approaches, but ask questions if you are unsure about these instructions or anything left unsaid!

