
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

ENTITY LogicFunctions IS
	
	PORT	 (
				InA    : IN  STD_LOGIC;
				InB    : IN  STD_LOGIC;
				OrOut  : OUT STD_LOGIC;
				AndOut : OUT STD_LOGIC;
				NotOut : OUT STD_LOGIC
			 );
	
END ENTITY LogicFunctions;

ARCHITECTURE LogicFunctionsArch OF LogicFunctions IS

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--
--LogicGenerator: FOR I IN 0 TO NoB-1 GENERATE
--END GENERATE LogicGenerator;
	OrOut  <=     InA OR  InB;
	AndOut <=     InA AND InB;
	NotOut <= NOT InA;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.LogicFunctions 
--PORT MAP	  (InA    => SLV,
--				InB    => SLV,
--				OrOut  => SLV,
--				AndOut => SLV,
--				NotOut => SLV
--			  );
--******************************************************--
END LogicFunctionsArch;