
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

USE WORK.MyPackage.ALL;

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY BitSlice IS
	
	PORT	 (
				InA   : IN  STD_LOGIC;
				InB   : IN  STD_LOGIC;
				InC   : IN  STD_LOGIC;
				SignA : IN  STD_LOGIC;
				SelOp : IN  STD_LOGIC_VECTOR(SelectorBS-1 DOWNTO 0);
				OpOut : OUT STD_LOGIC;
				Carry : OUT STD_LOGIC
			 );
	
END ENTITY BitSlice;

ARCHITECTURE BitSliceArch OF BitSlice IS

SIGNAL Input     : STD_LOGIC_VECTOR(NoOBS-1 DOWNTO 0);
SIGNAL SgnA      : STD_LOGIC;
SIGNAL CarryTemp : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

SgnA <= InA XOR SignA;

WITH SelOp SELECT
Carry <= CarryTemp WHEN "00",
			'0'       WHEN OTHERS;

Logic: ENTITY WORK.LogicFunctions 
PORT MAP	  (InA    => InA,
				InB    => InB,
				OrOut  => Input(1),
				AndOut => Input(2),
				NotOut => Input(3)
			  );

FA: ENTITY WORK.FullAdder 
PORT MAP	  (InA  => SgnA,
				InB  => InB,
				InC  => InC,
				OutS => Input(0),
				OutC => CarryTemp
			  );

Mux: ENTITY WORK.GralMux 
GENERIC MAP(NoI => NoOBS,
	  			NoS => SelectorBS
			  )
PORT MAP	  (Input    => Input,
				Selector => SelOp,
				Output   => OpOut
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.BitSlice 
--PORT MAP	  (InA   => SLV,
--				InB   => SLV,
--				InC   => SLV,
--				SignA => SLV,
--				SelOp => SLV,
--				OpOut => SLV,
--				Carry => SLV
--			  );
--******************************************************--

END BitSliceArch;