module AluController (AluOp,F3,AluIn);
parameter ADD =3'b000;
parameter SUB =3'b001;
    input[2:0] F3;
    input[1:0] AluOp;
    output[2:0] AluIn;
    assign AluIn = AluOp == 2'b0 ? ADD : AluOp == 2'b01 ? SUB : AluOp == 2'b10 ? F3 : 3'b111;
endmodule

module PcController (Jump,BrOp,IsJalr,Zero,SignBit,PcIn);
    input Jump, Zero, SignBit, IsJalr;
    input[1:0] BrOp;
    output[1:0] PcIn;
    assign PcIn = IsJalr ? 2'b10 : ((BrOp == 3'b0 & Zero) | Jump | (BrOp == 3'b001 & ~Zero) | (BrOp == 3'b010 & SignBit) | (BrOp == 3'b011 & ~SignBit)) ? 2'b01 : 2'b00;
endmodule

module SignControl (SignBit,SignSel);
    input SignBit;
    output SignSel;
    assign SignSel = SignBit;
endmodule

module Controller (Op,F3,Zero,SignBit,AluIn,PcIn,ImmSel,RegWrite,MemWrite,ResultSel,WdSel,SignSel,AluSel,Wd2Sel);
    parameter ADD =3'b000;
    parameter SUB =3'b001;
    parameter R_TYPE_OP= 7'b0;
    parameter LW_OP =7'b0000001;
    parameter ADD_I_OP= 7'b0000010;
    parameter XOR_I_OP =7'b0000011;
    parameter OR_I_OP =7'b0000100;
    parameter SLT_I_OP =7'b0000101;
    parameter JALR_OP =7'b0000110;
    parameter SW_OP =7'b0000111;
    parameter JAL_OP =7'b0001000;
    parameter BEQ_OP =7'b0001001;
    parameter BNE_OP= 7'b0001010;
    parameter BLT_OP =7'b0001011;
    parameter BGE_OP =7'b0001100;
    parameter LU_I_OP =7'b0001101;
    input Zero, SignBit;
    input [2:0] F3;
    input [6:0] Op;
    output WdSel, RegWrite, MemWrite, SignSel, AluSel, Wd2Sel;
    output[1:0] ResultSel, PcIn;
    output[2:0] ImmSel, AluIn;
    wire[1:0] AluOp;
    wire [2:0] BrOp;
    wire Jump, IsBType, IsIType, IsJalr;
    AluController AC(.AluOp(AluOp),.F3(F3),.AluIn(AluIn));
    PcController PC(.Jump(Jump),.BrOp(BrOp),.IsJalr(IsJalr),.Zero(Zero),.SignBit(SignBit),.PcIn(PcIn));
    SignControl SC(.SignSel(SignSel),.SignBit(SignBit));
    assign Jump = Op == JAL_OP;
    assign IsJalr = Op == JALR_OP;
    assign IsIType = Op == LW_OP | Op == ADD_I_OP | Op == XOR_I_OP | Op == OR_I_OP | Op == SLT_I_OP | Op == JALR_OP;
    assign IsBType = Op == BEQ_OP | Op == BNE_OP | Op == BLT_OP | Op == BGE_OP;
    assign BrOp = Op == BEQ_OP ? 3'b000 : Op == BNE_OP ? 3'b001 : Op == BLT ? 3'b010 : Op == BGE_OP ? 3'b011 : 3'b100;
    assign AluOp = Op == R_TYPE_OP ? 2'b10 : (Op == LW_OP | Op == ADD_I_OP | Op == JALR_OP | Op == SW_OP) ? 2'b00 : 
            (Op == SLT_I_OP | IsBType) ? 2'b01 : 2'b11;
    assign ImmSel = IsIType ? 3'b000 :
            Op == SW_OP ? 3'b001 : IsBType ? 3'b010 : Op == JAL_OP ? 3'b011 : Op == LU_I_OP ? 3'b100 : 3'101;
    assign RegWrite = Op == R_TYPE_OP | IsIType | Op == LU_I_OP;
    assign MemWrite = Op == SW_OP;
    assign ResultSel = Op == LW_OP ? 2'b01 : Op == SLT_I_OP ? 2'b10 : 2'b00;
    assign AluSel = IsIType | Op == SW_OP;
    assign Wd2Sel = Op == LU_I_OP;
    assign WdSel = Op == JALR_OP | Op == JAL_OP;
endmodule


module CA2 (clk,rst);
    input clk,rst;
    wire reg_we, mem_we, m2_1_cnt, m2_2_cnt, m2_3_cnt,m2_4_cnt,Zero,SignBit;
    wire [6:0] Op;
    wire[2:0] F3, imm_op, alu_op;
    wire[1:0] m4_2_cnt, m4_1_cnt;

    DataPath Dp(.clk(clk),.rst(rst),.imm_op(imm_op),.alu_op(alu_op),.reg_we(reg_we),.mem_we(mem_we),.m4_1_cnt(m4_1_cnt),.m4_2_cnt(m4_2_cnt),.m2_1_cnt(m2_1_cnt)
            ,.m2_2_cnt(m2_2_cnt),.m2_3_cnt(m2_3_cnt),.m2_4_cnt(m2_4_cnt),.Op(Op),.F3(F3),.Zero(Zero),.SignBit(SignBit));
    Controller C(.Op(Op),.F3(F3),.Zero(Zero),.SignBit(SignBit),.AluIn(alu_op),.PcIn(m4_1_cnt),.ImmSel(imm_op),.RegWrite(reg_we),.MemWrite(mem_we),.ResultSel(m4_2_cnt)
    ,.WdSel(m2_2_cnt),.SignSel(m2_3_cnt),.AluSel(m2_1_cnt),.Wd2Sel(m2_4_cnt));
endmodule