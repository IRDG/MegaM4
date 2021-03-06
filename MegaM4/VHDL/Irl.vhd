
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

ENTITY Irl IS
	
	GENERIC(
				DataSize    : INTEGER := 16
			 );
	PORT	 (
				DataIn  : IN  STD_LOGIC_VECTOR(DataSize-1    DOWNTO 0);
				Enable  : IN  STD_LOGIC;
				Rst     : IN  STD_LOGIC;
				Clk     : IN  STD_LOGIC;
				DataOut : OUT STD_LOGIC_VECTOR(DataSize-1    DOWNTO 0)
			 );
	
END ENTITY Irl;

ARCHITECTURE IrlArch OF Irl IS

--******************************************************--
-- 
-- 
-- 
--******************************************************--

CONSTANT Zeros : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0) := (OTHERS => '0');

SIGNAL   Q     : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);


BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

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

DataOut <= Q;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Irl
--GENERIC MAP(DataSize    => #
--			  )
--PORT MAP	  (DataIn  => SLV,
--				Enable  => SLV,
--				Rst     => SLV,
--				Clk     => SLV,
--				DataOut => SLV
--			  );
--******************************************************--

END IrlArch;