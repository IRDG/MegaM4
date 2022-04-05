
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
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY DownCounter IS
	
	GENERIC(
				Size: INTEGER := 7
			 );
	PORT	 (
				Enable   : IN  STD_LOGIC;
				Data     : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
				DataLoad : IN  STD_LOGIC;
				Rst      : IN  STD_LOGIC;
				Clk      : IN  STD_LOGIC;
				Count    : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0)
			 );
	
END ENTITY DownCounter;

ARCHITECTURE DownCounterArch OF DownCounter IS

SIGNAL Q  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL Qn : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL D  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL E  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Qn(0) <= NOT Q (0);
D (0) <=    (Qn(0) AND (NOT DataLoad))OR(Data(0) AND DataLoad);
E (0) <=     Enable;

FF0: ENTITY WORK.FlipFlop 
PORT MAP	  (D    => D(0),
				Q    => Q(0),
				Ena  => E(0),
				Clk  => Clk,
				Rst  => Rst,
				Set  => '1'
			  );

Count(0) <= Q(0);

DownCounterGenerator: FOR I IN 1 TO Size-1 GENERATE
	
	Qn(I) <= NOT Q (I);
	D (I) <=    (Qn(I)   AND (NOT DataLoad)) OR (Data(I) AND DataLoad);
	E (I) <=    (E (I-1) AND  NOT Q(I-1))    OR (DataLoad) ;

	FF0: ENTITY WORK.FlipFlop 
	PORT MAP	  (D    => D(I),
					Q    => Q(I),
					Ena  => E(I),
					Clk  => Clk,
					Rst  => Rst,
					Set  => '1'
				  );
	
	Count(I) <= Q(I);
	
END GENERATE DownCounterGenerator;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.DownCounter 
--GENERIC MAP(Size => #
--			  )
--PORT MAP	  (Enable   => SLV,
--				Data     => SLV,
--				DataLoad => SLV,
--				Rst      => SLV,
--				Clk      => SLV,
--				Count    => SLV
--			  );
--******************************************************--

END DownCounterArch;