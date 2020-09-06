
LIBRARY IEEE;
USE IEEE.ELECTRICAL_SYSTEMS.ALL;
use ieee.math_real.all;

ENTITY diode_E IS
  GENERIC (
  Iss : real := 1.0e-9; 
  VT : real := 25.0e-3; 
  N : real := 1.1);
  PORT (
    TERMINAL anode, cathode : ELECTRICAL);

END diode_E;

-- Architecture to be added by the students
architecture struct of diode_E is
	quantity vd across id through anode to cathode;
	
begin
	id == Iss * (exp((vd/N*VT) -1.0));

end architecture struct;