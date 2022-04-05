
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
-- 
-- 
-- 
--******************************************************--

ENTITY Registers IS
	
	GENERIC(
				DataSize    : INTEGER := 16;
				RpgAddress  : INTEGER := 5
			 );
	PORT	 (
				Acc1Data   : IN  STD_LOGIC_VECTOR(  DataSize-1 DOWNTO 0);
				Acc2Data   : IN  STD_LOGIC_VECTOR(  DataSize-1 DOWNTO 0);
				SelectIn   : IN  STD_LOGIC_VECTOR(           1 DOWNTO 0);
				RAddress   : IN  STD_LOGIC_VECTOR(RpgAddress-1 DOWNTO 0);
				Enable     : IN  STD_LOGIC;
				Rst        : IN  STD_LOGIC;
				Clk        : IN  STD_LOGIC;
				DataOut    : OUT STD_LOGIC_VECTOR(  DataSize-1 DOWNTO 0)
			 );
	
END ENTITY Registers;

ARCHITECTURE RegistersArch OF Registers IS

CONSTANT AddressSize  : INTEGER := 5;
CONSTANT RegisterSize : INTEGER := 2**5;

--******************************************************--
--  0 1 2 3 ... DataSize-1 
-- 0
-- 1
-- 2
-- ...
-- RegisterSize-1
--
--******************************************************--

TYPE Matrix IS ARRAY (0 TO RegisterSize-1) OF STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);

CONSTANT Zeros       : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0) := (OTHERS => '0');
CONSTANT Reset       : Matrix := (OTHERS => Zeros);

SIGNAL   Q           : Matrix;

SIGNAL   AddressI    : INTEGER;

SIGNAL   DataIn      : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
SIGNAL   ConstantReg : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH SelectIn SELECT
DataIn <= Acc1Data WHEN "01",
          Acc2Data WHEN "10",
			 Acc1Data WHEN OTHERS;

AddressI <= TO_INTEGER(UNSIGNED(RAddress));

WITH RAddress(1 DOWNTO 0) SELECT
ConstantReg <= ("0000"&"0000"&"0000"&"0000") WHEN "00",
               ("1111"&"1111"&"1111"&"1111") WHEN "01",
					("0000"&"0000"&"0000"&"0001") WHEN "10",
					("0000"&"0000"&"0000"&"0000") WHEN OTHERS;

Reg:PROCESS(Clk, Rst, DataIn)

BEGIN
	IF(Rst='1')THEN
		
		Q <= Reset;
		
	ELSIF(Rising_Edge(Clk)) THEN
		
		IF((Enable ='1')AND(AddressI>2)) THEN
			
			Q(AddressI)(DataSize-1 DOWNTO 0) <= DataIn;
			
		END IF;
		
	END IF;
	
END PROCESS Reg;

DataOut <= Q(AddressI)(DataSize-1 DOWNTO 0) WHEN(AddressI>2)ELSE
			  ConstantReg;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Registers
--GENERIC MAP(DataSize   => #,
--				RpgAddress => #
--			  )
--PORT MAP	  (Acc1Data => SLV,
--				Acc2Data => SLV,
--				SelectIn => SLV,
--				RAddress => SLV,
--				Enable   => SLV,
--				Rst      => SLV,
--				Clk      => SLV,
--				DataOut  => SLV
--			  );
--******************************************************--

END RegistersArch;