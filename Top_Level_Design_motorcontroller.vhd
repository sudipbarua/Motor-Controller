
LIBRARY IEEE;
USE IEEE.ELECTRICAL_SYSTEMS.ALL;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;

ENTITY motorcontroller IS
    generic(message_length : integer   := 24;
            pwm_bit        : integer   := 21;
            address_length : integer   := 2);
    port (                 
      -- general signals
      reset_n                         : in  std_logic;
      clk                             : in  std_logic;
      -- SPI interface
      sclk                            : in  std_logic;
      cs_n                            : in  std_logic;
      din                             : in  std_logic;
      -- Analog connections
      TERMINAL Out1, Out2, GROUND, VM, VCC : ELECTRICAL);
END motorcontroller;

ARCHITECTURE struct OF motorcontroller IS

-- student work
component PWM_digital_top_E is
  generic(message_length : integer   := 17;
          pwm_bit        : integer   := 14;
          address_length : integer   := 2);
  port (                                -- general signals
    reset_n                         : in  std_logic;
    clk                             : in  std_logic;
    -- SPI interface
    sclk                            : in  std_logic;
    cs_n                            : in  std_logic;
    din                             : in  std_logic;
    -- PWM output
    pwm_out1, pwm_out2, pwm_n_sleep : out std_logic);
end component;

component motor_driver_E IS
  GENERIC (
  Iss : real := 1.0e-9; 
  VT : real := 25.0e-3; 
  N : real := 1.1);
  --resistance_on : real := 0.01;
  --resistance_off : real := 10.0e6
  
  PORT (
    TERMINAL Out1, Out2, GROUND, VM, VCC : ELECTRICAL;
    SIGNAL IN1, IN2, nSLEEP : std_logic);

END component;

signal pwm_out1_s, pwm_out2_s, pwm_n_sleep_s : std_logic;

BEGIN

-- student work
pwm_gen:PWM_digital_top_E
  port map(
    reset_n => reset_n,
    clk => clk,
    sclk => sclk,
    cs_n => cs_n,
    din => din,
    pwm_out1 => pwm_out1_s, pwm_out2 => pwm_out2_s, pwm_n_sleep => pwm_n_sleep_s);

DAC:motor_driver_E
  
  PORT MAP(Out1 => Out1, Out2 => Out2, GROUND => GROUND, VM => VM, VCC =>VCC, 
  IN1 => pwm_out1_s, IN2 => pwm_out2_s, nSLEEP => pwm_n_sleep_s);

END architecture struct;
