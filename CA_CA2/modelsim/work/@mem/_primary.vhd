library verilog;
use verilog.vl_types.all;
entity Mem is
    port(
        clk             : in     vl_logic;
        a               : in     vl_logic_vector(31 downto 0);
        we              : in     vl_logic;
        wd              : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end Mem;
