module InstMemory(a, inst);
    input [31:0] a;
    output reg [31:0] inst;
    (* ram_file = "" *) reg [31:0] im [31:0];
    always @(a)begin
        inst = im[a];
    end
endmodule