
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

ENTITY Multiply IS
	
	PORT	 (
				Reset     : IN  STD_LOGIC;
				Clk       : IN  STD_LOGIC;
				
				Start     : IN  STD_LOGIC;
				Operating : OUT STD_LOGIC;
				EndFlag   : OUT STD_LOGIC;
				
				InA       : IN  STD_LOGIC_VECTOR(NomB-1 DOWNTO 0);
				InB       : IN  STD_LOGIC_VECTOR(NomB-1 DOWNTO 0);
				Mult      : OUT STD_LOGIC_VECTOR(NoB -1 DOWNTO 0);
				
				SumOutA   : OUT STD_LOGIC_VECTOR(NomB-1 DOWNTO 0); -- este es el que se puede hacer negativo en la bitslice
				SumOutB   : OUT STD_LOGIC_VECTOR(NomB-1 DOWNTO 0);
				SumIn     : IN  STD_LOGIC_VECTOR(NomB-1 DOWNTo 0);
				
				State     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				
				PstvNgtv  : OUT STD_LOGIC;
				EnableSum : OUT STD_LOGIC
			 );
	
END ENTITY Multiply;

ARCHITECTURE MultiplyArch OF Multiply IS

SIGNAL EnableA        : STD_LOGIC;
SIGNAL EnableQm1      : STD_LOGIC;
SIGNAL EnableQ        : STD_LOGIC;
SIGNAL EnableM        : STD_LOGIC;

SIGNAL ShiftEna       : STD_LOGIC;
SIGNAL Qs             : STD_LOGIC_VECTOR(1 DOWNTO 0);

SIGNAL AQ             : STD_LOGIC_VECTOR(NomB-1 DOWNTO 0);
SIGNAL AD             : STD_LOGIC_VECTOR(NomB-1 DOWNTO 0);

SIGNAL QQ             : STD_LOGIC_VECTOR(NomB-1 DOWNTO 0);
SIGNAL QD             : STD_LOGIC_VECTOR(NomB-1 DOWNTO 0);

SIGNAL MQ             : STD_LOGIC_VECTOR(NomB-1 DOWNTO 0);
SIGNAL MD             : STD_LOGIC_VECTOR(NomB-1 DOWNTO 0);

SIGNAL Qm1D           : STD_LOGIC;
SIGNAL EQm1           : STD_LOGIC;
SIGNAL Qm1Q           : STD_LOGIC;

SIGNAL ShiftData      : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL EndFlagSignal  : STD_LOGIC;
SIGNAL RegInput       : STD_LOGIC;

SIGNAL ComposedResult : STD_LOGIC_VECTOR(NoB -1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

ComposedResult(NomB-1 DOWNTO    0) <= QQ;
ComposedResult(NoB -1 DOWNTO NomB) <= AQ;

MD <= InA;
QD <= InB;

WITH RegInput SELECT
AD <= SumIn      WHEN '0',
		"00000000" WHEN OTHERS;

SumOutA <= MQ;
SumOutB <= AQ;

Qs(0)   <= Qm1Q;
Qs(1)   <= QQ(0);


WITH RegInput SELECT
Qm1D <= ShiftData(0) WHEN '0',
		  '0'          WHEN OTHERS;

EndFlag <= EndFlagSignal;

EQm1    <= EnableQm1 OR ShiftEna;

Control: ENTITY WORK.StateMachine 
PORT MAP	  (Start     => Start,
				Qs        => Qs,
				Reset     => Reset,
				Clk       => Clk,
				State     => State,
				ShiftEna  => ShiftEna,
				EndFlag   => EndFlagSignal,
				EnableQ   => EnableQ,
				EnableQm1 => EnableQm1,
				EnableA   => EnableA,
				EnableM   => EnableM,
				PstvNgtv  => PstvNgtv,
				EnableSum => EnableSum,
				Operating => Operating,
				RegInput  => RegInput
			  );

AndS: ENTITY WORK.AndsBlock 
PORT MAP	  (SignalA => EndFlagSignal,
				SignalB => ComposedResult,
				Result  => Mult
			  );

Qm1: ENTITY WORK.FlipFlop 
PORT MAP	  (D    => Qm1D,
				Q    => Qm1Q,
				Ena  => EQm1,
				Clk  => Clk,
				Rst  => Reset,
				Set  => '0'
			  );

M: ENTITY WORK.GralRegister
GENERIC MAP(DataSize    => NomB,
				AddressSize => 1
			  )
PORT MAP	  (DataIn  => MD,
				Enable  => EnableM,
				Address => "1",
				Rst     => Reset,
				Clk     => Clk,
				DataOut => MQ
			  );

Q: ENTITY WORK.ShiftRegister 
GENERIC MAP(DataSize => NomB
			  )
PORT MAP	  (DataIn      => QD,
				Enable      => EnableQ,
				Cin         => ShiftData(1),
				ShiftLRN    => '0',
				EnableShift => ShiftEna,
				Cout        => ShiftData(0),
				Rst         => Reset,
				Clk         => Clk,
				DataOut     => QQ
			  );

A: ENTITY WORK.ArithmeticShiftRegister 
GENERIC MAP(DataSize => NomB
			  )
PORT MAP	  (DataIn      => AD,
				Enable      => EnableA,
				ShiftLRN    => '0',
				EnableShift => ShiftEna,
				Cout        => ShiftData(1),
				Rst         => Reset,
				Clk         => Clk,
				DataOut     => AQ
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.Multiply 
--PORT MAP	  (Reset     => SLV,
--				Clk       => SLV,
--				Start     => SLV,
--				Operating => Operating,
--				EndFlag   => SLV,
--				InA       => SLV,
--				InB       => SLV,
--				Mult      => SLV,
--				SumOutA   => SLV,
--				SumOutB   => SLV,
--				SumIn     => SLV,
--				PstvNgtv  => SLV,
--				EnableSum => SLV,
--				State     => SLV
--			  );
--******************************************************--

END MultiplyArch;