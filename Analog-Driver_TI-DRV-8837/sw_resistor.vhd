
LIBRARY IEEE;
USE IEEE.ELECTRICAL_SYSTEMS.ALL;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;

ENTITY sw_resistor_E IS
  
  GENERIC (
    resistance_on : real := 0.01;
    resistance_off : real := 10.0e6);        -- change entity to switchable resistor

  PORT (
    --analog
    TERMINAL a,b : ELECTRICAL;
    --digital
    signal d : in std_logic);

END sw_resistor_E;

ARCHITECTURE simple OF sw_resistor_E IS
  QUANTITY u_r ACROSS i_r THROUGH a TO b;
  
BEGIN  -- simple
BREAK on d;
if d = '1' use
  i_r == u_r/resistance_on;
else 
  i_r == u_r/resistance_off;
end use;



END simple; 