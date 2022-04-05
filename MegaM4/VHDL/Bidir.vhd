
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

--******************************************************--
-- Comentarios:
-- 
-- 
--******************************************************--

ENTITY Bidir IS										-- Declaracion Entidad Union Tristate (Cable Bidireccional de Alta Impedancia)
	
	GENERIC(
				DataLength: INTEGER := 16					-- Longitud de los datos
			 );
	PORT	 (
				DataIn     : IN    STD_LOGIC_VECTOR(DataLength-1 DOWNTO 0);	-- Dato de Entrada
				SelectMode : IN    STD_LOGIC_VECTOR(           1 DOWNTO 0);	-- Control de Direccion
				DataOut    : OUT   STD_LOGIC_VECTOR(DataLength-1 DOWNTO 0);	-- Dato de Salida
				DataInOut  : INOUT STD_LOGIC_VECTOR(DataLength-1 DOWNTO 0)	-- Dato que Puede Ser Entrada/Salida
			 );
	
END ENTITY Bidir;

ARCHITECTURE BidirArch OF Bidir IS

SIGNAL SelectModeGud : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH SelectMode SELECT
SelectModeGud <=       "00" WHEN "11",
                 SelectMode WHEN OTHERS;

T1: ENTITY WORK.TristateIN
GENERIC MAP(DataLength => DataLength
			  )
PORT MAP	  (MyIn  => DataIn,								-- Dato de Entrada Al Bus de Entrada
				Sel   => SelectModeGud(0),					-- Opcion del Selector
				MyOut => DataInOut						   -- Dato Entrada/Salida Al Bus de Salida
			  );

T2: ENTITY WORK.TristateOut
GENERIC MAP(DataLength => DataLength
			  )
PORT MAP	  (MyIn  => DataInOut,							-- Datos Entrada/Salida Al Bus de Entrada
				Sel   => SelectModeGud(1),	   			-- Opcion del Selector
				MyOut => DataOut						      -- Dato de Salida Al Bus de Salida
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Bidir 
--GENERIC MAP(DataLength => Word
--			  )
--PORT MAP	  (DataIn     => SLV,
--				SelectMode => SLV,
--				DataOut    => SLV,
--				DataInOut  => SLV
--			  );
--******************************************************--

END BidirArch;