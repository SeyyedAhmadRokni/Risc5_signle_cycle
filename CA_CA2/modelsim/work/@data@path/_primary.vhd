library verilog;
use verilog.vl_types.all;
entity DataPath is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        imm_op          : in     vl_logic_vector(2 downto 0);
        alu_op          : in     vl_logic_vector(2 downto 0);
        reg_we          : in     vl_logic;
        mem_we          : in     vl_logic;
        m4_1_cnt        : in     vl_logic_vector(2 downto 0);
        m4_2_cnt        : in     vl_logic_vector(2 downto 0);
        m2_1_cnt        : in     vl_logic_vector(1 downto 0);
        m2_2_cnt        : in     vl_logic_vector(1 downto 0);
        m2_3_cnt        : in     vl_logic_vector(1 downto 0)
    );
end DataPath;
