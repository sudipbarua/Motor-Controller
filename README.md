# Motor-Controller
## Description:
In this project a DC motor controller was developed that generates PWM signal from a given digital serial data as input. The complete design is divided into two major components. 
* Design of a PWM Generator (Digital part) using VHDL
* Implementation of motor-controller [TI DRV 8837](https://www.ti.com/product/DRV8837) using VHDL-AMS (Analog part)

## [PWM Generator](https://github.com/sudipbarua/Motor-Controller/tree/master/PWM_Generator): 

The PWM Generator is divided into further three components.
* [Serial Paraller Interface](https://github.com/sudipbarua/Motor-Controller/tree/master/PWM_Generator/Serial-Parallel-Interface)
* [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/tree/master/PWM_Generator/PWM-Controller)
* [Signal Generator](https://github.com/sudipbarua/Motor-Controller/tree/master/PWM_Generator/Signal-Generator)

![Block Diagram of PWM Generator](https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM_Generator.JPG)

          Fig: Block diagram of PWM Generator.

###  [Serial Paraller Interface]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/Serial-Parallel-Interface/spi.vhd):
This component takes serial data and converts it into parallel data, from which the last 2bits are transferred as the register number (reg_nr), the 14th bit is register write enable (regwrite_n) and the 1st 14 bits are used as regcontent signal that is used to calculate the base period and duty cycle in the [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd) component. 

A state machine is used to design for starting new cycle, fetching data, write to output and end spi operation states which is clocked by the main system clock. Another clock for SPI fetch/read operation was used which is synchronous with the main clock. To check the functionality, a [Testbench](https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/Serial-Parallel-Interface/tb_spi.vhd) is also implemented. 
### [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd): 
In this component, the regcontent bit stream received from SPI is converted into Base period and Duty cycle values of the PWM output signal when the reg_nr value is 01 and 10 respectively. Additionally, it generates a control signal for motor-drive from regcontent when the value of reg_nr is 11. The testbench of this component can be found [here](https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/tb_pwm_controller.vhd). 
### [Signal Generator](https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/Signal-Generator/pwm_driver_v2-with-case.vhd): 
This component, named PWM-Driver in the diagram, has 3 outputs. 
1.	*pwm_out1*: Drives the motor to forward direction. If the 2nd bit of the control signal from [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd) is ‘0’, forward operation is active. 
2.	*pwm_out2*: Drives the motor to reverse direction. If the 2nd bit of the control signal from [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd) is ‘1’, reverse operation is active.
3.	*pwm_n_sleep*: ‘1’ when the 3rd bit of the control signal from [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd) is ‘1’. Defines the brake operation. 

The testbench is given [here](https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/Signal-Generator/tb_pwm_driver.vhd).

Finally all the 3 digital components are integrated in a [Top Level Design ](https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/pwm_digital_top.vhd) that takes serial data as input and generates PWM signal. The funtionality of the digital top level design is given [here](https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/tb_pwm_digital_top.vhd)

## [Motor Driver](https://github.com/sudipbarua/Motor-Controller/blob/master/Analog-Driver_TI-DRV-8837/motordriver.vhd) [TI DRV 8837](https://www.ti.com/product/DRV8837): 

Here a simple implementation of DRV 8837 is done.

![Block Diagram of DRV 8837](https://www.ti.com/ds_dgm/images/fbd_slvsba4e.gif)

          Fig: DRV8837 block diagram.

* A [switchable resistor]( https://github.com/sudipbarua/Motor-Controller/blob/master/Analog-Driver_TI-DRV-8837/sw_resistor.vhd) is used as the MOSFETs. 
* Parameters of the simple [diodes]( https://github.com/sudipbarua/Motor-Controller/blob/master/Analog-Driver_TI-DRV-8837/diode.vhd) as are: 
    
    * Thermal voltage 25 mV
    * Saturation current 1 nA
    * Ideality factor 1.1 

The switching logics are as follows-

| nSLEEP | IN1 | IN2 | Out1 | Out2 | Function |
|--------|-----|-----|------|------|----------|
|    0   |  X  |  X  |   Z  |  Z   |  Coast   |
|    1   |  0  |  0  |   Z  |  Z   |  Coast   |
|    1   |  1  |  0  |   H  |  L   | Forward  |
|    1   |  0  |  1  |   L  |  H   | Reverse  |
|    1   |  1  |  1  |   L  |  L   |   Brake  |

Finally both the digital and analog parts were integrated into the [Top Level Design of the Motor Controller](https://github.com/sudipbarua/Motor-Controller/blob/master/Top_Level_Design_motorcontroller.vhd) and simulated using [Testbench of the top level design](https://github.com/sudipbarua/Motor-Controller/blob/master/tb_Top_Level_Design_motorcontroller.vhd). 
