
--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:01 M:01 Y:2001                         --
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

ENTITY OpCodesLuT IS
	
	PORT	 (
				OpCodes              : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
				MultiplyEnableSum    : IN  STD_LOGIC;
				SignOutA             : IN  STD_LOGIC;
				Operating            : IN  STD_LOGIC;
				StartMultiplication  : OUT STD_LOGIC;
				SelectInputBitSliceA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				SelectInputBitSliceB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				SelectOutputBitSlice : OUT STD_LOGIC;
				SignA                : OUT STD_LOGIC;
				BitSliceOperSelect   : OUT STD_LOGIC_VECTOR( SelectorBS-1 DOWNTO 0);
				CarrySelect          : OUT STD_LOGIC;
				ResultSelect         : OUT STD_LOGIC_VECTOR(SelectorALU-1 DOWNTO 0)
			 );
	
END ENTITY OpCodesLuT;

ARCHITECTURE OpCodesLuTArch OF OpCodesLuT IS

SIGNAL SignPart1 : STD_LOGIC;
SIGNAL SignPart2 : STD_LOGIC;
SIGNAL SignPart3 : STD_LOGIC;

BEGIN

--******************************************************--
--       | OpC1 | OpC2 |
-- Suma  |  01  |  00  |
-- Resta |  01  |  01  |
-- 2sC   |  01  |  10  |
-- OR    |  00  |  00  |
-- AND   |  00  |  01  |
-- NOT   |  00  |  10  |
-- Mult  |  10  |  --  |
--******************************************************--

StartMultiplication     <=  OpCodes(3) AND (NOT OpCodes(2));

--******************************************************--
-- 
-- Codigos deseados para seleccionar la entrada a la BitSlice
-- 
--         | Value |
-- SumaStd |  00   | -> OpCode := 0100 OR 0101
-- SumaMlt |  01   | -> MultiplyEnableSum := 1
-- 2sComp  |  10   | -> OpCode := 0110
-- NA      |  11   |
-- 
--******************************************************--

SelectInputBitSliceA(0) <=      MultiplyEnableSum;
SelectInputBitSliceA(1) <= (NOT MultiplyEnableSum) AND ((NOT OpCodes(3)) AND OpCodes(2) AND      OpCodes(1)  AND (NOT OpCodes(0)));

SelectInputBitSliceB(0) <=      MultiplyEnableSum;
SelectInputBitSliceB(1) <= (NOT MultiplyEnableSum) AND ((NOT OpCodes(3)) AND OpCodes(2) AND      OpCodes(1)  AND (NOT OpCodes(0)));

SelectOutputBitSlice    <=      Operating;   -- 0 si estoy sumando o lo que sea 1 si va al multiplicador

SignPart1               <= (NOT MultiplyEnableSum) AND ((NOT OpCodes(3)) AND OpCodes(2) AND (NOT OpCodes(1)) AND (    OpCodes(0)));
SignPart2               <= (NOT MultiplyEnableSum) AND ((NOT OpCodes(3)) AND OpCodes(2) AND (    OpCodes(1)) AND (NOT OpCodes(0)));
SignPart3               <=      MultiplyEnableSum  AND       SignOutA;
SignA                   <=      SignPart1          OR        SignPart2   OR  SignPart3;

--******************************************************--
-- 
-- BitSliceCodes
-- 
--       | BsCd |
-- Suma  |  00  |
-- OR    |  01  |
-- And   |  10  |
-- Not   |  11  |
-- 
-- La BitSliceRecibira el codigo de Suma por defecto
-- 
--******************************************************--

BitSliceOperSelect(0)   <= (NOT MultiplyEnableSum) AND (NOT OpCodes(3)) AND (NOT OpCodes(2)) AND (NOT OpCodes(0));
BitSliceOperSelect(1)   <= (NOT MultiplyEnableSum) AND (NOT OpCodes(3)) AND (NOT OpCodes(2)) AND (    OpCodes(1) XOR OpCodes(0));

--******************************************************--
-- 
-- La Anterior seccion (BitSliceOperSelect) no esta hecha de manera generica
-- 
--******************************************************--

CarrySelect             <= MultiplyEnableSum;

ResultSelect(0)         <= Operating;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.OpCodesLuT 
--PORT MAP	  (OpCodes              => SLV,
--				MultiplyEnableSum    => SLV,
--				SignOutA             => SLV,
--				Operating            => Operating
--				StartMultiplication  => SLV,
--				SelectInputBitSliceA => SLV,
--				SelectInputBitSliceB => SLV,
--				SelectOutputBitSlice => SLV,
--				SignA                => SLV,
--				BitSliceOperSelect   => SLV,
--				CarrySelect          => SLV,
--				ResultSelect         => SLV
--			  );
--******************************************************--

END OpCodesLuTArch;