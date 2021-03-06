
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

USE Work.MyPackage.ALL;

--******************************************************--
-- Comentarios:
-- 
-- 
-- 
--******************************************************--

ENTITY Accumulator2 IS
	
	PORT	 (
				InSelect      : IN  STD_LOGIC_VECTOR(       3 DOWNTO 0);
				IrData        : IN  STD_LOGIC_VECTOR(Word  -1 DOWNTO 0);
				AluResult     : IN  STD_LOGIC_VECTOR(Word  -1 DOWNTO 0);
				RegisterData  : IN  STD_LOGIC_VECTOR(Word  -1 DOWNTO 0);
				BidirData     : IN  STD_LOGIC_VECTOR(Word  -1 DOWNTO 0);
				ShiftEnable   : IN  STD_LOGIC;
				ArShiftEnable : IN  STD_LOGIC;
				LeftRightN    : IN  STD_LOGIC;
				Enable        : IN  STD_LOGIC;
				Reset         : IN  STD_LOGIC;
				Clk           : IN  STD_LOGIC;
				Acc2Data      : OUT STD_LOGIC_VECTOR(Word  -1 DOWNTO 0)
			 );
	
END ENTITY Accumulator2;

ARCHITECTURE Accumulator2Arch OF Accumulator2 IS

--******************************************************--
--
--******************************************************--


CONSTANT Zeros     : STD_LOGIC_VECTOR(Word-1 DOWNTO 0) := (OTHERS => '0');

SIGNAL   DataIn    : STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
SIGNAL   Q         : STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
SIGNAL   D         : STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
SIGNAL   Shift     : STD_LOGIC_VECTOR(     2 DOWNTO 0);
SIGNAL   IrPcMod16 : STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
SIGNAL   Ena       : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Acc2Data  <= Q;

Ena       <= Enable OR ArShiftEnable OR ShiftEnable;

Shift     <= (ShiftEnable OR ArShiftEnable) & ArShiftEnable & LeftRightN;

WITH InSelect SELECT
DataIn <= IrData       WHEN "0001",
			 RegisterData WHEN "0100",
			 BidirData    WHEN "0010",
			 AluResult    WHEN "1000",
			 IrData       WHEN OTHERS;

WITH Shift SELECT
D(0) <= DataIn(0) WHEN "000",
        Q(Word-1) WHEN "101",-- Left  Shift
		  Q(     1) WHEN "100",-- Right Shift
		  Q(Word-1) WHEN "111",-- Left  Arithmetic Shift
		  Q(     1) WHEN "110",-- Right Arithmetic Shift
		  DataIn(0) WHEN OTHERS;

Acc1N0: ENTITY WORK.FlipFlopRe 
PORT MAP	  (D    => D(0),
				Q    => Q(0),
				Ena  => Ena,
				Clk  => Clk,
				Rst  => Reset,
				Set  => '0'
			  );

RegGenerator: FOR I IN 1 TO Word-2 GENERATE

WITH Shift SELECT
D(I) <= DataIn(I) WHEN "000",
        Q(I-1)    WHEN "101",-- Left  Shift
		  Q(I+1)    WHEN "100",-- Right Shift
		  Q(I-1)    WHEN "111",-- Left  Shift
		  Q(I+1)    WHEN "110",-- Right Shift
		  DataIn(I) WHEN OTHERS;

Acc1: ENTITY WORK.FlipFlopRe 
PORT MAP	  (D    => D(I),
				Q    => Q(I),
				Ena  => Ena,
				Clk  => Clk,
				Rst  => Reset,
				Set  => '0'
			  );

END GENERATE RegGenerator;

WITH Shift SELECT
D(Word-1) <= DataIn(Word-1) WHEN "000",
             Q(Word-2)      WHEN "101",-- Left  Shift
		       Q(     0)      WHEN "100",-- Right Shift
		       Q(Word-1)      WHEN "111",-- Left  Arithmetic Shift
		       Q(Word-1)      WHEN "110",-- Right Arithmetic Shift
				 DataIn(Word-1) WHEN OTHERS;

Acc1Nf: ENTITY WORK.FlipFlopRe 
PORT MAP	  (D    => D(Word-1),
				Q    => Q(Word-1),
				Ena  => Ena,
				Clk  => Clk,
				Rst  => Reset,
				Set  => '0'
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Accumulator2
--PORT MAP	  (InSelect      => SLV,
--				IrData        => SLV,
--				IrPcMod       => SLV,
--				AluResult     => SLV,
--				RegisterData  => SLV,
--				BidirData     => SLV,
--				ShiftEnable   => SLV,
--				ArShiftEnable => SLV,
--				LeftRightN    => SLV,
--				Enable        => SLV,
--				Reset         => SLV,
--				Clk           => SLV,
--				Acc2Data      => SLV
--			  );
--******************************************************--

END Accumulator2Arch;