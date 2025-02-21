LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY CICfilter is
	generic(
		dw:integer:=12);
	port(
		clk:in std_logic;
		x:in std_logic_vector(dw-1 downto 0);
		dcm: out std_logic;
		y:out std_logic_vector(dw-1 downto 0));
END CICfilter;

ARCHITECTURE a of CICfilter is
	signal enable:std_logic;
	signal aa,bb,cc,dd:std_logic_vector(dw+11 downto 0);
BEGIN
	SignExtended : for k in 1 to 12 generate
		aa(dw+k-1)<=x(dw-1);
	end generate SignExtended;
	
	aa(dw-1 downto 0)<=x;
	 
	process(clk)
	begin
		if(clk'event and clk='1')then
			bb<=aa+bb;
		end if;
	end process;
	
	dcm<=enable;
	
	process(clk)
		variable cnt:integer range 0 to 127;
	begin
		if(clk'event and clk='1')then
			cnt:=cnt+1;
			if(cnt=127)then
				enable<='1';
			else
				enable<='0';
			end if;
		end if;
	end process;
	
	CombFifo : scfifo
	GENERIC MAP (
		add_ram_output_register => "OFF",
		intended_device_family => "Cyclone III",
		lpm_numwords => 32,
		lpm_showahead => "OFF",
		lpm_type => "scfifo",
		lpm_width => 24,
		lpm_widthu => 5,
		overflow_checking => "ON",
		underflow_checking => "ON",
		use_eab => "ON"
	)
	PORT MAP (
		rdreq => enable,
		clock => clk,
		wrreq => enable,
		data => bb,
		q => cc
	);

	process(clk)
	begin
		if(clk'event and clk='1')then
			if(enable='1')then
				dd<=bb-cc;
			end if;
		end if;
	end process;
	
	y<=dd(dw+11 downto dw);
END a;