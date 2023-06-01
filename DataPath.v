module DataPath(clk, rst, imm_op, alu_op, reg_we, mem_we, m4_1_cnt, m4_2_cnt, m2_1_cnt, m2_2_cnt, m2_3_cnt);
    input clk, rst, reg_we, mem_we;
    input [1:0] m2_1_cnt, m2_2_cnt, m2_3_cnt;
    input [2:0] imm_op, alu_op, m4_1_cnt, m4_2_cnt;
    wire [31:0] m4_1_out, pc_out, inst, reg_rd1, reg_rd2, imm_ext_out, m2_1_out, alu_out, mem_out, m4_2_out, m2_2_out;
    wire [31:0] reg_wd, add_1_out, add_2_out, m2_3_out;
    wire zero;

    Pc pc(clk, rst, m4_1_out, pc_out);
    Mux4 m4_1(add_1_out, add_2_out, 32'b0, m4_2_out, m4_1_out);
    InstMemory im(rst, pc_out, inst);
    RegMem regmem(clk, reg_we, inst[19:15], inst[24:20], inst[11:7], reg_wd, reg_rd1, reg_rd2);
    ImmExtend imx(imm_op, inst, imm_ext_out);
    Mux2 m2_1(reg_rd2, imm_ext_out, m2_1_out);
    Alu alu(alu_op, reg_rd1, m2_1_out, alu_out, zero);
    Mem memory(clk, rst, alu_out, mem_we, reg_rd2, mem_out);
    Mux4 m4_2(alu_out, mem_out, m2_3_out, 32'b0, m4_2_out);
    Mux2 m2_2(m4_2_out, add_2_out, m2_2_out);
    Mux2 m2_3(32'b0, 32'b1, m2_3_out);
    Mux2 m2_4(m2_2_out, imm_ext_out, reg_wd);
    AddAlu add1(pc_out, imm_ext_out, add_1_out);
    AddAlu add2(pc_out, 32'd4, add_2_out);
endmodule