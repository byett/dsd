# Lab 6: Video Game PONG

* Extend the FPGA code developed in Lab 3 (Bouncing Ball) to build a PONG game
  * The Digilent Nexys A7-100T board has a female [VGA connector](https://en.wikipedia.org/wiki/VGA_connector) that can be connected to a VGA monitor via a VGA cable or a [High-Definition Multimedia Interface](https://en.wikipedia.org/wiki/HDMI) (HDMI) monitor via a [VGA-to-HDMI converter](https://www.ventioncable.com/product/vga-to-hdmi-converter/) with a [micro-B USB](https://en.wikipedia.org/wiki/USB_hardware) power supply
  * 2019-11-15 pull request by Peter Ho with the 800x600@60Hz support for 100MHz clock
  * In 2020 Fall, [Zikang Sheng](https://github.com/karlsheng99/CPE487_dsd/tree/master/lab/lab%206) made an alternative design that used onboard BTNL and BTNR buttons to control the motion of the bat without Pmod AD1 and potentiometer. This is the default version for the current semester.


* The **_bat_n_ball_** module draws the bat and ball on the screen and also causes the ball to bounce (by reversing its speed) when it collides with the bat or one of the walls.
  * It also uses a variable game_on to indicate whether the ball is currently in play.
  * When game_on = ‘1’, the ball is visible and bounces off the bat and/or the top, left and right walls.
  * If the ball hits the bottom wall, game_on is set to ‘0’. When game_on = ‘0’, the ball is not visible and waits to be served.
  * When the serve input goes high, game_on is set to ‘1’ and the ball becomes visible again.

* The **_pong_** module is the top level.
  * BTN0 on the Nexys2 board is used to initiate a serve.
  * The process ckp is used to generate timing signals for the VGA and ADC modules.

### 1. Create a new RTL project _pong_ in Vivado Quick Start

* Create six new source files of file type VHDL called **_clk_wiz_0_**, **_clk_wiz_0_clk_wiz_**, **_vga_sync_**, **_bat_n_ball_**, **_leddec16_**, and **_pong_**

  * clk_wiz_0.vhd and clk_wiz_0_clk_wiz.vhd are the same files as in Lab 3. leddec16.vhd is the same file from Lab 5.
  
  * vga_sync.vhd, bat_n_ball.vhd, and pong.vhd are new files for Lab 6

* Create a new constraint file of file type XDC called **_pong_**

* Choose Nexys A7-100T board for the project

* Click 'Finish'

* Click design sources and copy the VHDL code from clk_wiz_0, clk_wiz_0_clk_wiz, vga_sync.vhd, bat_n_ball.vhd, leddec16.vhd, pong.vhd

* Click constraints and copy the code from pong.xdc

* As an alternative, you can instead download files from Github and import them into your project when creating the project. The source file or files would still be imported during the Source step, and the constraint file or files would still be imported during the Constraints step.

### 2. Run synthesis

### 3. Run implementation

### 3b. (optional, generally not recommended as it is difficult to extract information from and can cause Vivado shutdown) Open implemented design

### 4. Generate bitstream, open hardware manager, and program device

* Click 'Generate Bitstream'

* Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'

* Click 'Program Device' then xc7a100t_0 to download pong.bit to the Nexys A7-100T board

* Push BTNC to start the bouncing ball and use the bat to keep the ball in play

### 5. Work on and edit code with the following modifications (depending on when you do this, it will be your Fourth, Fifth, or Sixth Lab Extension/Submission!)

#### A) Change bat width and count hits

* Double the width of the bat to make the game really easy

* However, to counteract this, modify the code so that the bat width decreases one pixel after each time successfully hitting the ball

* The bat should reset to starting width when we miss the ball

* Count the number of successful hits after each serve and display the count in binary on the 7-segment displays of the Nexys A7-100T board. 

* (For testing and/or fun) See how many times you can hit the ball in a row as the bat slowly shrinks

* During your gameplay, you should notice that hits are often counted multiple times (as in your count increases by more than 1 per successful hit). Remedy this situation in your code as well

#### B) Change ball speed

* The ball speed is currently 6 pixels per video frame

* Use your "hits" counter from step A as a means to increase the speed in both the horizontal and vertical directions

* Make sure that you reset the speed back to 6 in each direction when a new game is started!

* (For testing and/or fun) See how many times you can hit the ball in a row as the ball increases in speed
