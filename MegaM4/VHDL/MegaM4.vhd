
--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:20XX                         --
--******************************************************--

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
LIBRARY ALTERA;
USE ALTERA.altera_primitives_components.all;

USE WORK.MyPackage.ALL;

--**********************************************************************************--
-- Comentarios :																						   --
-- Bloque de Proyecto delprocesador llamado MegaM4, que contiene  --
-- la declaracion de todos los bloques internos necesarios para el procesador       --
-- y las señales, tanto internas como de entrada salida del sistema					   --														                     		 --
--**********************************************************************************--

ENTITY  MegaM4 IS
	
	PORT	 (
				Clk     : IN    STD_LOGIC;
				Rst     : IN    STD_LOGIC;		
				DataRom : IN    STD_LOGIC_VECTOR(15 downto 0);										-- Señal de datos de entrada de la memoria ROM
				IRQ     : IN    STD_LOGIC_VECTOR( 3 downto 0);										-- Señal de entrada de los perifericos
				
				DataRwm : INOUT STD_LOGIC_VECTOR(15 downto 0);										-- Señal de entrada de datos
				
				ACK     : OUT   STD_LOGIC_VECTOR( 1 downto 0);										-- Señal de salidapara atender un periferico
				RNW     : OUT   STD_LOGIC;																	-- Señal de lectura escritura de la RWN, 0 = lectura, 1 = escritura 
				Address : OUT   STD_LOGIC_VECTOR(11 downto 0);										-- Señal de salida de dirección para las memorias o perifericos
			   State   : OUT   STD_LOGIC_VECTOR( 6 downto 0);										-- Qs de la maquINa de estados para conocer el estado actual
				ClkOut  : OUT   STD_LOGIC																	-- Señal de salida del reloj para ser analizado el sistema
			 );
	
END ENTITY  MegaM4;

ARCHITECTURE  MegaM4Arch OF  MegaM4 IS

SIGNAL Control_RegistrosReset : STD_LOGIC;

SIGNAL Control_MAR            : STD_LOGIC_VECTOR(            2 DOWNTO 0);
SIGNAL Control_OutputSelector : STD_LOGIC_VECTOR(            2 DOWNTO 0);
SIGNAL Control_IR             : STD_LOGIC;
SIGNAL Control_PC             : STD_LOGIC_VECTOR(            5 DOWNTO 0);
SIGNAL Control_IRL            : STD_LOGIC;
SIGNAL Control_Bidir          : STD_LOGIC_VECTOR(            1 DOWNTO 0);
SIGNAL Control_Acc1           : STD_LOGIC_VECTOR(            4 DOWNTO 0);
SIGNAL ShiftEnableAcc1        : STD_LOGIC;
SIGNAL ArShiftEnableAcc1      : STD_LOGIC;
SIGNAL LrN                    : STD_LOGIC;
SIGNAL Control_Acc2           : STD_LOGIC_VECTOR(            4 DOWNTO 0);
SIGNAL ShiftEnableAcc2        : STD_LOGIC;
SIGNAL ArShiftEnableAcc2      : STD_LOGIC;
SIGNAL IRSelect               : STD_LOGIC;
SIGNAL Control_MDR            : STD_LOGIC_VECTOR(            7 DOWNTO 0);
SIGNAL Control_Registros      : STD_LOGIC_VECTOR(            2 DOWNTO 0);
SIGNAL Control_CR             : STD_LOGIC_VECTOR(            1 DOWNTO 0);
SIGNAL MiniCount              : STD_LOGIC_VECTOR(            1 DOWNTO 0);
SIGNAL Control_SR             : STD_LOGIC_VECTOR(            5 DOWNTO 0);
SIGNAL Control_ALU            : STD_LOGIC_VECTOR(            3 DOWNTO 0);
SIGNAL Control_SP             : STD_LOGIC_VECTOR(            1 DOWNTO 0);
SIGNAL Qs                     : STD_LOGIC_VECTOR(           85 DOWNTO 0);

SIGNAL F4Alu                  : STD_LOGIC_VECTOR(            4 DOWNTO 0);

SIGNAL Acc1Data               : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);
SIGNAL Acc2Data               : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);
SIGNAL AluResult              : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);
SIGNAL AluData                : STD_LOGIC_VECTOR(            4 DOWNTO 0);
SIGNAL PcCount                : STD_LOGIC_VECTOR(     PcSize-1 DOWNTO 0);
SIGNAL MdrData                : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);
SIGNAL SpData                 : STD_LOGIC_VECTOR(     SpSize-1 DOWNTO 0);
SIGNAL RegisterData           : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);
SIGNAL MarData                : STD_LOGIC_VECTOR(AddressSize-1 DOWNTO 0);
SIGNAL CrData                 : STD_LOGIC_VECTOR(            3 DOWNTO 0);
SIGNAL SrData                 : STD_LOGIC_VECTOR(     SrSize-1 DOWNTO 0);
SIGNAL IrData                 : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);
SIGNAL IrIrlData              : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);
SIGNAL IrlData                : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);
SIGNAL BidirData              : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);

