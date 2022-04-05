
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
USE IEEE.numeric_std.all;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

--******************************************************--
-- Comentarios:
-- 
-- VHDL para definir uin registro de tamagno DataSize x 
-- RegisterSize
-- 
-- DataSize define el tamagno de los datos en bits
-- 
-- RegisterSize define el numero de datos que se tienen
-- 
-- AddressSize define el tamagno del bus de direcciones
-- para poder acceder a todos los datos guardados
-- 
-- RegisterSize = 2**AddressSize 
-- 
-- La direccion Address, define la posicion de escritura
-- en el registro, pero tambien 	que datos se van a leer
-- 
-- Para escribir datos es necesario poner un Address
-- valido (en el rango definido por AddressSize) y poner
-- el valor de Enable en 1. No es necesario el enable para
-- leer datos del registro.
-- 
-- Rst reinicia todos los valores del registro a 0, se
-- activa poniendo un 1 en este pin de entrada
-- 
--******************************************************--

ENTITY GralRegister IS
	
	GENERIC(
				DataSize    : INTEGER := 8;
				AddressSize : INTEGER := 1
			 );
	PORT	 (
				DataIn  : IN  STD_LOGIC_VECTOR(DataSize-1    DOWNTO 0);
				Enable  : IN  STD_LOGIC;
				Address : IN  STD_LOGIC_VECTOR(AddressSize-1 DOWNTO 0);
				Rst     : IN  STD_LOGIC;
				Clk     : IN  STD_LOGIC;
				DataOut : OUT STD_LOGIC_VECTOR(DataSize-1    DOWNTO 0)
			 );
	
END ENTITY GralRegister;

ARCHITECTURE GralRegisterArch OF GralRegister IS

CONSTANT RegisterSize : INTEGER := 2**AddressSize;

--******************************************************--
--  0 1 2 3 ... DataSize-1 
-- 0
-- 1
-- 2
-- ...
-- RegisterSize-1
--
--******************************************************--

TYPE Matrix IS ARRAY (0 TO RegisterSize-1) OF STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0);

CONSTANT Zeros   : STD_LOGIC_VECTOR(DataSize-1 DOWNTO 0) := (OTHERS => '0');

CONSTANT Reset   : Matrix := (OTHERS => Zeros);

SIGNAL Q         : Matrix;

SIGNAL AddressI  : INTEGER;

SIGNAL AddressOk : STD_LOGIC;

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

AddressI <= TO_INTEGER(UNSIGNED(Address));

Reg:PROCESS(Clk, DataIn)

BEGIN
	IF(Rst='1')THEN
		
		Q <= Reset;
		
	ELSIF(rising_edge(Clk)) THEN
		
		IF((Enable ='1')AND(AddressOk='1')) THEN
			
			Q(AddressI)(DataSize-1 DOWNTO 0) <= DataIn;
			
		END IF;
		
	END IF;
	
END PROCESS Reg;

AddressOk <= '1' WHEN (AddressI<RegisterSize)
					  ELSE '0';

WITH AddressOk SELECT
DataOut <= Q(AddressI)(DataSize-1 DOWNTO 0) WHEN '1',
			  Zeros                            WHEN OTHERS;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.GralRegister
--GENERIC MAP(DataSize    => #,
--				AddressSize => #
--			  )
--PORT MAP	  (DataIn  => SLV,
--				Enable  => SLV,
--				Address => SLV,
--				Rst     => SLV,
--				Clk     => SLV,
--				DataOut => SLV
--			  );
--******************************************************--

END GralRegisterArch;