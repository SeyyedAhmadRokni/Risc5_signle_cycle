library verilog;
use verilog.vl_types.all;
entity RegMem is
    port(
        clk             : in     vl_logic;
        we              : in     vl_logic;
        a1              : in     vl_logic_vector(4 downto 0);
        a2              : in     vl_logic_vector(4 downto 0);
        a3              : in     vl_logic_vector(4 downto 0);
        wd              : in     vl_logic_vector(31 downto 0);
        rd1             : out    vl_logic_vector(31 downto 0);
        rd2             : out    vl_logic_vector(31 downto 0)
    );
end RegMem;
