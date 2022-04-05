
--******************************************************--
--        PONTIFICIA UNIVERSIDAD JAVERIANA              --
--                Disegno Digital                       --
--          Seccion de Tecnicas Digitales               --
-- 													              --
-- Titulo :                                             --
-- Fecha  :  	D:XX M:XX Y:20XX                         --
--******************************************************--
                                                                                                                                                                                                                                                     --DefINicion de las bibliotecas
                                                                                                                                                                                                                                                     --DefINicion de las bibliotecas
library IEEE;
use IEEE.STD_LOGIC_1164.all;

--******************************************************--
-- DEFINICIÃ“N DE ENTIDAD                                --
--******************************************************--

entity Control is
port(
--Entradas
		reloj							: IN  STD_LOGIC;
		resetN						: IN  STD_LOGIC;
		CR 							: IN  STD_LOGIC_VECTOR ( 3 DOWNTO 0); --bit 0, CR[0], bit 1: CR en cero, bit 2: CR algun uno, activo en alto, bit 3 CR[1]
		SR								: IN  STD_LOGIC_VECTOR ( 7 DOWNTO 0);
		IRQ							: IN  STD_LOGIC_VECTOR ( 3 DOWNTO 0);
		IR								: IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		--Salidas
		Control_RegistrosReset	: OUT STD_LOGIC;
		Control_MAR					: OUT STD_LOGIC_VECTOR ( 2 DOWNTO 0);
		Control_OutputSelector  : OUT STD_LOGIC_VECTOR ( 2 DOWNTO 0);
		Control_IR					: OUT STD_LOGIC;
		Control_PC					: OUT STD_LOGIC_VECTOR ( 5 DOWNTO 0);
		Control_IRL					: OUT STD_LOGIC;
		RNW							: OUT STD_LOGIC;
		Control_Bidir				: OUT STD_LOGIC_VECTOR ( 1 DOWNTO 0);
		Control_Acc1				: OUT STD_LOGIC_VECTOR ( 4 DOWNTO 0);
		ShiftEnableAcc1			: OUT STD_LOGIC;
		ArShiftEnableAcc1			: OUT STD_LOGIC;
		LRNAcc						: OUT STD_LOGIC;
		Control_Acc2				: OUT STD_LOGIC_VECTOR ( 4 DOWNTO 0);
		ShiftEnableAcc2			: OUT STD_LOGIC;
		ArShiftEnableAcc2			: OUT STD_LOGIC;
		IRSelect						: OUT STD_LOGIC;
		Control_MDR					: OUT STD_LOGIC_VECTOR ( 7 DOWNTO 0);
		Control_Registros			: OUT STD_LOGIC_VECTOR ( 2 DOWNTO 0);
		Control_CR					: OUT STD_LOGIC_VECTOR ( 1 DOWNTO 0);
		MINiCount					: OUT STD_LOGIC_VECTOR ( 1 DOWNTO 0);
		Control_SR					: OUT STD_LOGIC_VECTOR ( 5 DOWNTO 0);
		Control_ALU					: OUT STD_LOGIC_VECTOR ( 3 DOWNTO 0);
		Control_SP					: OUT STD_LOGIC_VECTOR ( 1 DOWNTO 0);
		Ack							: OUT STD_LOGIC_VECTOR ( 1 DOWNTO 0);
		Qs 							: OUT STD_LOGIC_VECTOR (85 DOWNTO 0)

		 );

END ENTITY Control;

--******************************************************--
--DEFINICIÃ“N DE ARQUITECTURA                                        --
--******************************************************--

ARCHITECTURE ControlArch OF Control IS

--******************************************************--
--DEFINICIÃ“N DE SEÃ‘ALES DE CONEXIÃ“N
--******************************************************--

SIGNAL Q     : STD_LOGIC_VECTOR(85 DOWNTO 0);
SIGNAL D     : STD_LOGIC_VECTOR(85 DOWNTO 0);

SIGNAL De    : STD_LOGIC_VECTOR( 0 DOWNTO 0);
SIGNAL Qe    : STD_LOGIC_VECTOR( 0 DOWNTO 0);

SIGNAL reset : STD_LOGIC;

SIGNAL AluState : STD_LOGIC;

