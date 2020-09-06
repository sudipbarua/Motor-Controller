-- Model for DC motor https://matheplanet.de/default3.html?article=941

LIBRARY IEEE;
USE IEEE.ELECTRICAL_SYSTEMS.ALL;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;

ENTITY motor_model_E IS

  PORT (
    TERMINAL Pin1, Pin2 : ELECTRICAL;
    Quantity motor_rpm: out real);

END motor_model_E;

ARCHITECTURE simple OF motor_model_E IS
  QUANTITY Volt_in ACROSS I_in, I_parallel THROUGH Pin1 TO Pin2;
  CONSTANT motor_resistance : real := 10.0; 
  CONSTANT inductance_anchor : real := 0.001; -- in Henry
  CONSTANT parallel_capacitance : real := 1.0e-6; -- 1 uF parallel to motor to stabilize
  CONSTANT motor_factor : real := 1.0e2; -- conversion factor current -> rpm

BEGIN  
   volt_in == motor_resistance * I_in + inductance_anchor * I_in'dot;  
   I_parallel == parallel_capacitance * volt_in'dot;
  motor_rpm == i_in * motor_factor;

END simple;