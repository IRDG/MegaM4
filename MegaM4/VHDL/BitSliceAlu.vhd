
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

ENTITY BitSliceAlu IS
	
	PORT	 (
				InA    : IN  STD_LOGIC_VECTOR(NoB-1 DOWNTO 0);
				InB    : IN  STD_LOGIC_VECTOR(NoB-1 DOWNTO 0);
				SignA  : IN  STD_LOGIC;
				SelOp  : IN  STD_LOGIC_VECTOR(SelectorBS-1 DOWNTO 0);
				Result : OUT STD_LOGIC_VECTOR(NoB-1 DOWNTO 0);
				Carry  : OUT STD_LOGIC
			 );
	
END ENTITY BitSliceAlu;

ARCHITECTURE BitSliceAluArch OF BitSliceAlu IS

SIGNAL InnerCarry : STD_LOGIC_VECTOR(NoB-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

Carry <= InnerCarry(NoB-1);

BS0: ENTITY WORK.BitSlice 
PORT MAP	  (InA   => InA(0),
				InB   => InB(0),
				InC   => SignA,
				SignA => SignA,
				SelOp => SelOp,
				OpOut => Result(0),
				Carry => InnerCarry(0)
			  );

BitSliceAluGenerator: FOR I IN 1 TO NoB-1 GENERATE
	
	BSn: ENTITY WORK.BitSlice 
	PORT MAP	  (InA   => InA(I),
					InB   => InB(I),
					InC   => InnerCarry(I-1),
					SignA => SignA,
					SelOp => SelOp,
					OpOut => Result(I),
					Carry => InnerCarry(I)
				  );
	
END GENERATE BitSliceAluGenerator;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.BitSliceAlu 
--PORT MAP	  (InA    => SLV,
--				InB    => SLV,
--				SignA  => SLV,
--				SelOp  => SLV,
--				Result => SLV,
--				Carry  => SLV
--			  );
--******************************************************--

END BitSliceAluArch;