--******************************************************--
--INstancias y Conectividad
--******************************************************
BEGIN
	   Reset <= resetN;

		--Salidas
		FF0  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 0),
					       Q    =>  Q( 0),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '1'
					      );
		FF1  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 1),
					       Q    =>  Q( 1),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF2  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 2),
					       Q    =>  Q( 2),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF3  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 3),
					       Q    =>  Q( 3),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF4  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 4),
					       Q    =>  Q( 4),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF5  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 5),
					       Q    =>  Q( 5),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF6  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 6),
					       Q    =>  Q( 6),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF7  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 7),
					       Q    =>  Q( 7),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF8  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 8),
					       Q    =>  Q( 8),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF9  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D( 9),
					       Q    =>  Q( 9),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF10  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(10),
					       Q    =>  Q(10),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF11  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(11),
					       Q    =>  Q(11),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF12  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(12),
					       Q    =>  Q(12),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF13  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(13),
					       Q    =>  Q(13),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF14  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(14),
					       Q    =>  Q(14),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF15  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(15),
					       Q    =>  Q(15),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF16  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(16),
					       Q    =>  Q(16),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF161 : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    => De( 0),
					       Q    => Qe( 0),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF17  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(17),
					       Q    =>  Q(17),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF18  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(18),
					       Q    =>  Q(18),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF19  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(19),
					       Q    =>  Q(19),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF20  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(20),
					       Q    =>  Q(20),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF21  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(21),
					       Q    =>  Q(21),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF22  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(22),
					       Q    =>  Q(22),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF23  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(23),
					       Q    =>  Q(23),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF24  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(24),
					       Q    =>  Q(24),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF25  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(25),
					       Q    =>  Q(25),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF26  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(26),
					       Q    =>  Q(26),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF27  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(27),
					       Q    =>  Q(27),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF28  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(28),
					       Q    =>  Q(28),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF29  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(29),
					       Q    =>  Q(29),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF30  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(30),
					       Q    =>  Q(30),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF31  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(31),
					       Q    =>  Q(31),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF32  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(32),
					       Q    =>  Q(32),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF33  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(33),
					       Q    =>  Q(33),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF34  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(34),
					       Q    =>  Q(34),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF35  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(35),
					       Q    =>  Q(35),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF36  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(36),
					       Q    =>  Q(36),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF37  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(37),
					       Q    =>  Q(37),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF38  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(38),
					       Q    =>  Q(38),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF39  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(39),
					       Q    =>  Q(39),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF40  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(40),
					       Q    =>  Q(40),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF41  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(41),
					       Q    =>  Q(41),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF42  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(42),
					       Q    =>  Q(42),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF43  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(43),
					       Q    =>  Q(43),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF44  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(44),
					       Q    =>  Q(44),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF45  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(45),
					       Q    =>  Q(45),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF46  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(46),
					       Q    =>  Q(46),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF47  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(47),
					       Q    =>  Q(47),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF48  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(48),
					       Q    =>  Q(48),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF49  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(49),
					       Q    =>  Q(49),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF50  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(50),
					       Q    =>  Q(50),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF51  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(51),
					       Q    =>  Q(51),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF52  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(52),
					       Q    =>  Q(52),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF53  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(53),
					       Q    =>  Q(53),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF54  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(54),
					       Q    =>  Q(54),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF55  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(55),
					       Q    =>  Q(55),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF56  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(56),
					       Q    =>  Q(56),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF57  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(57),
					       Q    =>  Q(57),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF58  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(58),
					       Q    =>  Q(58),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF59  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(59),
					       Q    =>  Q(59),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF60  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(60),
					       Q    =>  Q(60),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF61  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(61),
					       Q    =>  Q(61),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF62  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(62),
					       Q    =>  Q(62),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF63  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(63),
					       Q    =>  Q(63),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF64  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(64),
					       Q    =>  Q(64),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF65  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(65),
					       Q    =>  Q(65),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF66  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(66),
					       Q    =>  Q(66),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF67  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(67),
					       Q    =>  Q(67),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF68  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(68),
					       Q    =>  Q(68),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF69  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(69),
					       Q    =>  Q(69),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF70  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(70),
					       Q    =>  Q(70),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF71  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(71),
					       Q    =>  Q(71),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF72  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(72),
					       Q    =>  Q(72),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF73  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(73),
					       Q    =>  Q(73),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF74  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(74),
					       Q    =>  Q(74),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF75  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(75),
					       Q    =>  Q(75),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF76  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(76),
					       Q    =>  Q(76),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF77  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(77),
					       Q    =>  Q(77),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF78  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(78),
					       Q    =>  Q(78),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF79  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(79),
					       Q    =>  Q(79),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF80  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(80),
					       Q    =>  Q(80),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF81  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(81),
					       Q    =>  Q(81),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF82  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(82),
					       Q    =>  Q(82),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF83  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(83),
					       Q    =>  Q(83),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF84  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(84),
					       Q    =>  Q(84),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );
		FF85  : ENTITY WORK.FlipFlopRe
		PORT MAP	  (D    =>  D(85),
					       Q    =>  Q(85),
					       Ena  =>  '1',
					       Clk  =>  reloj,
					       Rst  =>  reset,
					       Set  =>  '0'
					      );

		D( 0)<= reset;
		D( 1)<=  Q(0 )
			  OR (Q(73) AND  NOT SR(5))
			  OR (Q(73) AND (    SR(5) AND ( NOT IRQ(3) AND NOT IRQ(2) AND NOT IRQ(1) AND NOT IRQ(0) ) )  )
 		     OR (Q(73) AND (    SR(5) AND (     IRQ(3) OR      IRQ(2) OR      IRQ(1) OR      IRQ(0) ) AND (IRQ(1) AND SR(6)) ))
			  OR (Q(73) AND (    SR(5) AND (     IRQ(3) OR      IRQ(2) OR      IRQ(1) OR      IRQ(0) ) AND (IRQ(2) AND SR(6) AND SR(7)) ))
			  OR  Q(83)
			  OR  Q(84)
			  OR  Q(85);
		D( 2)<=  Q(1 );
		D( 3)<=  Q(2 );
		D( 4)<=  Q(3 );
		D( 5)<= (Q(4 ) AND ((NOT IR(15)AND NOT IR(14) AND NOT IR(13) AND     IR(12)) AND     IR(10)))
			  OR (Q(4 ) AND  (NOT IR(15)AND     IR(14) AND NOT IR(13) AND NOT IR(12)))
			  OR (Q(4 ) AND ((NOT IR(15)AND     IR(14) AND NOT IR(13) AND     IR(12)) AND(NOT IR(10) AND     IR(8))))
			  OR (Q(4 ) AND ((    IR(15)AND     IR(14) AND NOT IR(13) AND     IR(12)) AND(    IR(11) AND NOT IR(10) AND IR(9 ))))
			  OR (Q(4 ) AND ((    IR(15)AND NOT IR(14) AND NOT IR(13) AND     IR(12)) AND(    IR(11) AND NOT IR(10) AND IR(9 ))));
		D( 6)<=  Q(5 );
		D( 7)<=  Q(6 );
		D( 8)<=  Q(7 );
		D( 9)<= Qe( 0)
			  OR  Q(17)
			  OR  Q(66);
		D(10)<= 	Q(9 );
		D(11)<=  Q(10);
		D(12)<=  Q(18)
		     OR  Q(55);
		D(13)<=  Q(12);
		D(14)<=  Q(13);
		D(15)<= (Q(4 ) AND ((NOT IR(15)AND NOT IR(14) AND NOT IR(13) AND     IR(12))AND NOT IR(10)))
			  OR (Q(8 ) AND  (NOT IR(15)AND NOT IR(14) AND NOT IR(13) AND     IR(12)));
		D(16)<=  Q(8 ) AND  (NOT IR(15)AND     IR(14) AND NOT IR(13) AND NOT IR(12));
	  De( 0)<=  Q(16);
		D(17)<= (Q(4 ) AND ((NOT IR(15)AND     IR(14) AND NOT IR(13) AND     IR(12)) AND (NOT IR(10)AND NOT IR(9)AND NOT IR(8))))
			  OR (Q(8 ) AND ((NOT IR(15)AND     IR(14) AND NOT IR(13) AND     IR(12)) AND (NOT IR(10)AND NOT IR(9)AND     IR(8))));
		D(18)<= (Q(4 ) AND ((NOT IR(15)AND     IR(14) AND NOT IR(13) AND     IR(12))AND(NOT IR(10)AND     IR(9)AND NOT IR(8))))
			  OR (Q(8 ) AND ((NOT IR(15)AND     IR(14) AND NOT IR(13) AND     IR(12))AND(NOT IR(10)AND     IR(9))));
		D(19)<=  Q(14) AND  (NOT IR(15)AND     IR(14) AND NOT IR(13) AND     IR(12));
		D(20)<=  Q(4 ) AND ((NOT IR(15)AND     IR(14) AND NOT IR(13) AND     IR(12))AND(    IR(10)AND NOT IR(9)));
		D(21)<=  Q(4 ) AND ((NOT IR(15)AND     IR(14) AND NOT IR(13) AND     IR(12))AND(    IR(10)AND     IR(9)));
		D(22)<=  Q(4 ) AND ((    IR(15)AND NOT IR(14) AND     IR(13) AND NOT IR(12))AND NOT IR(11));
		D(23)<=  Q(59) AND ((    IR(15)AND NOT IR(14) AND     IR(13) AND NOT IR(12))AND NOT IR(11)AND     CR(0));
		D(24)<=  Q(59) AND ((    IR(15)AND NOT IR(14) AND     IR(13) AND NOT IR(12))AND NOT IR(11)AND NOT CR(0));
		D(25)<=  Q(4 ) AND ((    IR(15)AND NOT IR(14) AND     IR(13) AND NOT IR(12))AND     IR(11));
		D(26)<=  Q(70) AND ((    IR(15)AND NOT IR(14) AND     IR(13) AND NOT IR(12))AND     IR(11)AND     CR(0));
		D(27)<=  Q(70) AND ((    IR(15)AND NOT IR(14) AND     IR(13) AND NOT IR(12))AND     IR(11)AND NOT CR(0));
		D(28)<=  Q(4 ) AND ((NOT IR(15)AND NOT IR(14) AND NOT IR(13) AND NOT IR(12))AND NOT IR(11));
		D(29)<=  Q(4 ) AND ((NOT IR(15)AND NOT IR(14) AND NOT IR(13) AND NOT IR(12))AND     IR(11));
		D(30)<=  Q(29)
		     OR (Q(30) AND       CR(2 ));
		D(31)<=  Q(4 ) AND ((NOT IR(15)AND NOT IR(14) AND     IR(13) AND NOT IR(12))AND NOT IR(9 ));
		D(32)<=  Q(4 ) AND ((NOT IR(15)AND NOT IR(14) AND     IR(13) AND NOT IR(12))AND     IR(9 ));
		D(33)<=  Q(4 ) AND ((NOT IR(15)AND     IR(14) AND     IR(13) AND NOT IR(12))AND NOT IR(11));
		D(34)<=  Q(33)
		     OR  Q(38);
		D(35)<= 	Q(34);
		D(36)<=  Q(4 ) AND ((NOT IR(15)AND     IR(14) AND     IR(13) AND NOT IR(12))AND     IR(11));
		D(37)<=  Q(4 ) AND  (    IR(15)AND     IR(14) AND     IR(13) AND NOT IR(12));
		D(38)<= (Q(37) AND ((NOT IR(11)AND NOT IR(10) AND NOT IR(9 ))AND     SR( 0)))
			  OR (Q(37) AND ((NOT IR(11)AND NOT IR(10) AND     IR(9 ))AND     SR( 1)))--REVISAR
			  OR (Q(37) AND ((NOT IR(11)AND     IR(10) AND NOT IR(9 ))AND     SR( 2)));
		D(39)<= (Q(37) AND ((    IR(11)AND NOT IR(10) AND NOT IR(9 ))AND     SR( 0)))
			  OR (Q(37) AND ((    IR(11)AND NOT IR(10) AND     IR(9 ))AND     SR( 1)))--REVISAR
			  OR (Q(37) AND ((    IR(11)AND     IR(10) AND NOT IR(9 ))AND     SR( 2)));
		D(40)<=  Q(4 ) AND ((NOT IR(15)AND NOT IR(14) AND     IR(13) AND     IR(12)) AND(NOT IR(11) AND NOT IR(10)));
		D(41)<=  Q(4 ) AND ((NOT IR(15)AND NOT IR(14) AND     IR(13) AND     IR(12)) AND(NOT IR(11) AND     IR(10)));
		D(42)<=  Q(4 ) AND ((NOT IR(15)AND NOT IR(14) AND     IR(13) AND     IR(12)) AND(    IR(11) AND NOT IR(10)));
		D(43)<=  Q(4 ) AND ((NOT IR(15)AND     IR(14) AND     IR(13) AND     IR(12)) AND(NOT IR(11) AND NOT IR(10) AND     IR(9 ))); --     ( ((IR[15]'.IR[14] .IR[13] .IR[12] ).(IR[11]'.IR[10]'.IR[09] )) X 43)+
		D(44)<=  Q(4 ) AND ((NOT IR(15)AND     IR(14) AND     IR(13) AND     IR(12)) AND(NOT IR(11) AND     IR(10) AND     IR(9 )));
		D(45)<=  Q(4 ) AND ((NOT IR(15)AND     IR(14) AND     IR(13) AND     IR(12)) AND(    IR(11) AND NOT IR(10) AND     IR(9 )));
		D(46)<=  Q(4 ) AND ((NOT IR(15)AND     IR(14) AND     IR(13) AND     IR(12)) AND(NOT IR(11) AND     IR(10) AND NOT IR(9 )));
		D(47)<= (Q(4 ) AND (     IR(15)AND NOT IR(14) AND     IR(13) AND     IR(12)))
			  OR (Q(47) AND   NOT SR(4 ));
		D(48)<= (Q(47) AND       SR(4 ));
		D(49)<=  Q(4 ) AND ((    IR(15)AND     IR(14)AND NOT  IR(13) AND     IR(12)) AND(NOT IR(11) AND NOT IR(10) AND NOT IR(9 )));
		D(50)<=  Q(4 ) AND ((    IR(15)AND     IR(14)AND NOT  IR(13) AND     IR(12)) AND(NOT IR(11) AND NOT IR(10) AND     IR(9 )));
		D(51)<=  Q(4 ) AND ((    IR(15)AND     IR(14)AND NOT  IR(13) AND     IR(12)) AND(NOT IR(11) AND     IR(10) AND NOT IR(9 )));
		D(52)<=  Q(4 ) AND ((    IR(15)AND     IR(14)AND NOT  IR(13) AND     IR(12)) AND(NOT IR(11) AND     IR(10) AND     IR(9 )));
		D(53)<=  Q(4 ) AND ((    IR(15)AND     IR(14)AND NOT  IR(13) AND     IR(12)) AND(    IR(11) AND NOT IR(10) AND NOT IR(9 )));
		D(54)<=  Q(53);
		D(55)<=  Q(8 ) AND  (    IR(15)AND     IR(14)AND NOT  IR(13) AND     IR(12));
		D(56)<= (Q(14) AND  (    IR(15)AND NOT IR(14)AND NOT  IR(13) AND     IR(12)))
		     OR  Q(22)
			  OR  Q(23)
			  OR  Q(49)
			  OR  Q(50)
			  OR  Q(51)
			  OR  Q(52)
			  OR  Q(54);
		D(57)<=  Q(56);
		D(58)<=  Q(57);
		D(59)<=  Q(58);
		D(60)<=  Q(70) AND ((    IR(15)AND NOT IR(14) AND NOT IR(13) AND     IR(12)) AND(NOT IR(11) AND NOT IR(10) AND NOT IR(9))    );
		D(61)<=  Q(70) AND ((    IR(15)AND NOT IR(14) AND NOT IR(13) AND     IR(12)) AND(NOT IR(11) AND NOT IR(10) AND     IR(9)));
		D(62)<=  Q(70) AND ((    IR(15)AND NOT IR(14) AND NOT IR(13) AND     IR(12)) AND(NOT IR(11) AND     IR(10) AND NOT IR(9)));
		D(63)<=  Q(70) AND ((    IR(15)AND NOT IR(14) AND NOT IR(13) AND     IR(12)) AND(NOT IR(11) AND     IR(10) AND     IR(9)));
		D(64)<=  Q(70) AND ((    IR(15)AND NOT IR(14) AND NOT IR(13) AND     IR(12)) AND(    IR(11) AND NOT IR(10) AND NOT IR(9)));
		D(65)<=  Q(64)
		     OR (Q(70) AND ((    IR(15)AND NOT IR(14) AND NOT  IR(13) AND     IR(12)) AND(   IR(11) AND NOT IR(10) AND     IR(9))));
		D(66)<= (Q(70) AND ((    IR(15)AND NOT IR(14) AND NOT  IR(13) AND     IR(12)) AND (    IR(11) AND     IR(10)AND NOT IR(9))));
		D(67)<= (Q(4 ) AND (     IR(15)AND NOT IR(14) AND NOT  IR(13) AND     IR(12)) AND (    IR(10) OR      IR(9)))
			  OR (Q(4 ) AND (     IR(15)AND NOT IR(14) AND NOT  IR(13) AND     IR(12)) AND (NOT IR(10) AND NOT IR(9)))
			  OR (Q(8 ) AND (     IR(15)AND NOT IR(14) AND NOT  IR(13) AND     IR(12)))
			  OR Q(25)
			  OR Q(26);
		D(68)<=  Q(67);
		D(69)<=  Q(68);
		D(70)<=  Q(69);
		D(71)<=  Q(4 ) AND ((    IR(15)AND     IR(14)AND     IR(13) AND     IR(12)) AND( NOT IR(11) ));
		D(72)<=  Q(4 ) AND ((    IR(15)AND     IR(14)AND     IR(13) AND     IR(12)) AND(     IR(11) ));
		D(73)<=  Q(11)
			  OR  (Q(14)AND  (    IR(15)AND NOT IR(14)AND NOT IR(13) AND IR(12)))
			  OR  Q(15)
			  OR  Q(19)
			  OR  Q(20)
			  OR  Q(21)
			  OR  Q(24)
			  OR  Q(27)
			  OR  Q(28)
			  OR (Q(30) AND       CR(1 ))
			  OR  Q(31)
			  OR  Q(32)
			  OR  Q(35)
			  OR  Q(36)
			  OR (Q(37) AND ((NOT IR(11)AND NOT IR(10) AND NOT IR(9 ))AND NOT SR( 0)))
			  OR (Q(37) AND ((NOT IR(11)AND NOT IR(10) AND     IR(9 ))AND NOT SR( 1)))--REVISAR
			  OR (Q(37) AND ((NOT IR(11)AND     IR(10) AND NOT IR(9 ))AND NOT SR( 2)))
			  OR (Q(37) AND ((    IR(11)AND NOT IR(10) AND NOT IR(9 ))AND NOT SR( 0)))
			  OR (Q(37) AND ((    IR(11)AND NOT IR(10) AND     IR(9 ))AND NOT SR( 1)))--REVISAR
			  OR (Q(37) AND ((    IR(11)AND     IR(10) AND NOT IR(9 ))AND NOT SR( 2)))
			  OR  Q(39)
			  OR  Q(40)
			  OR  Q(41)
			  OR  Q(42)
			  OR  Q(43)
			  OR  Q(44)
			  OR  Q(45)
			  OR  Q(46)
			  OR  Q(48)
			  OR (Q(59) AND (    IR(15)  AND NOT (IR(14)) AND NOT (IR(13)) AND     IR(12)))
			  OR  Q(60)
			  OR  Q(61)
			  OR  Q(62)
			  OR  Q(63)
			  OR  Q(65)
			  OR  Q(71)
			  OR  Q(72);
		D(74)<=  Q(78)
			  OR  Q(79)
			  OR  Q(80)
			  OR  Q(81);
		D(75)<=  Q(74);
		D(76)<=  Q(75);
		D(77)<=  Q(76);
		D(78)<=  (Q(73) AND (    SR(5) AND ( IRQ(3) OR IRQ(2) OR IRQ(1) OR IRQ(0) ) AND  IRQ(0) ))
			  OR  (Q(73) AND (    SR(5) AND ( IRQ(3) OR IRQ(2) OR IRQ(1) OR IRQ(0) ) AND (IRQ(1) AND NOT SR(6)) ))
  		     OR  (Q(73) AND (    SR(5) AND ( IRQ(3) OR IRQ(2) OR IRQ(1) OR IRQ(0) ) AND (IRQ(2) AND NOT SR(6) AND NOT SR(7)) ));
		D(79)<=  Q(77) AND  (    CR(3) AND     CR(0));
		D(80)<=  Q(77) AND (    CR(3) AND NOT CR(0));
		D(81)<=  Q(77) AND (NOT CR(3) AND     CR(0));
		D(82)<=  Q(77) AND (NOT CR(3) AND NOT CR(0));
		D(83)<=  Q(82) AND     IRQ(0);
		D(84)<=  Q(82) AND (   IRQ(1) AND NOT SR(6));
		D(85)<=  Q(82) AND (   IRQ(2) AND NOT SR(6) AND NOT SR(5));
		--**************************************************************************************
		Qs<=Q;

		Control_RegistrosReset<=		Q(0); --Senal de control que establece el valor de los registros en '1'
		Control_MAR(0)<=				   Q(9) OR Q(10) OR Q(11) OR Q(12) OR Q(13) OR Q(14) OR Qe(0) OR Q(17) OR Q(18)
												OR Q(55) OR Q(63) OR Q(66); --Senal de enable del mar desde control
		Control_MAR(1)<=					Q(9) OR Q(10) OR Q(11) OR Q(12) OR Q(13) OR Q(14) OR Qe(0) OR Q(17) OR Q(18)
												OR Q(55) OR Q(66); --Senal de control para que el MAR reciba el valor de ir(11:0)
		Control_MAR(2)<=					Q(63);--Senal de control escribe en MAR el MDR

		Control_OutputSelector(0)<=	Q( 9) OR Q(10) OR Q(11) OR Q(12) OR Q(13) OR Q(14) OR Q(16) OR Q(17) OR Q(18)
												OR Q(55) OR Q(63) OR Q(66); --Senal de enable del OS desde control para que reciba datos de MAR
		Control_OutputSelector(1)<=	Q( 1) OR Q( 2) OR Q( 3) OR Q( 4) OR Q( 5) OR Q( 6) OR Q( 7) OR Q( 8); --Senal de control del mar desde control para que almacene los datos del PC NOTA: bit11 OUTPUT recibe not esta senal
		Control_OutputSelector(2)<=	Q(56) OR Q(57) OR Q(58) OR Q(67) OR Q(68) OR Q(69) OR Q(74) OR Q(75) OR Q(76);-- Senal de enable para recibir los datos del sp

		Control_IR<=						Q(3);--Senal de enable de IR

		Control_PC(0)<=					Q(4 ) OR Q(8);--Senal de enable de INcremento de PC
		Control_PC(1)<=					Q(24) OR Q(27) OR Q(35) OR Q(36) OR Q(39) OR Q(60) OR Q(83) OR Q(84) OR Q(85);-- Senal de enable para reemplazar el dato de PC
		Control_PC(2)<=					Q(24) OR Q(36);--Senal de enable de PC para recibir IR
		Control_PC(3)<=					Q(27) OR Q(60);--Senal de enable de PC para recibir MDR0
		Control_PC(4)<=					Q(35) OR Q(39);--Senal de enable de PC para recibir Acc2
		Control_PC(5)<=					Q(83) or Q(84) or Q(85);--Recibe el valor del registro, el cual es la direccion del programa del Periferico

		Control_IRL<=						Q(7);--Senal de enable de IRL para que tome el valor de IR

		RNW<=									Q(9 ) OR Q(10) OR Q(11) OR Q(56) OR Q(57) OR Q(58) OR (NOT Q(67)) OR (NOT Q(68)) OR (NOT Q(69))
												OR Q(74) OR Q(75) OR Q(76);

		Control_Bidir(0)<=				Q(9 ) OR Q(10) OR Q(11) OR Q(56) OR Q(57) OR Q(58) OR Q(74) OR Q(75) OR Q(76);--Bidir de salida, envia el contenido de MDR como salida, sobreescribe su valor con lo INgresado de MDR
		Control_Bidir(1)<=				Q(14) OR Q(69);--Bidir de entrada, en 1 cuando recibe datos, sobreescribe su valor con lo INgresado de RW

		IRSelect<=							Q(16) OR (Q(15) AND IR(10)) OR (Q(17) AND IR(8)) OR (Q(18) AND IR(8)) OR Q(55) OR Q(66);--0 IR 1 IRL

		Control_Acc1(0)<=					(Q(15)AND NOT IR(11)) OR (Q(19)AND NOT IR(11)) OR (Q(21)AND NOT IR(11)) OR (Q(33))
												OR Q(38) OR (Q(61)AND NOT IR(8));--Enable de acumulador, 1 para recibir nuevo dato
		Control_Acc1(1)<=					(Q(15)AND NOT IR(11));--Enable de acumulador, 1 para recibir IRLogic
		Control_Acc1(2)<=					(Q(19)AND NOT IR(11)) OR (Q(61)AND NOT IR(8));--Enable de acumulador, 1 para recibir MDR
		Control_Acc1(3)<=					(Q(21)AND NOT IR(11));--Enable de acumulador, 1 para recibir datos del register
		Control_Acc1(4)<=				 	Q(33) OR Q(38);--Enable de acumulador 1 para recibir PC
		ShiftEnableAcc1<=					Q(31)AND NOT IR(11);
		ArShiftEnableAcc1<=				Q(32)AND NOT IR(11);
		LRNAcc<=							IR(10);

		Control_Acc2(0)<=					(Q(15)AND IR(11)) OR (Q(19)AND IR(11)) OR (Q(21)AND IR(11)) OR (Q(33)) OR Q(34)
												OR Q(37) OR Q(40) OR Q(41) OR Q(42) OR Q(43) OR Q(44) OR Q(45) OR Q(48) OR Q(53)
												OR (Q(61)AND IR(8)) OR Q(64);--Enable de acumulador, 2 para recibir nuevo dato
		Control_Acc2(1)<=					(Q(15)AND IR(11)) OR  Q(33);--Enable de acumulador, 2 para recibir IRLogic
		Control_Acc2(2)<=					(Q(19)AND IR(11)) OR (Q(61)AND IR(8)) OR Q(64);--Enable de acumulador, 2 para recibir MDR
		Control_Acc2(3)<=					(Q(21)AND IR(11)) OR Q(37) OR Q(53);--Enable de acumulador, 2 para recibir datos del register
		Control_Acc2(4)<=					Q(34) OR Q(40) OR Q(41) OR Q(42) OR Q(43) OR Q(44) OR Q(45) OR Q(48);--Enable de acumulador, 2 para recibir datos de la ALU
		ShiftEnableAcc2<=					Q(31)AND IR(11);
		ArShiftEnableAcc2<=				Q(32)AND IR(11);

		Control_MDR(0)<=					Q(14) OR Q(16) OR Q(17) OR Q(22) OR Q(23) OR Q(49) OR Q(50) OR Q(51) OR Q(52)
												OR Q(54)  OR Q(78) OR Q(79) OR Q(80) OR Q(81);--Enable de MDR para que reciba nuevos datos
		Control_MDR(1)<=					Q(14) OR Q(69);--Enable de MDR para que reciba los datos del bidir
		Control_MDR(2)<=					Q(16);--Enable de MDR para que reciba los datos de IRL
		Control_MDR(3)<=	     		   (Q(17) AND NOT IR(11)) OR (Q(50) AND NOT IR(8))  OR Q(78);--Enable de MDR para que reciba los datos de Acc1
		Control_MDR(4)<=	   		   (Q(17) AND     IR(11)) OR (Q(50) AND      IR(8)) OR Q(54) OR Q(79);--Enable de MDR para que reciba los datos de Acc2
		Control_MDR(5)<=					Q(22) OR Q(49) OR Q(81);--Enable de MDR para recibir PC
		Control_MDR(6)<=					Q(23) OR Q(51) or Q(80);--Enable de MDR para recibir SR,
		Control_MDR(7)<=					Q(52);--Enable de MDR para recibir MAR

		Control_Registros(0)<= 			Q(20) OR Q(65);--Enable de los registros para guardar un valor
		Control_Registros(1)<= 			(Q(20) AND NOT IR(11));--Enable para tomar el valor de Acc1
		Control_Registros(2)<= 			(Q(20) AND     IR(11)) OR Q(65);--Enable para tomar el valor de Acc2



		Control_CR(0)<=					Q(22) OR Q(25) OR Q(78) OR Q(29);--enable para que reemplace su valor
		Control_CR(1)<=					Q(23) OR Q(26) OR Q(30) OR Q(79) OR Q(80) OR Q(81); --enable para decrementar
		--Control_CR(2)<=					Q(22) OR Q(25) OR Q(78);--enable para recibir mINi conteo
		--Control_CR(3)<=					Q(29) ;--enable para recibir IR

		MINiCount(0)<=					Q(22) OR Q(25)  OR Q(78);
		MINiCount(1)<=					Q(78);

		Control_SR(0)<=				Q(26) OR Q(45) OR Q(62) OR Q(71) OR Q(72) OR Q(83) OR Q(84);--enable
		Control_SR(1)<=				Q(26) OR Q(62);--enableMDR
		Control_SR(2)<=				Q(45);--enableALU
		Control_SR(3)<=				Q(71) OR NOT Q(72);--Senal directa al bit de INterrupciones del SR
		Control_SR(4)<=				Q(83);--Senal directa al bit de p1 del SR
		Control_SR(5)<=				Q(84);--Senal directa al bit de p2 del SR

		
		AluState      <=           Q(40) OR Q(41) OR Q(42) OR Q(43) OR Q(44) OR Q(45) OR Q(46) OR Q(47);
		
		Control_ALU(0)<=				((     IR(13) AND     IR(12)) AND (NOT(IR(15) AND IR(14))) AND (IR(10)) AND (AluState));--34 SUM, 40 OR, 41 AND,42 NOT, 43 sum, 44 RESTA,45 2sC, 46 RESTA, 47 Multiply
		Control_ALU(1)<=				((     IR(13) AND     IR(12)) AND (NOT(IR(15) AND IR(14))) AND (IR(11)) AND (AluState));
		Control_ALU(2)<=				((     IR(13) AND     IR(12)) AND (NOT(IR(15) AND IR(14))) AND (IR(14)) AND (AluState)) OR (Q(34));
		Control_ALU(3)<=				((     IR(13) AND     IR(12)) AND (NOT(IR(15) AND IR(14))) AND (IR(15)) AND (AluState));

		Ack(0)<=							Q(83);
		Ack(1)<=							Q(84);

		Control_SP(0)<=				Q(70) OR Q(59) OR Q(77);--Senal de control de eenable al SP
		Control_SP(1)<=				Q(59) OR Q(77);--Senal de control de INcremento de SP 1 INcremento, 0 decremento

--******************************************************--
--
-- Summon This Block:
--
--******************************************************--
--BlockN: ENTITY WORK.Control
--PORT MAP	  (Reloj                  => SLV,
--				Reset                  => SLV,
--				Cr                     => SLV,
--				Sr                     => SLV,
--				Irq                    => SLV,
--				Ir                     => SLV,
--				--Salidas
--				Control_RegistrosReset => SLV,
--				Control_MAR            => SLV,
--				Control_OutputSelector => SLV,
--				Control_IR             => SLV,
--				Control_PC				  => SLV,
--				Control_IRL				  => SLV,
--				RNW						  => SLV,
--				Control_Bidir			  => SLV,
--				Control_Acc1			  => SLV,
--				ShiftEnableAcc1		  => SLV,
--				ArShiftEnableAcc1		  => SLV,
--				LRNAcc1					  => SLV,
--				Control_Acc2			  => SLV,
--				ShiftEnableAcc2		  => SLV,
--				ArShiftEnableAcc2		  => SLV,
--				LRNAcc2					  => SLV,
--				IRSelect					  => SLV,
--				Control_MDR				  => SLV,
--				Control_Registros		  => SLV,
--				Control_CR				  => SLV,
--				MINiCount				  => SLV,
--				Control_SR				  => SLV,
--				Control_ALU				  => SLV,
--				Control_SP				  => SLV,
--				Ack        				  => SLV,
--		      Qs 						  => SLV
--			  );
--******************************************************--

END  ControlArch;