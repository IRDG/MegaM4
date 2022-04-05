
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
USE IEEE.numeric_std.all;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

USE WORK.MyPackage.ALL;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY GralMux IS
	GENERIC(
				NoI : INTEGER := NoOBS;
				NoS : INTEGER := SelectorBS    -- NumberOfSelector
			 );
	PORT	 (
				Input    : IN  STD_LOGIC_VECTOR(NoI-1 DOWNTO 0);
				Selector : IN  STD_LOGIC_VECTOR(NoS-1 DOWNTO 0);
				Output   : OUT STD_LOGIC
			 );
	
END ENTITY GralMux;

ARCHITECTURE GralMuxArch OF GralMux IS

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Output <= Input(TO_INTEGER(UNSIGNED(Selector)));

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.GralMux 
--GENERIC MAP(NoI => #,
--	  			NoS => #
--			  )
--PORT MAP	  (Input    => SLV,
--				Selector => SLV,
--				Output   => SLV
--			  );
--******************************************************--

END GralMuxArch;