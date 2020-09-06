-----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.ELECTRICAL_SYSTEMS.ALL;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;

ENTITY tb_motordriver IS

END ENTITY;

ARCHITECTURE testbench of tb_motordriver IS

COMPONENT motor_driver_E IS
  GENERIC (
  Iss : real := 1.0e-9; 
  VT : real := 25.0e-3; 
  N : real := 1.1;
  resistance_on : real := 0.01;
  resistance_off : real := 10.0e6
  );
  
  PORT (
    TERMINAL Out1, Out2, GROUND, VM, VCC : ELECTRICAL;
    SIGNAL IN1, IN2, nSLEEP : std_logic);
END COMPONENT;

COMPONENT motor_model_E IS
  PORT (
    TERMINAL Pin1, Pin2 : ELECTRICAL;
    Quantity motor_rpm: out real);
END COMPONENT;

  TERMINAL Pin1, Pin2, VM, VCC : ELECTRICAL;
  QUANTITY motor_pwm_Q1, motor_pwm_Q2 : real;
  QUANTITY Volt_motor1 ACROSS I_motor1 THROUGH VM;
  Quantity Volt_digital ACROSS I_digital THROUGH VCC;

  SIGNAL in1_S, in2_S, nSleep_S : std_logic:='0';--'Z';

  
BEGIN  

  dut : motor_driver_E
  PORT MAP (Out1 => Pin1, Out2 => Pin2, GROUND => ELECTRICAL_REF, VM => VM, VCC => VCC, In1=>in1_S, In2 => in2_S, nSleep => nSleep_S);

  load1 : ENTITY work.motor_model_E(simple) 
  PORT MAP (Pin1, ELECTRICAL_REF, motor_pwm_Q1);  

  load2 : ENTITY work.motor_model_E(simple) 
  PORT MAP (Pin2, ELECTRICAL_REF, motor_pwm_Q2);  

  Volt_digital == 5.0;
  Volt_motor1 == 9.0;

  nSleep_S <= '1' after 1 ms; -- activate chip

  ctrl1_P: PROCESS
  BEGIN
-- first simple testcase
    wait for 300.0 us;
    in1_S <= '1';    -- forward1, coast2
    in2_S <= '0';
    wait for 600.0 us;
    in1_S <= '0';    -- coast1, forward2
    in2_S <= '1';
    wait for 300.0 us;
    in1_S <= '1';    -- coast1, coast2
    in2_S <= '1';
    wait for 300.0 us;
    in1_S <= '0';    -- coast1, coast2
    in2_S <= '0';
   END PROCESS;
  
END testbench;