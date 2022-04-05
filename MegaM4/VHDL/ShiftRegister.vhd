
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

ENTITY ShiftRegister IS
	
	GENERIC(
				DataSize    : INTEGER := 8
			 );
	PORT	 (
				DataIn      : IN  STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
				Enable      : IN  STD_LOGIC;
				Cin         : IN  STD_LOGIC;
				ShiftLRN    : IN  STD_LOGIC;   
				EnableShift : IN  STD_LOGIC;
				Cout        : OUT STD_LOGIC;
				Rst         : IN  STD_LOGIC;
				Clk         : IN  STD_LOGIC;
				DataOut     : OUT STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0)
			 );
	
END ENTITY ShiftRegister;

ARCHITECTURE ShiftRegisterArch OF ShiftRegister IS

SIGNAL EnableRegister : STD_LOGIC;

SIGNAL RegisterD      : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);
SIGNAL RegisterQ      : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);

SIGNAL SelectAction   : STD_LOGIC_VECTOR(         1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

SelectAction(0) <= (Enable AND EnableShift)OR((NOT Enable) AND      ShiftLRN)OR ((NOT Enable) AND (NOT EnableShift) AND (NOT ShiftLRN));
SelectAction(1) <= (Enable AND EnableShift)OR((NOT Enable) AND (NOT(ShiftLRN AND      EnableShift)));

EnableRegister <= EnableShift OR Enable;

DataOut <= RegisterQ;

WITH SelectAction SELECT
RegisterD(0) <= DataIn(0)    WHEN "00",
				    Cin          WHEN "01",
				    RegisterQ(1) WHEN "10",
			       RegisterQ(0) WHEN OTHERS;

MuxGenerator: FOR I IN 1 TO DataSize-2 GENERATE
	
	WITH SelectAction SELECT
	RegisterD(I) <= DataIn(I)      WHEN "00",
					    RegisterQ(I-1) WHEN "01",
					    RegisterQ(I+1) WHEN "10",
				       RegisterQ(I)   WHEN OTHERS;
	
END GENERATE MuxGenerator;

WITH SelectAction SELECT
RegisterD(DataSize-1) <= DataIn(DataSize-1)    WHEN "00",
								 RegisterQ(DataSize-2) WHEN "01",
								 Cin                   WHEN "10",
								 RegisterQ(DataSize-1) WHEN OTHERS;

WITH SelectAction SELECT
Cout <= '0'                   WHEN "00",
		  RegisterQ(DataSize-1) WHEN "01",
		  RegisterQ(0)          WHEN "10",
		  '0'                   WHEN OTHERS;

Reg: ENTITY WORK.GralRegister
GENERIC MAP(DataSize    => DataSize,
				AddressSize => 1
			  )
PORT MAP	  (DataIn  => RegisterD,
				Enable  => EnableRegister,
				Address => "1",
				Rst     => Rst,
				Clk     => Clk,
				DataOut => RegisterQ
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.ShiftRegister 
--GENERIC MAP(DataSize => #
--			  )
--PORT MAP	  (DataIn      => SLV,
--				Enable      => SLV,
--				Cin         => SLV,
--				ShiftLRN    => SLV,
--				EnableShift => SLV,
--				Cout        => SLV,
--				Rst         => SLV,
--				Clk         => SLV,
--				DataOut     => SLV
--			  );
--******************************************************--

END ShiftRegisterArch;