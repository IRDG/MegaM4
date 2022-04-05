
--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:20XX                         --
--******************************************************--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

USE WORK.MyPackage.ALL;

--******************************************************--
-- Comentarios:
-- 
-- un pan :3
-- 
--******************************************************--

ENTITY AndsBlock IS
	
	PORT	 (
				SignalA : IN  STD_LOGIC;
				SignalB : IN  STD_LOGIC_VECTOR(NoB-1 DOWNTO 0);
				Result  : OUT STD_LOGIC_VECTOR(NoB-1 DOWNTO 0)
			 );
	
END ENTITY AndsBlock;

ARCHITECTURE AndsBlockArch OF AndsBlock IS

BEGIN

OutputGenerator: FOR I IN 0 TO NoB-1 GENERATE
	
	Result(I) <= SignalA AND SignalB(I);
	
END GENERATE OutputGenerator;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.AndsBlock 
--PORT MAP	  (SignalA => SLV,
--				SignalB => SLV,
--				Result  => SLV
--			  );
--******************************************************--

END AndsBlockArch;