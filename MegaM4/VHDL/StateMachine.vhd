
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

ENTITY StateMachine IS
	
	PORT	 (
				Start     : IN  STD_LOGIC;
				Qs        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
				Reset     : IN  STD_LOGIC;
				Clk       : IN  STD_LOGIC;
				State     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				ShiftEna  : OUT STD_LOGIC;
				EndFlag   : OUT STD_LOGIC;
				EnableQ   : OUT STD_LOGIC;
				EnableQm1 : OUT STD_LOGIC;
				EnableA   : OUT STD_LOGIC;
				EnableM   : OUT STD_LOGIC;
				PstvNgtv  : OUT STD_LOGIC;
				EnableSum : OUT STD_LOGIC;
				Operating : OUT STD_LOGIC;
				RegInput  : OUT STD_LOGIC
			 );
	
END ENTITY StateMachine;

ARCHITECTURE StateMachineArch OF StateMachine IS

TYPE StateType IS (Standby,DataLoad, AskNext,OperatePositive,OperateNegative,Shift,AskEnd,EndAlgorithm1,EndAlgorithm2);

SIGNAL   NextState        : StateType;
SIGNAL   PrevState        : StateType;

SIGNAL   Count            : STD_LOGIC_VECTOR(NomBSize-1 DOWNTO 0);
SIGNAL   EnableCounter    : STD_LOGIC;

SIGNAL   CounterDataReset : STD_LOGIC_VECTOR(NomBSize-1 DOWNTO 0);
SIGNAL   CounterDataLoad  : STD_LOGIC;

SIGNAL   PartialZeros     : STD_LOGIC_VECTOR(NomBSize-1 DOWNTO 0);
SIGNAL   CountZero        : STD_LOGIC;

