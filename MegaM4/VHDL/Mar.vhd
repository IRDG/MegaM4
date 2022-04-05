
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

ENTITY Mar IS
	
	GENERIC(
				DataSize    : INTEGER := 16
			 );
	PORT	 (
				IrIn     : IN  STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
				MdrIn    : IN  STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
				SelectIn : IN  STD_LOGIC_VECTOR(         1 DOWNTO 0);
				Enable   : IN  STD_LOGIC;
				Rst      : IN  STD_LOGIC;
				Clk      : IN  STD_LOGIC;
				MarData  : OUT STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0)
			 );
	
END ENTITY Mar;

ARCHITECTURE MarArch OF Mar IS

--******************************************************--
-- 
-- 
-- 
--******************************************************--

CONSTANT Zeros : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0) := (OTHERS => '0');

SIGNAL   Q     : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
SIGNAL DataIn2 : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH SelectIn SELECT
DataIn2 <= IrIn  WHEN "01",
           MdrIn WHEN "10",
			  IrIn  WHEN OTHERS;

Reg:PROCESS(Clk, Rst, DataIn2)

BEGIN
	IF(Rst='1')THEN
		
		Q <= Zeros;
		
	ELSIF(Rising_Edge(Clk)) THEN
		
		IF Enable = '1' THEN
			
			Q(DataSize-1 DOWNTO 0) <= DataIn2;
			
		END IF;
		
	END IF;
	
END PROCESS Reg;

MarData <= Q;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Mar
--GENERIC MAP(DataSize    => #
--			  )
--PORT MAP	  (IrIn     => SLV,
--				MdrIn    => SLV,
--				SelectIn => SLV,
--				Enable   => SLV,
--				Rst      => SLV,
--				Clk      => SLV,
--				MarData  => SLV
--			  );
--******************************************************--

END MarArch;