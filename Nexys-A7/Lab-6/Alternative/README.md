# Alternative Design 

## Using BTNL and BTNR instead of Pmod AD1 and potentiometer

* pong_2.vhd
  * Set bat position using buttons
  * Need leddec16.vhd (you were going to need this eventually regardless)
  * No need for adc_if.vhd, but should include other .vhd files outside of pong.vhd and pong.xdc from the main Lab-6 folder

* pong_2.xdc
  * Add ports btnl and btnr
