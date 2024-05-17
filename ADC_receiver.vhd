-- Jose Carlo Doliner & Christopher Collins
-- Logic Devices Programming CET 3136
-- This code reads the serial input from the arduino
-- and shifts it into a register that can be used later for display
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADC_Receiver is 
port(
Enable,sequence_clk,shft_val:in std_logic;
ADC_val:out std_logic_vector(9 downto 0);
finish_out:out std_logic
);
end ADC_Receiver;
--defines architecture for the shift register receiver
architecture Behavior of ADC_Receiver is
signal finish:std_logic:='0';
signal ADC_reg:std_logic_vector(9 downto 0):="0000000000";
signal ADC_temp:std_logic_vector(9 downto 0):="0000000000";
begin

process(enable,sequence_clk,finish)
variable n:integer:=0;
begin
-- each time the sequence clock turns high, enable is high and finish is low
-- each value will shift sequentially
if rising_edge(sequence_clk) and enable='1' and finish='0' then
	--if count is at 0 it means that the register
   --	should be empty so it clears it out
	if n=0 then
	ADC_temp<="0000000000";
	end if;
	--The value is shifted in at the index position of the count
	--the count is increased afterwards
	ADC_temp(n)<=shft_val;
	n:=n+1;
	--when count is 10, all values have been already shifted
	--so finish is set to one and no more values are allowed to shift
	-- count is also reset at this point
	if n=10 then
	finish<='1';
	n:=0; 

end if;

end if;
--when enable turns low, all of the values from the arduino have already shift in
-- the output register gets the temporary values that were shifted from the arduino
-- and finish is set back low
if enable='0'  then
ADC_reg<=ADC_temp;--only prints value when all 10 bits are loaded into register
finish<='0';
end if;

end process;
--sets output to their corresponding register values.
finish_out<=finish;
ADC_val<=ADC_reg;
end Behavior;






