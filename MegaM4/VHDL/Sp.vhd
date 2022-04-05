
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

ENTITY Sp IS
	
	GENERIC(
				Size: INTEGER := 10
			 );
	PORT	 (
				Enable       : IN  STD_LOGIC;
				UpDownN      : IN  STD_LOGIC;
				Rst          : IN  STD_LOGIC;
				Clk          : IN  STD_LOGIC;
				StackPointer : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0)
			 );
	
END ENTITY Sp;

ARCHITECTURE SpArch OF Sp IS

SIGNAL Q  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL Qn : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL D  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL E  : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL Up : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
SIGNAL Dw : STD_LOGIC_VECTOR(Size-1 DOWNTO 0);


BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Qn(0) <= NOT Q (0);
D (0) <=     Qn(0);
E (0) <=     Enable;

FF0: ENTITY WORK.FlipFlopRe 
PORT MAP	  (D    => D(0),
				Q    => Q(0),
				Ena  => E(0),
				Clk  => Clk,
				Rst  => Rst,
				Set  => '1'
			  );

StackPointer(0) <= Q(0);


Qn(1) <= NOT Q (1);
D (1) <=     Qn(1);
Dw(1) <=     Qn(0) AND (NOT UpDownN) AND E (0);
Up(1) <=     Q (0) AND (    UpDownN) AND E (0);
E (1) <=     Dw(1) OR       Up(1);

FF1: ENTITY WORK.FlipFlopRe 
PORT MAP	  (D    => D(1),
				Q    => Q(1),
				Ena  => E(1),
				Clk  => Clk,
				Rst  => Rst,
				Set  => '1'
			  );

StackPointer(1) <= Q(1);

SpGenerator: FOR I IN 2 TO Size-1 GENERATE
	
	Qn(I) <= NOT Q (I);
	D (I) <=     Qn(I);
	Dw(I) <=     Qn(I-1) AND (NOT UpDownN) AND E (I-1);
	Up(I) <=     Q (I-1) AND (    UpDownN) AND E (I-1);
	E (I) <=     Dw(I)   OR       Up(I);

	FFn: ENTITY WORK.FlipFlopRe 
	PORT MAP	  (D    => D(I),
					Q    => Q(I),
					Ena  => E(I),
					Clk  => Clk,
					Rst  => Rst,
					Set  => '1'
				  );
	
	StackPointer(I) <= Q(I);
	
END GENERATE SpGenerator;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Sp 
--GENERIC MAP(Size => #
--			  )
--PORT MAP	  (Enable       => SLV,
--				UpDownN      => SLV,
--				Rst          => SLV,
--				Clk          => SLV,
--				StackPointer => SLV
--			  );
--******************************************************--

END SpArch;