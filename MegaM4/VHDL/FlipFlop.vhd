
--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:2019                         --
--******************************************************--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY FlipFlop IS
	
	PORT	 (
				D    : IN  STD_LOGIC;
				Q    : OUT STD_LOGIC;
				Ena  : IN  STD_LOGIC;
				Clk  : IN  STD_LOGIC;
				Rst  : IN  STD_LOGIC;
				Set  : IN  STD_LOGIC
			 );
			 
END ENTITY FlipFlop;

ARCHITECTURE FlipFlopArch OF FlipFlop IS

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

PROCESS(Clk, Rst, D)

BEGIN
	
	IF(Rst='1')THEN
		
		IF(Set='1')THEN
			
			Q <='1';
			
		ELSIF(Set='0')THEN
			
			Q <='0';
			
		END IF;
		
	ELSIF(Rising_Edge(Clk))THEN
		
		IF(Ena ='1')THEN
			
			Q <= D;
			
		END IF;
		
	END IF;
	
END PROCESS;
--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.FlipFlop 
--PORT MAP	  (D    => SLV,
--				Q    => SLV,
--				Ena  => SLV,
--				Clk  => SLV,
--				Rst  => SLV,
--				Set  => SLV
--			  );
--******************************************************--

end FlipFlopArch;