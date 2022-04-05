
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

--******************************************************--
-- Comentarios:
-- 
-- 
-- 
--******************************************************--

ENTITY Sr IS
	
	GENERIC(
				DataSize    : INTEGER := 8
			 );
	PORT	 (
				MdrData   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
				AluData   : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
				Selector  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
				CtrlInt   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
				IntEnable : IN  STD_LOGIC;
				Enable    : IN  STD_LOGIC;
				Rst       : IN  STD_LOGIC;
				Clk       : IN  STD_LOGIC;
				SrData   : OUT STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0)
			 );
	
END ENTITY Sr;

ARCHITECTURE SrArch OF Sr IS

--******************************************************--
-- 
-- 
-- 
--******************************************************--

CONSTANT Zeros : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0) := (OTHERS => '0');

SIGNAL   Q     : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
SIGNAL DataIn  : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH Selector SELECT
DataIn(4 DOWNTO 0) <= MdrData WHEN "01",
                      AluData WHEN "10",
							 AluData WHEN OTHERS;
DataIn(7 DOWNTO 6) <= CtrlInt;
DataIn(5)          <= IntEnable;


Reg:PROCESS(Clk, Rst, DataIn)

BEGIN
	IF(Rst='1')THEN
		
		Q <= Zeros;
		
	ELSIF(Rising_Edge(Clk)) THEN
		
		IF Enable = '1' THEN
			
			Q(DataSize-1 DOWNTO 0) <= DataIn;
			
		END IF;
		
	END IF;
	
END PROCESS Reg;

SrData <= Q;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Sr
--GENERIC MAP(DataSize    => #
--			  )
--PORT MAP	  (MdrData   => SLV,
--				AluData   => SLV,
--				Selector  => SLV,
--				CtrlInt   => SLV,
--				IntEnable => SLV,
--				Enable    => SLV,
--				Rst       => SLV,
--				Clk       => SLV,
--				SrData   => SLV
--			  );
--******************************************************--

END SrArch;