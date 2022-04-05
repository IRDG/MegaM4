--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:2019                         --
--******************************************************--
-- 													              --
---------------- Package: MyPackage.vhd ------------------
-- 													              --
--******************************************************--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE IEEE.math_real.ALL;

PACKAGE MyPackage IS
	
	CONSTANT Word        : INTEGER := 16;
	CONSTANT PcSize      : INTEGER := 11;
	CONSTANT AddressSize : INTEGER := 12;
	CONSTANT SpSize      : INTEGER := 10;
	CONSTANT SrSize      : INTEGER :=  8;
	
	
	
	CONSTANT NoB         : INTEGER := 16;   -- Numero de bits de entrada
	
	CONSTANT NomBSize    : INTEGER := 3;    -- tamagno el bus de NomB
	
	CONSTANT NomB        : INTEGER := 2**NomBSize;    -- NoB/2, usada en la multiplicacion 
	
	CONSTANT SelectorBS  : INTEGER := 2;  -- selector bit slice (suma resta or and y not)
	CONSTANT SelectorALU : INTEGER := 1;  -- selector alu (multiplicacion y bit slice)
	
	-- definen el total de entradas de los mux de la bit slice y de la alu
	
	CONSTANT NoOBS       : INTEGER := 2**SelectorBS; -- numeber of operations bit slice
	CONSTANT NoOALU      : INTEGER := 2**SelectorALU; -- number of operations alu 
	
	CONSTANT MaxCount    : STD_LOGIC_VECTOR(NomBSize-1 DOWNTO 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(NomB-1,NomBSize));
	
END PACKAGE MyPackage;

PACKAGE BODY MyPackage IS

END MyPackage;