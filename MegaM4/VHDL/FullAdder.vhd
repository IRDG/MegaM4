
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

ENTITY FullAdder IS
	
	PORT	 (
				InA  : IN  STD_LOGIC;
				InB  : IN  STD_LOGIC;
				InC  : IN  STD_LOGIC;
				OutS : OUT STD_LOGIC;
				OutC : OUT STD_LOGIC
			 );
	
END ENTITY FullAdder;

ARCHITECTURE FullAdderArch OF FullAdder IS

SIGNAL Mid : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Mid  <=  InA XOR InB;
OutS <=  InC XOR Mid;
OutC <= (InA AND InB) OR (InC AND Mid);

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.FullAdder 
--PORT MAP	  (InA  => SLV,
--				InB  => SLV,
--				InC  => SLV,
--				OutS => SLV,
--				OutC => SLV
--			  );
--******************************************************--

END FullAdderArch;