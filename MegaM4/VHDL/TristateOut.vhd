
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

ENTITY TristateOut IS									-- Declaracion Entidad Tristate de Salida
	
	GENERIC(
				DataLength: INTEGER := 7				-- Longitud de los Datos
			 );
	PORT	 (
				MyIn  : INOUT STD_LOGIC_VECTOR(DataLength-1 DOWNTO 0);	-- Dato de entrada
				Sel   : IN    STD_LOGIC;				                     -- Opcion de entrada o salida
				MyOut : OUT   STD_LOGIC_VECTOR(DataLength-1 DOWNTO 0)	   -- Dato de salida
			 );
	
END ENTITY TristateOut;

ARCHITECTURE TristateOutArch OF TristateOut IS

SIGNAL HighZ : STD_LOGIC_VECTOR(DataLength-1 DOWNTO 0):= (OTHERS => 'Z');		-- Segnal de Alta Impedancia

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

WITH Sel SELECT										-- Opcion de Direccion
MyOut <= MyIn  WHEN '1',							-- Opcion de Salida
			HighZ WHEN OTHERS;						-- Opcion de Entrada

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.TristateOut 
--GENERIC MAP(DataLength => #
--			  )
--PORT MAP	  (MyIn  => SLV,
--				Sel   => SLV,
--				MyOut => SLV
--			  );
--******************************************************--

END TristateOutArch;