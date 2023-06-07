module AluController (AluOp,F3,F7,AluIn);
    parameter ADD_3 = 3'b000;
    parameter SUB_3 = 3'b000;
    parameter AND_3 = 3'b111;
    parameter OR_3 = 3'b110;
    parameter SLT_3 = 3'b010;
    parameter ADD_7 = 7'b0;
    parameter SUB_7 = 7'b0100000;
    parameter AND_7 = 7'b0;
    parameter OR_7 = 7'b0;
    parameter SLT_7 = 7'b0;
    parameter ADD =3'b000;
    parameter SUB =3'b001;
    parameter AND =3'b010;
    parameter OR =3'b011;
    parameter XOR =3'b100;
    parameter ADD_I_3 = 3'b0;
    parameter XOR_I_3 = 3'b100;
    parameter OR_I_3 = 3'b110;
    parameter SLT_I_3 = 3'b010;
    input[2:0] F3;
    input[6:0] F7;
    input[2:0] AluOp;
    output[2:0] AluIn;
    assign AluIn = AluOp == 3'b0 ? ADD : AluOp == 3'b001 ? SUB : AluOp == 3'b010 ?
            ((F3 == ADD_3 & F7 == ADD_7) ? ADD :
            (F3 == SUB_3 & F7 == SUB_7) ? SUB :
            (F3 == AND_3 & F7 == AND_7) ? AND :
            (F3 == OR_3 & F7 == OR_7) ? OR :
            (F3 == SLT_3 & F7 == SLT_7) ? SUB : 3'b111) :
            AluOp == 3'b100 ? ((F3 == XOR_I_3) ? XOR : (F3 == OR_I_3) ? OR : 3'b111) : 3'b111;
endmodule

module PcController (Jump,BrOp,IsJalr,Zero,SignBit,PcIn);
    parameter BEQ_3 = 3'b0;
    parameter BNE_3 = 3'b001;
    parameter BGE_3 = 3'b101;
    parameter BLT_3 = 3'b100;
    input Jump, Zero, SignBit, IsJalr;
    input[2:0] BrOp;
    output[1:0] PcIn;
    assign PcIn = IsJalr ? 2'b10 : ((BrOp == BEQ_3 & Zero) | Jump | (BrOp == BNE_3 & ~Zero) | (BrOp == BLT_3 & SignBit) | (BrOp == BGE_3 & ~SignBit)) ? 2'b01 : 2'b00;
endmodule

module SignControl (SignBit,SignSel);
    input SignBit;
    output SignSel;
    assign SignSel = SignBit;
endmodule

module Controller (Op,F3,F7,Zero,SignBit,AluIn,PcIn,ImmSel,RegWrite,MemWrite,ResultSel,WdSel,SignSel,AluSel,Wd2Sel);
    parameter ADD_I_3 = 3'b0;
    parameter XOR_I_3 = 3'b100;
    parameter OR_I_3 = 3'b110;
    parameter SLT_I_3 = 3'b010;
    parameter LU_I_OP =7'b0110111;
    parameter B_TYPE_OP = 7'b1100011;
    parameter SW_OP =7'b0100011;
    parameter JALR_OP =7'b1100111;
    parameter R_TYPE_OP = 7'b0110011;
    parameter I_TYPE_ARITHMATIC_OP = 7'b0010011;
    parameter LW_OP = 7'b0000011;
    parameter JAL_OP =7'b1101111;
    parameter SLT_7 = 7'b0;
    parameter SLT_3 = 3'b010;

    input Zero, SignBit;
    input [2:0] F3;
    input [6:0] Op, F7;
    output WdSel, RegWrite, MemWrite, SignSel, AluSel, Wd2Sel;
    output[1:0] ResultSel, PcIn;
    output[2:0] ImmSel, AluIn;
    wire[2:0] AluOp;
    wire Jump, IsIType, IsJalr, IsSltI, IsSlt;
    AluController AC(.AluOp(AluOp),.F3(F3),.F7(F7),.AluIn(AluIn));
    PcController PC(.Jump(Jump),.BrOp(F3),.IsJalr(IsJalr),.Zero(Zero),.SignBit(SignBit),.PcIn(PcIn));
    SignControl SC(.SignSel(SignSel),.SignBit(SignBit));
    assign Jump = Op == JAL_OP;
    assign IsSlt = Op == R_TYPE_OP & F3 == SLT_3 & F7 == SLT_7;
    assign IsSltI = (Op == I_TYPE_ARITHMATIC_OP & F3 == SLT_I_3);
    assign IsJalr = Op == JALR_OP;
    assign IsIType = Op == LW_OP | Op == I_TYPE_ARITHMATIC_OP | Op == JALR_OP;
    assign AluOp = Op == R_TYPE_OP ? 3'b010 : (Op == LW_OP | (Op == I_TYPE_ARITHMATIC_OP & F3 == ADD_I_3) | Op == JALR_OP | Op == SW_OP) ? 3'b000 : 
                   (IsSltI | Op == B_TYPE_OP) ? 3'b001 : Op == I_TYPE_ARITHMATIC_OP ? 3'b100 : 3'b111;
    assign ImmSel = IsIType ? 3'b000 :
            Op == SW_OP ? 3'b001 : Op == B_TYPE_OP ? 3'b010 : Op == JAL_OP ? 3'b011 : Op == LU_I_OP ? 3'b100 : 3'b101;
    assign RegWrite = Op == R_TYPE_OP | IsIType | Op == LU_I_OP | IsJalr | Op == JAL_OP;
    assign MemWrite = Op == SW_OP;
    assign ResultSel = Op == LW_OP ? 2'b01 : IsSlt ? 2'b10 : 2'b00;
    assign AluSel = IsIType | Op == SW_OP;
    assign Wd2Sel = Op == LU_I_OP;
    assign WdSel = Op == JALR_OP | Op == JAL_OP;
endmodule


module CA2 (clk,rst);
    input clk,rst;
    wire reg_we, mem_we, m2_1_cnt, m2_2_cnt, m2_3_cnt,m2_4_cnt,Zero,SignBit;
    wire [6:0] Op, F7;
    wire[2:0] F3, imm_op, alu_op;
    wire[1:0] m4_2_cnt, m4_1_cnt;

    DataPath Dp(.clk(clk),.rst(rst),.imm_op(imm_op),.alu_op(alu_op),.reg_we(reg_we),.mem_we(mem_we),.m4_1_cnt(m4_1_cnt),.m4_2_cnt(m4_2_cnt),.m2_1_cnt(m2_1_cnt)
            ,.m2_2_cnt(m2_2_cnt),.m2_3_cnt(m2_3_cnt),.m2_4_cnt(m2_4_cnt),.Op(Op),.F3(F3),.Zero(Zero),.SignBit(SignBit),.F7(F7));
    Controller C(.Op(Op),.F3(F3),.F7(F7),.Zero(Zero),.SignBit(SignBit),.AluIn(alu_op),.PcIn(m4_1_cnt),.ImmSel(imm_op),.RegWrite(reg_we),.MemWrite(mem_we),.ResultSel(m4_2_cnt)
    ,.WdSel(m2_2_cnt),.SignSel(m2_3_cnt),.AluSel(m2_1_cnt),.Wd2Sel(m2_4_cnt));
endmodule
