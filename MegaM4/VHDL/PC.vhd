
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

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY PC IS
	
	GENERIC(
				Size: INTEGER := 11
			 );
	PORT	 (
				Enable   : IN  STD_LOGIC;
				IrData   : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				DataLoad : IN  STD_LOGIC;
				Selector : IN  STD_LOGIC_VECTOR(     3 DOWNTO 0);
				AccPc    : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				MdrData  : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				RegData  : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				Rst      : IN  STD_LOGIC;
				Clk      : IN  STD_LOGIC;
				Count    : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0)
			 );
	
END ENTITY PC;

ARCHITECTURE PcArch OF PC IS

SIGNAL Data : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);

SIGNAL Q    : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL Qn   : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL D    : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL E    : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH Selector SELECT
Data <= AccPc   WHEN "0100",
		  MdrData WHEN "0010",
	     RegData WHEN "1000",
		  IrData  WHEN "0001",
		  IrData  WHEN OTHERS;

Qn(0) <= NOT Q (0);
D (0) <=    (Qn(0) AND (NOT DataLoad)) OR (Data(0) AND DataLoad);
E (0) <=     Enable OR DataLoad;

FF0: ENTITY WORK.FlipFlopRe 
PORT MAP	  (D    => D(0),
				Q    => Q(0),
				Ena  => E(0),
				Clk  => Clk,
				Rst  => Rst,
				Set  => '0'
			  );

Count(0) <= Q(0);

PcGenerator: FOR I IN 1 TO Size-1 GENERATE
	
	Qn(I) <= NOT Q (I);
	D (I) <=    (Qn(I)   AND (NOT DataLoad)) OR (Data(I) AND DataLoad);
	E (I) <=    (E (I-1) AND      Q(I-1))    OR (DataLoad) ;

	FF0: ENTITY WORK.FlipFlopRe 
	PORT MAP	  (D    => D(I),
					Q    => Q(I),
					Ena  => E(I),
					Clk  => Clk,
					Rst  => Rst,
					Set  => '0'
				  );
	
	Count(I) <= Q(I);
	
END GENERATE PcGenerator;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.PC 
--GENERIC MAP(Size => #
--			  )
--PORT MAP	  (Enable   => SLV,
--				IrData   => SLV,
--				DataLoad => SLV,
--				Selector => SLV,
--				AccPc => SLV,
--				MdrData => SLV,
--				RegData => SLV,
--				Rst      => SLV,
--				Clk      => SLV,
--				Count    => SLV
--			  );
--******************************************************--

END PcArch;

