
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
-- Fc : [{OpC2(0)},{OpC2(0)},{OpC1(1)},{OpC1(0)}]
-- 
-- OpCodes
-- 
--       | OpC1 | OpC2 |
-- Suma  |  01  |  00  |
-- Resta |  01  |  01  |
-- 2sC   |  01  |  10  |
-- OR    |  00  |  00  |
-- AND   |  00  |  01  |
-- NOT   |  00  |  10  |
-- Mult  |  10  |  --  |
-- 
-- F : [{Rst}]
-- 
-- D : [{OverFlow}{Negative}{Carry}{Zeros}{EndFlag}]
-- 
--******************************************************--

ENTITY ArithmeticLogicUnit IS
	
	PORT	 (
				A   : IN  STD_LOGIC_VECTOR(NoB-1 DOWNTO 0);
				B   : IN  STD_LOGIC_VECTOR(NoB-1 DOWNTO 0);
				Fc  : IN  STD_LOGIC_VECTOR(    4 DOWNTO 0);
				Clk : IN  STD_LOGIC;
				S   : OUT STD_LOGIC_VECTOR(    2 DOWNTO 0);
				D   : OUT STD_LOGIC_VECTOR(    4 DOWNTO 0);
				R   : OUT STD_LOGIC_VECTOR(NoB-1 DOWNTO 0)
			 );
	
END ENTITY ArithmeticLogicUnit;

ARCHITECTURE ArithmeticLogicUnitArch OF ArithmeticLogicUnit IS

SIGNAL   F                    : STD_LOGIC_VECTOR(            0 DOWNTO 0);

SIGNAL   StartMultiplication  : STD_LOGIC;

SIGNAL   MultiplyEnableSum    : STD_LOGIC;

SIGNAL   SignOutA             : STD_LOGIC;
SIGNAL   SumOutA              : STD_LOGIC_VECTOR(       NomB-1 DOWNTO 0);
SIGNAL   SumOutB              : STD_LOGIC_VECTOR(       NomB-1 DOWNTO 0);
SIGNAL   SumInMultiply        : STD_LOGIC_VECTOR(       NomB-1 DOWNTO 0);

SIGNAL   SignA                : STD_LOGIC;
SIGNAL   SumInA               : STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
SIGNAL   SumInB               : STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);

SIGNAL   BitSliceOperSelect   : STD_LOGIC_VECTOR( SelectorBS-1 DOWNTO 0);

SIGNAL   ResultMultiplication : STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
SIGNAL   ResultBitSlice       : STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
SIGNAL   ResultBitSliceFixed  : STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
SIGNAL   CarryBitSlice        : STD_LOGIC;

SIGNAL   SelectInputBitSliceA : STD_LOGIC_VECTOR(            1 DOWNTO 0);
SIGNAL   SelectInputBitSliceB : STD_LOGIC_VECTOR(            1 DOWNTO 0);
SIGNAL   SelectOutputBitSlice : STD_LOGIC;

SIGNAL   CarrySelect          : STD_LOGIC;
SIGNAL   ResultSelect         : STD_LOGIC_VECTOR(SelectorALU-1 DOWNTO 0);

SIGNAL   FinalResult          : STD_LOGIC_VECTOR(        NoB-1 DOWNTO 0);
SIGNAL   CarryOut             : STD_LOGIC; 
SIGNAL   Zeros                : STD_LOGIC;
SIGNAL   Negative             : STD_LOGIC;
SIGNAL   Overflow             : STD_LOGIC;

SIGNAL   Operating            : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

F(0)          <= Fc(4);

R             <= FinalResult;
D(1)          <= Zeros;
D(2)          <= CarryOut;
D(3)          <= Negative;
D(4)          <= Overflow;

SumInMultiply <= ResultBitSlice(NomB-1 DOWNTO 0);

OpCodes: ENTITY WORK.OpCodesLuT 
PORT MAP	  (OpCodes              => Fc(3 DOWNTO 0),
				MultiplyEnableSum    => MultiplyEnableSum,
				SignOutA             => SignOutA,
				Operating            => Operating,
				StartMultiplication  => StartMultiplication,
				SelectInputBitSliceA => SelectInputBitSliceA,
				SelectInputBitSliceB => SelectInputBitSliceB,
				SelectOutputBitSlice => SelectOutputBitSlice,
				SignA                => SignA,
				BitSliceOperSelect   => BitSliceOperSelect,
				CarrySelect          => CarrySelect,
				ResultSelect         => ResultSelect
			  );

WIXOSS: ENTITY WORK.SignalSelectors 
PORT MAP	  (SelectInputBitSliceA => SelectInputBitSliceA,
				SelectInputBitSliceB => SelectInputBitSliceB,
				A                    => A,
				B                    => B,
				SumOutA              => SumOutA,
				SumOutB              => SumOutB,
				SumInA               => SumInA,
				SumInB               => SumInB,
				ResultMultiplication => ResultMultiplication,
				ResultBitSliceFixed  => ResultBitSliceFixed,
				ResultSelect         => ResultSelect,
				ResultFinal          => FinalResult,
				CarryBitSlice        => CarryBitSlice,
				CarrySelect          => CarrySelect,
				CarryOut             => CarryOut,
				SelectOutputBitSlice => SelectOutputBitSlice,
				ResultBitSliceZrs    => ResultBitSliceFixed,
				ResultBitSlice       => ResultBitSlice,
				FinalResult          => FinalResult,
				Zeros                => Zeros,
				Negative             => Negative,
				OverFlow             => Overflow
			  );

MultiplicationModule: ENTITY WORK.Multiply 
PORT MAP	  (Reset     => F(0),
				Clk       => Clk,
				State     => S,
				Start     => StartMultiplication,
				Operating => Operating,
				EndFlag   => D(0),
				InA       => A(NomB-1 DOWNTO 0),
				InB       => B(NomB-1 DOWNTO 0),
				Mult      => ResultMultiplication,
				SumOutA   => SumOutA,
				SumOutB   => SumOutB,
				SumIn     => SumInMultiply,
				PstvNgtv  => SignOutA,
				EnableSum => MultiplyEnableSum
			  );

LogicAndSumModule: ENTITY WORK.BitSliceAlu 
PORT MAP	  (InA    => SumInA,
				InB    => SumInB,
				SignA  => SignA,
				SelOp  => BitSliceOperSelect,
				Result => ResultBitSlice,
				Carry  => CarryBitSlice
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.ArithmeticLogicUnit 
--PORT MAP	  (A   => SLV,
--				B   => SLV,
--				Fc  => SLV,
--				Clk => SLV,
--				S   => SLV,
--				D   => SLV,
--				R   => SLV
--			  );
--******************************************************--

END ArithmeticLogicUnitArch;