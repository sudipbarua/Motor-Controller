
-- Model for TI DRV8837 motor driver (Calliope)

LIBRARY IEEE;
USE IEEE.ELECTRICAL_SYSTEMS.ALL;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;

ENTITY motor_driver_E IS
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

END motor_driver_E;

-- ARCHITECTURE to be filled by the students

architecture behavior of motor_driver_E is

component sw_resistor_E 
  
  GENERIC (
    resistance_on : real := 0.01;
    resistance_off : real := 10.0e6);       

  PORT (
    TERMINAL a,b : ELECTRICAL;
	signal d : in std_logic);

END component;

component diode_E
  GENERIC (
  Iss : real := 1.0e-9; 
  VT : real := 25.0e-3; 
  N : real := 1.1);
  PORT (
    TERMINAL anode, cathode : ELECTRICAL);

END component;

signal sw_1, sw_2, sw_3, sw_4 : std_logic;

begin
--for output-1
	m1: sw_resistor_E
	GENERIC map (
	resistance_on => resistance_on, resistance_off => resistance_off)
	port map (
	a => VM, b=> Out1, d=>sw_1);
	
	m2: sw_resistor_E
	GENERIC map (
	resistance_on => resistance_on, resistance_off => resistance_off)
	port map (
	a => Out1, b=> GROUND, d=>sw_2); 
	
	d1: diode_E
	GENERIC map (
	Iss => Iss, VT => VT, N=>N)
	PORT map (
	anode => Out1, cathode => VM);
	
	d2: diode_E
	GENERIC map (
	Iss => Iss, VT => VT, N=>N)
	PORT map (
	anode => GROUND, cathode => Out1);
--for output-2
	m3: sw_resistor_E
	GENERIC map (
	resistance_on => resistance_on, resistance_off => resistance_off)
	port map (
	a => VM, b=> Out2, d=>sw_3);
	
	m4: sw_resistor_E
	GENERIC map (
	resistance_on => resistance_on, resistance_off => resistance_off)
	port map (
	a => Out2, b=> GROUND, d=>sw_4); 
	
	d3: diode_E
	GENERIC map (
	Iss => Iss, VT => VT, N=>N)
	PORT map (
	anode => Out2, cathode => VM);
	
	d4: diode_E
	GENERIC map (
	Iss => Iss, VT => VT, N=>N)
	PORT map (
	anode => GROUND, cathode => Out2);
 
  digital: process (IN1, IN2, nSLEEP)
  begin 
	if nSLEEP = '1' then
	  --forward drive
	  if IN1 = '1' and IN2 = '0' then 
		sw_1 <= '1';
	  	sw_2 <= '0';
	  	sw_3 <= '0';
	  	sw_4 <= '1';
	  --reserve drive
	  elsif IN1 = '0' and IN2 = '1' then
		sw_1 <= '0';
	  	sw_2 <= '1';
	  	sw_3 <= '1';
	  	sw_4 <= '0';
	  --brake
	  elsif IN1 = '1' and IN2 = '1' then
		sw_1 <= '0';
	  	sw_2 <= '1';
	  	sw_3 <= '0';
	  	sw_4 <= '1';
	  elsif IN1 = '0' and IN2 = '0' then
	 	sw_1 <= '1';
	  	sw_2 <= '1';
	  	sw_3 <= '1';
	  	sw_4 <= '1';
	  else
	  	sw_1 <= '0';
	  	sw_2 <= '0';
	  	sw_3 <= '0';
	  	sw_4 <= '0';
	  end if;

	else
	  sw_1 <= '0';
	  sw_2 <= '0';
	  sw_3 <= '0';
	  sw_4 <= '0';

	end if;
  end process;	  
end architecture behavior;