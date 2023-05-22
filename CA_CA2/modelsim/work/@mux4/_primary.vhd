library verilog;
use verilog.vl_types.all;
entity Mux4 is
    port(
        a1              : in     vl_logic_vector(31 downto 0);
        a2              : in     vl_logic_vector(31 downto 0);
        a3              : in     vl_logic_vector(31 downto 0);
        a4              : in     vl_logic_vector(31 downto 0);
        cnt             : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end Mux4;
