
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

ENTITY Cr IS
	
	GENERIC(
				Size: INTEGER := PcSize
			 );
	PORT	 (
				Enable   : IN  STD_LOGIC;
				Data     : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				CtrlData : IN  STD_LOGIC_VECTOR(     1 DOWNTO 0);
				DataLoad : IN  STD_LOGIC;
				Rst      : IN  STD_LOGIC;
				Clk      : IN  STD_LOGIC;
				CrData   : OUT STD_LOGIC_VECTOR(     3 DOWNTO 0)
			 );
	
END ENTITY Cr;

ARCHITECTURE CrArch OF Cr IS

CONSTANT Zeros  : STD_LOGIC_VECTOR(Size-1 DOWNTO 2) := (OTHERS=>'0');

SIGNAL   Q      : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL   Qn     : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL   D      : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL   E      : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL   Count  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);

SIGNAL   Temp1  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL   Temp2  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);

SIGNAL   ExData : STD_LOGIC_VECTOR(     1 DOWNTO 0);
SIGNAL   NxData : STD_LOGIC_VECTOR(Size-1 DOWNTO 2);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH CtrlData SELECT
ExData <= CtrlData         WHEN "01",
          CtrlData         WHEN "10",
			 CtrlData         WHEN "11",
			 Data(1 DOWNTO 0) WHEN "00",
          Data(1 DOWNTO 0) WHEN OTHERS;

Qn(0) <= NOT Q (0);
D (0) <=    (Qn(0) AND (NOT DataLoad)) OR (ExData(0) AND DataLoad);
E (0) <=     Enable OR      DataLoad;

FF0: ENTITY WORK.FlipFlopRe 
PORT MAP	  (D    => D(0),
				Q    => Q(0),
				Ena  => E(0),
				Clk  => Clk,
				Rst  => Rst,
				Set  => '0'
			  );

Count(0) <= Q(0);


Qn(1) <= NOT Q (1);
D (1) <=    (Qn(1) AND (NOT DataLoad)) OR (ExData(1)   AND DataLoad);
E (1) <=    (E (0) AND      Qn(0))     OR (DataLoad);

FF1: ENTITY WORK.FlipFlopRe 
PORT MAP	  (D    => D(1),
				Q    => Q(1),
				Ena  => E(1),
				Clk  => Clk,
				Rst  => Rst,
				Set  => '0'
			  );

Count(1) <= Q(1);

WITH CtrlData SELECT
NxData <= Zeros                 WHEN "01",
          Zeros                 WHEN "10",
			 Zeros                 WHEN "11",
			 Data(Size-1 DOWNTO 2) WHEN "00",
          Data(Size-1 DOWNTO 2) WHEN OTHERS;

CrGenerator: FOR I IN 2 TO Size-1 GENERATE
	
	Qn(I) <= NOT Q (I);
	D (I) <=    (Qn(I)   AND (NOT DataLoad)) OR (NxData(I) AND DataLoad);
	E (I) <=    (E (I-1) AND      Qn(I-1))   OR (DataLoad);

	FFn: ENTITY WORK.FlipFlopRe 
	PORT MAP	  (D    => D(I),
					Q    => Q(I),
					Ena  => E(I),
					Clk  => Clk,
					Rst  => Rst,
					Set  => '0'
				  );
	
	Count(I) <= Q(I);
	
END GENERATE CrGenerator;

CrData(0) <= Count(0);

Crdata(3) <= Count(1);

Temp1(0)  <= Count(0);
Temp2(0)  <= Count(0);

DataGenerator: FOR I IN 1 TO Size-1 GENERATE

Temp1(I) <= Count(I) OR  Temp1(I-1);
Temp2(I) <= Count(I) OR  Temp2(I-1);

END GENERATE DataGenerator;

CrData(1) <= NOT Temp1(Size-1);  --Zero
CrData(2) <=     Temp2(Size-1);  --unos

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Cr 
--GENERIC MAP(Size => #
--			  )
--PORT MAP	  (Enable   => SLV,
--				Data     => SLV,
--				DataLoad => SLV,
--				CtrlData => SLV,
--				Rst      => SLV,
--				Clk      => SLV,
--				CrData   => SLV
--			  );
--******************************************************--

END CrArch;