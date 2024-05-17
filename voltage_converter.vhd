--Chris Collins and Jose Carlo Doliner
--This program implements how the value from the ADC will be converted and displayed on the MAX10 board
library ieee;--library clause
use ieee.std_logic_1164.all;--use clause
use ieee.numeric_std.all;--use clause 


entity Voltage_converter is --declaring the entity
port(
ADC_in: in std_logic_vector(9 downto 0);--10 bit ADC binary number
adc_finish: in std_logic;
enable: in std_logic;
ones,tenths,hundredths,thousandths: out std_logic_vector(3 downto 0); --output for each decimal number
V_out:out std_logic_vector(15 downto 0);
hex_ones, hex_tenths, hex_hundredths, hex_thousandths, hex_trigger : out std_logic_vector(7 downto 0) --output for displays
);
end voltage_converter;--end entity declaration

architecture behavior of voltage_converter is --architecture is of behavioral type

signal V_temp:unsigned(9 downto 0);

signal v_20:integer;
signal v:std_logic_vector(15 downto 0):="0000000000000000";
signal voltage_int: integer;
signal ones_temp,tenths_temp,hundredths_temp,thousandths_temp: std_logic_vector(3 downto 0):="0000";
signal temp_conv: integer;

begin
process(enable, adc_finish)
begin
if enable='0' and falling_edge(adc_finish) then

V_20<=(to_integer(unsigned(adc_in))*5000)/1023;-- maps the voltage values from 0-5000 therefore keeping decimal places up to the 3rd position

voltage_int<=v_20; 

end if;
end process;
--How each value is grabbed to display on the board
V_out(15 downto 12)<=std_logic_vector(to_unsigned (voltage_int/1000,4));
V_out(11 downto 8)<=std_logic_vector (to_unsigned ((voltage_int/100)mod 10,4));
V_out(7 downto 4)<=std_logic_vector(to_unsigned((voltage_int/10) mod 10,4));
V_out(3 downto 0)<=std_logic_vector(to_unsigned((voltage_int)mod 10,4));

--storing into its respsective place for the hex display
ones_temp<=std_logic_vector(to_unsigned (voltage_int/1000,4));
tenths_temp<=std_logic_vector (to_unsigned ((voltage_int/100)mod 10,4));
hundredths_temp<=std_logic_vector(to_unsigned((voltage_int/10) mod 10,4));
thousandths_temp<=std_logic_vector(to_unsigned((voltage_int)mod 10,4));


ones<=ones_temp;
tenths<=tenths_temp;
hundredths<=hundredths_temp;
thousandths<=thousandths_temp;




--hex displays
--display furthest to right for the thousandths
hex_thousandths <=   "11000000" when thousandths_temp = "0000" else  --The first Hex display displaying 0
"11111001" when thousandths_temp = "0001" else  --The first Hex display displaying 1
"10100100" when thousandths_temp = "0010" else  --The first Hex display displaying 2
"10110000" when thousandths_temp = "0011" else  --The first Hex display displaying 3
"10011001" when thousandths_temp = "0100" else  --The first Hex display displaying 4
"10010010" when thousandths_temp = "0101" else  --The first Hex display displaying 5
"10000010" when thousandths_temp = "0110" else  --The first Hex display displaying 6
"11111000" when thousandths_temp = "0111" else  --The first Hex display displaying 7
"10000000" when thousandths_temp = "1000" else  --The first Hex display displaying 8
"10011000" when thousandths_temp = "1001" else  --The first Hex display displaying 9
"11111111"; --Blank
 
--display for hundreths  
hex_hundredths <=  "11000000" when hundredths_temp = "0000" else  --The second Hex display displaying 0
 "11111001" when hundredths_temp = "0001" else  --The second Hex display displaying 1
 "10100100" when hundredths_temp = "0010" else  --The second Hex display displaying 2
 "10110000" when hundredths_temp = "0011" else  --The second Hex display displaying 3
          "10011001" when hundredths_temp = "0100" else  --The second Hex display displaying 4
 "10010010" when hundredths_temp = "0101" else  --The second Hex display displaying 5
 "10000010" when hundredths_temp = "0110" else  --The second Hex display displaying 6
 "11111000" when hundredths_temp = "0111" else  --The second Hex display displaying 7
 "10000000" when hundredths_temp = "1000" else  --The second Hex display displaying 8
          "10011000" when hundredths_temp = "1001" else  --The second Hex display displaying 9
          "11111111"; --Blank
 
--third hex display for tenths  
hex_tenths <=   "11000000" when tenths_temp = "0000" else  --The third Hex display displaying 0
"11111001" when tenths_temp = "0001" else  --The third Hex display displaying 1
"10100100" when tenths_temp = "0010" else  --The third Hex display displaying 2
"10110000" when tenths_temp = "0011" else  --The third Hex display displaying 3
"10011001" when tenths_temp = "0100" else  --The third Hex display displaying 4
"10010010" when tenths_temp = "0101" else  --The third Hex display displaying 5
"10000010" when tenths_temp = "0110" else  --The third Hex display displaying 6
"11111000" when tenths_temp = "0111" else --The third Hex display displaying 7
"10000000" when tenths_temp = "1000" else --The third Hex display displaying 8
"10011000" when tenths_temp = "1001" else --The third Hex display displaying 9
"11111111"; --Blank

 
--fourth display for ones spot with decimal point
hex_ones <=   "01000000" when ones_temp = "0000" else --The fourth Hex display displaying 0
"01111001" when ones_temp = "0001" else  --The fourth Hex display displaying 1
"00100100" when ones_temp = "0010" else  --The fourth Hex display displaying 2
"00110000" when ones_temp = "0011" else  --The fourth Hex display displaying 3
"00011001" when ones_temp = "0100" else  --The fourth Hex display displaying 4
"00010010" when ones_temp = "0101" else  --The fourth Hex display displaying 5
"00000010" when ones_temp = "0110" else  --The fourth Hex display displaying 6
"01111000" when ones_temp = "0111" else  --The fourth Hex display displaying 7
"00000000" when ones_temp = "1000" else  --The fourth Hex display displaying 8
"00011000" when ones_temp = "1001" else  --The fourth Hex display displaying 9
"11111111"; --Blank

--Creating a trigger to notify if the voltage is too high or too low. 
--The ideal voltage is 3V and anything under or over that value will cause a trigger
hex_trigger <= "10001001" when ones_temp = "0100" else --Display a high warning when '4V'
					"10001001" when ones_temp = "0101" else --Display a high warning when '5V'
					"11000111" when ones_temp = "0000" else --Display a low warning when '0V'
					"11000111" when ones_temp = "0001" else --Display a low warning when '1V'
					"11000111" when ones_temp = "0010" else --Display a low warning when '2V'
					"11111111";


end architecture;
