
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
-- 
--******************************************************--

ENTITY Mdr IS
	
	GENERIC(
				DataSize    : INTEGER := 16
			 );
	PORT	 (
				SrData   : IN  STD_LOGIC_VECTOR(   DataSize-1 DOWNTO 0);
				Acc1Data : IN  STD_LOGIC_VECTOR(   DataSize-1 DOWNTO 0);
				Acc2Data : IN  STD_LOGIC_VECTOR(   DataSize-1 DOWNTO 0);
				PcCount  : IN  STD_LOGIC_VECTOR(   DataSize-1 DOWNTO 0);
				IrData   : IN  STD_LOGIC_VECTOR(   DataSize-1 DOWNTO 0);
				BidirIn  : IN  STD_LOGIC_VECTOR(   DataSize-1 DOWNTO 0);
				MarIn    : IN  STD_LOGIC_VECTOR(AddressSize-1 DOWNTO 0);
				SelectIn : IN  STD_LOGIC_VECTOR(            6 DOWNTO 0);
				Enable   : IN  STD_LOGIC;
				Rst      : IN  STD_LOGIC;
				Clk      : IN  STD_LOGIC;
				MdrOut   : OUT STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0)
			 );
	
END ENTITY Mdr;

ARCHITECTURE MdrArch OF Mdr IS

--******************************************************--
-- 
-- 
-- 
--******************************************************--

CONSTANT Zeros    : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0) := (OTHERS => '0');

SIGNAL   Q        : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
SIGNAL   DataIn   : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
SIGNAL   PcCountT : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
SIGNAL   MarIn2   : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

PcCountT <= PcCount(10) & PcCount(10) & PcCount(10) & PcCount(10) & PcCount(10) & PcCount(10 DOWNTO 0);

MarIn2   <= MarIn(11) & MarIn(11) & MarIn(11) & MarIn(11) & (MarIn(AddressSize-1 DOWNTO 0));

WITH SelectIn SELECT
DataIn <= SrData   WHEN "0100000",
			 Acc1Data WHEN "0000100",
			 Acc2Data WHEN "0001000",
			 PcCountT WHEN "0010000",
			 IrData   WHEN "0000010",
			 BidirIn  WHEN "0000001",
			 MarIn2   WHEN "1000000",
			 Acc1Data WHEN OTHERS;

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

MdrOut <= Q;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Mdr
--GENERIC MAP(DataSize    => #,
--			  )
--PORT MAP	  (SrData   => SLV,
--				Acc1Data => SLV,
--				Acc2Data => SLV,
--				PcCount  => SLV,
--				IrData   => SLV,
--				BidirIn  => SLV,
--				MarIn    => SLV,
--				SelectIn => SLV,
--				Enable   => SLV,
--				Rst      => SLV,
--				Clk      => SLV,
--				MdrOut   => SLV
--			  );
--******************************************************--

END MdrArch;