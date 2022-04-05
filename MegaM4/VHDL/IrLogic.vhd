
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

ENTITY IrLogic IS
	
	PORT	 (
				IrLIn  : IN  STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
				IrIn   : IN  STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
				IrSel  : IN  STD_LOGIC;
				IrXOut : OUT STD_LOGIC_VECTOR(Word-1 DOWNTO 0)
			 );
	
END ENTITY IrLogic;

ARCHITECTURE IrLogicArch OF IrLogic IS

SIGNAL IrInT       : STD_LOGIC_VECTOR(Word-1 DOWNTO 0);
SIGNAL InnerSelect : STD_LOGIC_VECTOR(     2 DOWNTO 0);

BEGIN

--******************************************************--
-- 0001 X0
-- 0000 1
-- 0101 X0X0
-- 
--******************************************************--

InnerSelect(0) <= (NOT IrIn(15)) AND (NOT IrIn(14)) AND (NOT IrIn(13)) AND (    IrIn(12)) AND (NOT IrIn(10));
InnerSelect(1) <= (NOT IrIn(15)) AND (NOT IrIn(14)) AND (NOT IrIn(13)) AND (NOT IrIn(12)) AND (    IrIn(11));
InnerSelect(2) <= (NOT IrIn(15)) AND (    IrIn(14)) AND (NOT IrIn(13)) AND (    IrIn(12)) AND (NOT IrIn(10)) AND (NOT IrIn( 8));


WITH InnerSelect SELECT
IrInT <= (IrIn( 9) & IrIn( 9) & IrIn( 9) & IrIn( 9) & IrIn( 9) & IrIn( 9)) & IrIn( 9 DOWNTO 0) WHEN "010",
         (IrIn(10) & IrIn(10) & IrIn(10) & IrIn(10) & IrIn(10)           ) & IrIn(10 DOWNTO 0) WHEN "001",
			("0000"   & IrIn( 7) & IrIn( 7) & IrIn( 7) & IrIn( 7)           ) & IrIn( 7 DOWNTO 0) WHEN "100",
			                                                                    IrIn(15 DOWNTO 0) WHEN OTHERS;

WITH IrSel SELECT
IrXOut <= IrLIn WHEN '1',
			 IrInT WHEN '0',
			 IrInT WHEN OTHERS;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.IrLogic 
--PORT MAP	  (IrLIn  => SLV,
--				IrIn   => SLV,
--				IrSel  => SLV,
--				IrXOut => SLV,
--			  );
--******************************************************--

END IrLogicArch;