SIGNAL SrData16               : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);
SIGNAL PcCount16              : STD_LOGIC_VECTOR(       Word-1 DOWNTO 0);

BEGIN

--******************************************************--
-- 
-- 
-- 
--******************************************************--

SrData16  <=   SrData(7)   & SrData(7)   & SrData(7)   & SrData(7)  
             & SrData(7)   & SrData(7)   & SrData(7)   & SrData(7)   &  SrData(SrSize-1 DOWNTO 0);
PcCount16 <=   PcCount(10) & PcCount(10) & PcCount(10) & PcCount(10) & PcCount(10) & PcCount(PcSize-1 DOWNTO 0);
F4Alu <= Control_ALU & Rst;

ClkOut <= Clk;

ST: ENTITY WORK.StateTransform 
PORT MAP	  (Qs    => Qs,
				State => State
			  );

ControlUnit: ENTITY WORK.Control 
PORT MAP	  (Reloj                  => Clk,
				ResetN                 => Rst,
				Cr                     => CrData,
				Sr                     => SrData,
				Irq                    => IRQ,
				Ir                     => IrData,
				--Salidas
				Control_RegistrosReset => Control_RegistrosReset,
				Control_MAR            => Control_MAR,
				Control_OutputSelector => Control_OutputSelector,
				Control_IR             => Control_IR,
				Control_PC				  => Control_PC,
				Control_IRL				  => Control_IRL,
				RNW						  => RNW,
				Control_Bidir			  => Control_Bidir,
				Control_Acc1			  => Control_Acc1,
				ShiftEnableAcc1		  => ShiftEnableAcc1,
				ArShiftEnableAcc1		  => ArShiftEnableAcc1,
				LrnAcc					  => LrN,
				Control_Acc2			  => Control_Acc2,
				ShiftEnableAcc2		  => ShiftEnableAcc2,
				ArShiftEnableAcc2		  => ArShiftEnableAcc2,
				IRSelect					  => IRSelect,
				Control_MDR				  => Control_MDR,
				Control_Registros		  => Control_Registros,
				Control_CR				  => Control_CR,
				MiniCount				  => MiniCount,
				Control_SR				  => Control_SR,
				Control_ALU				  => Control_ALU,
				Control_SP				  => Control_SP,
				Ack        				  => ACK,
		      Qs 						  => Qs
			  );

StatusRegister: ENTITY WORK.Sr
GENERIC MAP(DataSize    => 8
			  )
PORT MAP	  (MdrData   => MdrData(4 DOWNTO 0),
				AluData   => AluData,
				Selector  => Control_SR(2 DOWNTO 1),
				CtrlInt   => Control_SR(5 DOWNTO 4),
				IntEnable => Control_SR(3),
				Enable    => Control_SR(0),
				Rst       => Control_RegistrosReset,
				Clk       => Clk,
				SrData    => SrData
			  );

StackPointer: ENTITY WORK.Sp 
GENERIC MAP(Size => SpSize
			  )
PORT MAP	  (Enable       => Control_SP(0),
				UpDownN      => Control_SP(1),
				Rst          => Control_RegistrosReset,
				Clk          => Clk,
				StackPointer => SpData
			  );

Reg: ENTITY WORK.Registers
GENERIC MAP(DataSize   => Word,
				RpgAddress => 5
			  )
PORT MAP	  (Acc1Data => Acc1Data,
				Acc2Data => Acc2Data,
				SelectIn => Control_Registros(2 DOWNTO 1),
				RAddress => IrIrlData        (8 DOWNTO 4),
				Enable   => Control_Registros(0),
				Rst      => Control_RegistrosReset,
				Clk      => Clk,
				DataOut  => RegisterData
			  );

Os: ENTITY WORK.OutputSelect 
PORT MAP	  (MarIn    => MarData,
				SpIn     => SpData,
				PcIn     => PcCount,
				Selector => Control_OutputSelector,
				Address  => Address
			  );

MemoryDataRegister: ENTITY WORK.Mdr
GENERIC MAP(DataSize    => Word
			  )
PORT MAP	  (SrData   => SrData16,
				Acc1Data => Acc1Data,
				Acc2Data => Acc2Data,
				PcCount  => PcCount16,
				IrData   => IrIrlData,
				BidirIn  => BidirData,
				MarIn    => MarData,
				SelectIn => Control_MDR(7 DOWNTO 1),
				Enable   => Control_MDR(0),
				Rst      => Control_RegistrosReset,
				Clk      => Clk,
				MdrOut   => MdrData
			  );

