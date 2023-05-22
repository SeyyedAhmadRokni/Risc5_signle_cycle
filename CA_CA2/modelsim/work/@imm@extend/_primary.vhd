library verilog;
use verilog.vl_types.all;
entity ImmExtend is
    port(
        op              : in     vl_logic_vector(2 downto 0);
        inp             : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end ImmExtend;