CONSTANT Zeros            : STD_LOGIC_VECTOR(NomBSize-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

PartialZeros(0) <= Count(0);

ZerosAutentificator: FOR I IN 1 TO NomBSize-1 GENERATE
	
	PartialZeros(I) <= PartialZeros(I-1) OR Count(I);
	
END GENERATE ZerosAutentificator;

CountZero <= NOT PartialZeros(NomBSize-1);

Counter: ENTITY WORK.DownCounter 
GENERIC MAP(Size => NomBSize
			  )
PORT MAP	  (Enable   => EnableCounter,
				Data     => CounterDataReset,
				DataLoad => CounterDataLoad,
				Rst      => Reset,
				Clk      => Clk,
				Count    => Count
			  );

StateMemory: PROCESS (Reset, Clk)
BEGIN
	
	IF (Reset='1')THEN
		
		PrevState <= Standby;
		
	ELSIF (RISING_EDGE(Clk))THEN
		
		PrevState <= NextState;
		
	END IF;
	
END PROCESS StateMemory;

StateChange: PROCESS (PrevState,Start,Qs,Count)
BEGIN
	
	CASE PrevState IS
	----------------------------------------------------------
		WHEN Standby =>
			
			CounterDataReset <= Zeros;
			CounterDataLoad  <= '0';
			State            <= "000";
			
			ShiftEna         <= '0';
			EndFlag          <= '0';
			EnableQ          <= '0';
			EnableQm1        <= '0';
			EnableA          <= '0';
			EnableM          <= '0';
			PstvNgtv         <= '0';
			EnableSum        <= '0';
			EnableCounter    <= '0';
			
			Operating        <= '0';
			RegInput         <= '0';
			
			IF (Start='1')THEN
				
				NextState <= DataLoad;
				
			ELSE
				
				NextState <= Standby;
				
			END IF;
	----------------------------------------------------------
		WHEN DataLoad =>
			
			CounterDataReset <= MaxCount;
			CounterDataLoad  <= '1';
			State            <= "001";
			
			ShiftEna         <= '0';
			EndFlag          <= '0';
			EnableQ          <= '1';
			EnableQm1        <= '1';
			EnableA          <= '1';
			EnableM          <= '1';
			PstvNgtv         <= '0';
			EnableSum        <= '0';
			EnableCounter    <= '0';
			
			Operating        <= '1';
			RegInput         <= '1';
			
			NextState <= AskNext;
			
	----------------------------------------------------------
		WHEN AskNext =>
			
			CounterDataReset <= Zeros;
			CounterDataLoad  <= '0';
			State            <= "010";
			
			ShiftEna         <= '0';
			EndFlag          <= '0';
			EnableQ          <= '0';
			EnableQm1        <= '0';
			EnableA          <= '0';
			EnableM          <= '0';
			PstvNgtv         <= '0';
			EnableSum        <= '0';
			EnableCounter    <= '0';
			
			Operating        <= '1';
			RegInput         <= '0';
			
			IF (Qs="00")THEN
				
				NextState <= Shift;
				
			ELSIF(Qs="01")THEN
				
				NextState <= OperatePositive;
				
			ELSIF(Qs="10")THEN
				
				NextState <= OperateNegative;
				
			ELSIF(Qs="11")THEN
				
				NextState <= Shift;
				
			ELSE
				
				NextState <= DataLoad;
				
			END IF;
	----------------------------------------------------------
		WHEN OperatePositive =>
			
			CounterDataReset <= Zeros;
			CounterDataLoad  <= '0';
			State            <= "011";
			
			ShiftEna         <= '0';
			EndFlag          <= '0';
			EnableQ          <= '0';
			EnableQm1        <= '0';
			EnableA          <= '1';
			EnableM          <= '0';
			PstvNgtv         <= '0';
			EnableSum        <= '1';
			EnableCounter    <= '0';
			
			Operating        <= '1';
			RegInput         <= '0';
			
			NextState <= Shift;
			
	----------------------------------------------------------
		WHEN OperateNegative =>
			
			CounterDataReset <= Zeros;
			CounterDataLoad  <= '0';
			State            <= "100";
			
			ShiftEna         <= '0';
			EndFlag          <= '0';
			EnableQ          <= '0';
			EnableQm1        <= '0';
			EnableA          <= '1';
			EnableM          <= '0';
			PstvNgtv         <= '1';
			EnableSum        <= '1';
			EnableCounter    <= '0';
			
			Operating        <= '1';
			RegInput         <= '0';
			
			NextState <= Shift;
			
	----------------------------------------------------------
		WHEN Shift =>
			
			CounterDataReset <= Zeros;
			CounterDataLoad  <= '0';
			State            <= "101";
			
			ShiftEna         <= '1';
			EndFlag          <= '0';
			EnableQ          <= '0';
			EnableQm1        <= '0';
			EnableA          <= '0';
			EnableM          <= '0';
			PstvNgtv         <= '0';
			EnableSum        <= '0';
			EnableCounter    <= '0';
			
			Operating        <= '1';
			RegInput         <= '0';
			
			NextState <= AskEnd;
			
	----------------------------------------------------------
		WHEN AskEnd =>
			
			CounterDataReset <= Zeros;
			CounterDataLoad  <= '0';
			State            <= "110";
			
			ShiftEna         <= '0';
			EndFlag          <= '0';
			EnableQ          <= '0';
			EnableQm1        <= '0';
			EnableA          <= '0';
			EnableM          <= '0';
			PstvNgtv         <= '0';
			EnableSum        <= '0';
			EnableCounter    <= '1';
			
			Operating        <= '1';
			RegInput         <= '0';
			
			IF(CountZero='1')THEN
				
				NextState <= EndAlgorithm1;
				
			ELSE
				
				NextState <= AskNext;
				
			END IF;
	----------------------------------------------------------
		WHEN EndAlgorithm1 =>
			
			CounterDataReset <= Zeros;
			CounterDataLoad  <= '0';
			State            <= "111";
			
			ShiftEna         <= '0';
			EndFlag          <= '1';
			EnableQ          <= '0';
			EnableQm1        <= '0';
			EnableA          <= '0';
			EnableM          <= '0';
			PstvNgtv         <= '0';
			EnableSum        <= '0';
			EnableCounter    <= '0';
			
			Operating        <= '1';
			RegInput         <= '0';
			
			NextState <= EndAlgorithm2;
			
	----------------------------------------------------------
	WHEN EndAlgorithm2 =>
			
			CounterDataReset <= Zeros;
			CounterDataLoad  <= '0';
			State            <= "111";
			
			ShiftEna         <= '0';
			EndFlag          <= '1';
			EnableQ          <= '0';
			EnableQm1        <= '0';
			EnableA          <= '0';
			EnableM          <= '0';
			PstvNgtv         <= '0';
			EnableSum        <= '0';
			EnableCounter    <= '0';
			
			Operating        <= '1';
			RegInput         <= '0';
			
			NextState <= Standby;
			
	----------------------------------------------------------
	END CASE;
	
END PROCESS StateChange;

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK.StateMachine 
--PORT MAP	  (Start     => SLV,
--				Qs        => SLV,
--				Reset     => SLV,
--				Clk       => SLV,
--				State     => SLV,
--				ShiftEna  => SLV,
--				EndFlag   => SLV,
--				EnableQ   => SLV,
--				EnableQm1 => SLV,
--				EnableA   => SLV,
--				EnableM   => SLV,
--				PstvNgtv  => SLV,
--				EnableSum => SLV,
--				Operating => Operating,
--				RegInput  => SLV
--			  );
--******************************************************--

END StateMachineArch;