MemoryAddressRegister: ENTITY WORK.Mar
GENERIC MAP(DataSize    => AddressSize
			  )
PORT MAP	  (IrIn     => IrIrlData  (11 DOWNTO 0), --IR
				MdrIn    => MdrData    (11 DOWNTO 0),
				SelectIn => Control_MAR( 2 DOWNTO 1),
				Enable   => Control_MAR( 0),
				Rst      => Control_RegistrosReset,
				Clk      => Clk,
				MarData  => MarData
			  );

LogicIr: ENTITY WORK.IrLogic 
PORT MAP	  (IrLIn  => IrlData,
				IrIn   => IrData,
				IrSel  => IRSelect,
				IrXOut => IrIrlData
			  );

InstructionLogicL: ENTITY WORK.Irl
GENERIC MAP(DataSize    => Word
			  )
PORT MAP	  (DataIn  => DataRom,
				Enable  => Control_IRL,
				Rst     => Control_RegistrosReset,
				Clk     => Clk,
				DataOut => IrlData
			  );

InstructionRegister: ENTITY WORK.Ir
GENERIC MAP(DataSize    => Word
			  )
PORT MAP	  (DataIn  => DataRom,
				Enable  => Control_IR,
				Rst     => Control_RegistrosReset,
				Clk     => Clk,
				DataOut => IrData
			  );

CounterRegister: ENTITY WORK.Cr 
GENERIC MAP(Size => PcSize
			  )
PORT MAP	  (Enable   => Control_CR( 1),
				Data     => IrIrlData (10 DOWNTO 0),
				DataLoad => Control_CR( 0),
				CtrlData => MiniCount,
				Rst      => Control_RegistrosReset,
				Clk      => Clk,
				CrData   => CrData
			  );

Bidirectional: ENTITY WORK.Bidir 
GENERIC MAP(DataLength => Word
			  )
PORT MAP	  (DataIn     => MdrData,
				SelectMode => Control_Bidir,
				DataOut    => BidirData,
				DataInOut  => DataRwm
			  );

Acc1: ENTITY WORK.Accumulator1
PORT MAP	  (InSelect      => Control_Acc1(4 DOWNTO 1),
				IrData        => IrIrlData,
				PcCount       => PcCount,
				RegisterData  => RegisterData,
				BidirData     => MdrData,
				ShiftEnable   => ShiftEnableAcc1,
				ArShiftEnable => ArShiftEnableAcc1,
				LeftRightN    => LrN,
				Enable        => Control_Acc1(0),
				Reset         => Control_RegistrosReset,
				Clk           => Clk,
				Acc1Data      => Acc1Data
			  );

Acc2: ENTITY WORK.Accumulator2
PORT MAP	  (InSelect      => Control_Acc2(4 DOWNTO 1),
				IrData        => IrIrlData,
				AluResult     => AluResult,
				RegisterData  => RegisterData,
				BidirData     => MdrData,
				ShiftEnable   => ShiftEnableAcc2,
				ArShiftEnable => ArShiftEnableAcc2,
				LeftRightN    => LrN,
				Enable        => Control_Acc2(0),
				Reset         => Control_RegistrosReset,
				Clk           => Clk,
				Acc2Data      => Acc2Data
			  );

ProgramCounter: ENTITY WORK.PC 
GENERIC MAP(Size => PcSize
			  )
PORT MAP	  (Enable   => Control_PC  ( 0),
				IrData   => IrIrlData   (10 DOWNTO 0),
				DataLoad => Control_PC  ( 1),
				Selector => Control_PC  ( 5 DOWNTO 2),
				AccPc    => Acc2Data    (10 DOWNTO 0),
				MdrData  => MdrData     (10 DOWNTO 0),
				RegData  => RegisterData(10 DOWNTO 0),
				Rst      => Control_RegistrosReset,
				Clk      => Clk,
				Count    => PcCount
			  );

ALU: ENTITY WORK.ArithmeticLogicUnit 
PORT MAP	  (A   => Acc1Data,
				B   => Acc2Data,
				Fc  => F4Alu,
				Clk => Clk,
				S   => OPEN,
				D   => AluData,
				R   => AluResult
			  );

--******************************************************--
-- 
-- Summon This Block:
-- 
--******************************************************--
--BlockN: ENTITY WORK. MegaM4 
--PORT MAP	  (Clk     => SLV,
--				Rst     => SLV,
--				DataRom => SLV,
--				IRQ     => SLV,
--				DataRwm => SLV,
--				ACK     => SLV,
--				RNW     => SLV,
--				Address => SLV,
--				State   => SLV,
--				ClkOut  => SLV
--			  );
--******************************************************--

END  MegaM4Arch;