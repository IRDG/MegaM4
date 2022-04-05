
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
-- 
--******************************************************--

ENTITY SignalSelectors IS
	
	PORT	 (
				SelectInputBitSliceB : IN  STD_LOGIC_VECTOR(            1 DOWNTO 0);
				SelectInputBitSliceA : IN  STD_LOGIC_VECTOR(            1 DOWNTO 0);
				A                    : IN  STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				B                    : IN  STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				SumOutA              : IN  STD_LOGIC_VECTOR(       NomB-1 DOWNTO 0);
				SumOutB              : IN  STD_LOGIC_VECTOR(       NomB-1 DOWNTO 0);
				SumInA               : OUT STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				SumInB               : OUT STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				
				ResultMultiplication : IN  STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				ResultBitSliceFixed  : IN  STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				ResultSelect         : IN  STD_LOGIC_VECTOR(SelectorALU-1 DOWNTO 0);
				ResultFinal          : OUT STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				
				CarryBitSlice        : IN  STD_LOGIC;
				CarrySelect          : IN  STD_LOGIC;
				CarryOut             : OUT STD_LOGIC;
				
				ResultBitSlice       : IN  STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				SelectOutputBitSlice : IN  STD_LOGIC;
				ResultBitSliceZrs    : OUT STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				
				FinalResult          : IN  STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
				Zeros                : OUT STD_LOGIC;
				Negative             : OUT STD_LOGIC;
				OverFlow             : OUT STD_LOGIC
				
			 );
	
END ENTITY SignalSelectors;

ARCHITECTURE SignalSelectorsArch OF SignalSelectors IS

CONSTANT NomBZerosToNoB : STD_LOGIC_VECTOR(NoB-NomB-1 DOWNTO 0) := (OTHERS => '0');
CONSTANT InZeros        : STD_LOGIC_VECTOR(     NoB-1 DOWNTO 0) := (OTHERS => '0');

SIGNAL   PartialZeros   : STD_LOGIC_VECTOR( NoB-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH SelectInputBitSliceA SELECT
SumInA <=                  A       WHEN "00",    -- Suma Resta o funcion logica normal
			 NomBZerosToNoB & SumOutA WHEN "01",    -- Suma resta multilplicacion
			                  A       WHEN "10",    -- 2s complemet
			                  A       WHEN OTHERS;

WITH SelectInputBitSliceB SELECT
SumInB <=                  B       WHEN "00",    -- Suma Resta o funcion logica normal
			 NomBZerosToNoB & SumOutB WHEN "01",    -- Suma resta multilplicacion
			                  InZeros WHEN "10",    -- 2s complemet
			                  B       WHEN OTHERS;

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH CarrySelect SELECT
CarryOut <= CarryBitSlice WHEN '0',    
			             '0' WHEN OTHERS;

--******************************************************--
-- 
-- 
-- 
--******************************************************--

PartialZeros(0) <= FinalResult(0);

ZerosAutentificator: FOR I IN 1 TO NoB-1 GENERATE
	
	PartialZeros(I) <= PartialZeros(I-1) OR FinalResult(I);
	
END GENERATE ZerosAutentificator;

Zeros    <= NOT PartialZeros(NoB-1);

Negative <=     FinalResult(NoB-1);

OverFlow <= ((A(NoB-1) XNOR B(NoB-1)) AND (A(NoB-1) XOR FinalResult(NoB-1)));

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH ResultSelect SELECT
ResultFinal <= ResultBitSliceFixed  WHEN "0",    
			      ResultMultiplication WHEN OTHERS;

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH SelectOutputBitSlice SELECT
ResultBitSliceZrs <= ResultBitSlice  WHEN '0',    
					      InZeros         WHEN OTHERS;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.SignalSelectors 
--PORT MAP	  (SelectInputBitSliceA => SLV,
--				SelectInputBitSliceB => SLV,
--				A                    => SLV,
--				B                    => SLV,
--				SumOutA              => SLV,
--				SumOutB              => SLV,
--				SumInA               => SLV,
--				SumInB               => SLV,
--				ResultMultiplication => SLV,
--				ResultBitSliceFixed  => SLV,
--				ResultSelect         => SLV,
--				ResultFinal          => SLV,
--				ResultSelect         => SLV,
--				CarryBitSlice        => SLV,
--				CarrySelect          => SLV,
--				CarryOut             => SLV,
--				SelectOutputBitSlice => SLV,
--				ResultBitSliceZrs    => SLV,
--				ResultBitSlice       => SLV,
--				FinalResult          => SLV,
--				Zeros                => SLV,
--				Negative             => SLV
--			  );
--******************************************************--


END SignalSelectorsArch;