
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

ENTITY Accumulator1 IS
	
	PORT	 (
				InSelect      : IN  STD_LOGIC_VECTOR(       3 DOWNTO 0);
				IrData        : IN  STD_LOGIC_VECTOR(Word  -1 DOWNTO 0);
				PcCount       : IN  STD_LOGIC_VECTOR(PcSize-1 DOWNTO 0);
				RegisterData  : IN  STD_LOGIC_VECTOR(Word  -1 DOWNTO 0);
				BidirData     : IN  STD_LOGIC_VECTOR(Word  -1 DOWNTO 0);
				ShiftEnable   : IN  STD_LOGIC;
				ArShiftEnable : IN  STD_LOGIC;
				LeftRightN    : IN  STD_LOGIC;
				Enable        : IN  STD_LOGIC;
				Reset         : IN  STD_LOGIC;
				Clk           : IN  STD_LOGIC;
				Acc1Data      : OUT STD_LOGIC_VECTOR(Word  -1 DOWNTO 0)
			 );
	
END ENTITY Accumulator1;

ARCHITECTURE Accumulator1Arch OF Accumulator1 IS

--******************************************************--
--
--******************************************************--


CONSTANT Zeros     : STD_LOGIC_VECTOR(Word-1 DOWNTO 0) := (OTHERS => '0');

SIGNAL   DataIn    : STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
SIGNAL   Q         : STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
SIGNAL   D         : STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
SIGNAL   Shift     : STD_LOGIC_VECTOR(     2 DOWNTO 0);
SIGNAL   PcCount16 : STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
SIGNAL   Ena       : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Acc1Data  <= Q;

PcCount16 <= PcCount(PcSize-1) & PcCount(PcSize-1) & PcCount(PcSize-1) & PcCount(PcSize-1) & PcCount(PcSize-1) & PcCount;
Ena       <= Enable OR ArShiftEnable OR ShiftEnable;

Shift     <= (ShiftEnable OR ArShiftEnable) & ArShiftEnable & LeftRightN;

WITH InSelect SELECT
DataIn <= IrData       WHEN "0001",
			 PcCount16    WHEN "1000",
			 RegisterData WHEN "0100",
			 BidirData    WHEN "0010",
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
--BlockN: ENTITY WORK.Accumulator1
--PORT MAP	  (InSelect      => SLV,
--				IrData        => IrData,
--				PcCount       => SLV,
--				RegisterData  => SLV,
--				BidirData     => BidirData,
--				ShiftEnable   => SLV,
--				ArShiftEnable => SLV,
--				LeftRightN    => SLV,
--				Enable        => SLV,
--				Reset         => SLV,
--				Clk           => SLV,
--				Acc1Data      => SLV
--			  );
--******************************************************--

END Accumulator1Arch;