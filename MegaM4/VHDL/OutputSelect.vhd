
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

ENTITY OutputSelect IS
	
	PORT	 (
				MarIn    : IN  STD_LOGIC_VECTOR(AddressSize-1 DOWNTO 0);
				SpIn     : IN  STD_LOGIC_VECTOR(     SpSize-1 DOWNTO 0);
				PcIn     : IN  STD_LOGIC_VECTOR(     PcSize-1 DOWNTO 0);
				Selector : IN  STD_LOGIC_VECTOR(            2 DOWNTO 0);
				Address  : OUT STD_LOGIC_VECTOR(AddressSize-1 DOWNTO 0)
			 );
	
END ENTITY OutputSelect;

ARCHITECTURE OutputSelectArch OF OutputSelect IS

CONSTANT ZeroSp : STD_LOGIC_VECTOR(AddressSize-SpSize-1 DOWNTO 0) := (OTHERS=>'0');
CONSTANT ZeroPc : STD_LOGIC_VECTOR(AddressSize-PcSize-1 DOWNTO 0) := (OTHERS=>'0');

SIGNAL   SpT    : STD_LOGIC_VECTOR(     AddressSize-1 DOWNTO 0);
SIGNAL   PcT    : STD_LOGIC_VECTOR(     AddressSize-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

SpT <= ZeroSp & SpIn;
PcT <= ZeroPc & PcIn;

WITH Selector SELECT
Address <= SpT   WHEN "100",
			  PcT   WHEN "010",
			  MarIn WHEN "001",
			  MarIn WHEN OTHERS;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.OutputSelect 
--PORT MAP	  (MarIn    => SLV,
--				SpIn     => SLV,
--				PcIn     => SLV,
--				Selector => SLV,
--				Address  => SLV
--			  );
--******************************************************--

END OutputSelectArch;