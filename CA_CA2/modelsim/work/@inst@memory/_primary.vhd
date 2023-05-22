library verilog;
use verilog.vl_types.all;
entity InstMemory is
    port(
        a               : in     vl_logic_vector(31 downto 0);
        inst            : out    vl_logic_vector(31 downto 0)
    );
end InstMemory;
