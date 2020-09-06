# Motor-Controller
## Description:
In this project a DC motor controller was developed that generates PWM signal from a given digital serial data as input. The complete design is divided into two major components. 
* Design of a PWM Generator (Digital part) using VHDL
* Implementation of motor-controller [TI DRV 8837](https://www.ti.com/product/DRV8837) using VHDL-AMS (Analog part)

## PWM Generator: 

The PWM Generator is divided into further three components.
* [Serial Paraller Interface](https://github.com/sudipbarua/Motor-Controller/tree/master/PWM_Generator/Serial-Parallel-Interface)
* [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/tree/master/PWM_Generator/PWM-Controller)
* [Signal Generator](https://github.com/sudipbarua/Motor-Controller/tree/master/PWM_Generator/Signal-Generator)

###  [Serial Paraller Interface]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/Serial-Parallel-Interface/spi.vhd):
This component takes serial data and converts it into parallel data, from which the last 2bits are transferred as the register number (reg_nr), the 14th bit is register write enable (regwrite_n) and the 1st 14 bits are used as regcontent signal that is used to calculate the base period and duty cycle in the [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd) component. 

A state machine is used to design for starting new cycle, fetching data, write to output and end spi operation states which is clocked by the main system clock. Another clock for SPI fetch/read operation was used which is synchronous with the main clock. 
### [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd): 
In this component, the regcontent bit stream received from SPI is converted into Base period and Duty cycle values of the PWM output signal when the reg_nr value is 01 and 10 respectively. Additionally, it generates a control signal for motor-drive from regcontent when the value of reg_nr is 11. 
### [Signal Generator](https://github.com/sudipbarua/Motor-Controller/tree/master/PWM_Generator/Signal-Generator): 
This component, named PWM-Driver in the diagram, has 3 outputs. 
1.	*pwm_out1*: Drives the motor to forward direction. If the 2nd bit of the control signal from [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd) is ‘0’, forward operation is active. 
2.	*pwm_out2*: Drives the motor to reverse direction. If the 2nd bit of the control signal from [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd) is ‘1’, reverse operation is active.
3.	*pwm_n_sleep*: ‘1’ when the 3rd bit of the control signal from [PWM-Controller]( https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/PWM-Controller/pwm_controller.vhd) is ‘1’. Defines the brake operation. 

Finally all the 3 digital components are integrated in a [Top Level Design ](https://github.com/sudipbarua/Motor-Controller/blob/master/PWM_Generator/pwm_digital_top.vhd) that takes serial data as input and generates PWM signal. 

