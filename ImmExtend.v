module ImmExtend(op, inp, out);
    input [2:0] op;
    input [31:0]inp;
    output reg [31:0] out;
    always @(op)begin
        case(op)
            3'b000 : out = {{20{inp[31]}}, inp[31:20]};
            3'b001 : out = {{20{inp[31]}}, inp[31:25], inp[11:7]};
            3'b010 : out = {{20{inp[31]}}, inp[7], inp[30:25], inp[11:8], 1'b0};
            3'b011 : out = {{12{inp[31]}}, inp[31:12]};
            3'b011 : out = {{12{inp[31]}}, inp[31], inp[22:15], inp[23], inp[30]};
            3'b011 : out = {inp[31:12], 12'b0};
        endcase
    end
endmodule