module InstMemory(a, inst);
    input [31:0] a;
    output reg [31:0] inst;
    wire [31:0] address;
    assign address = {16'b0,a};
    reg [31:0] im [16000:0];
    always @(a)begin
        inst = im[a];
    end
endmodule