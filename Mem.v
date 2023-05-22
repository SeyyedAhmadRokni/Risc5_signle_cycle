module Mem(clk, a, we, wd, out);
    input clk, we;
    input [31:0] a, wd;
    output reg [31:0] out;
    (* ram_file = "" *) reg [31:0] mem [31:0];
    always @(a, posedge clk)begin
        out = mem[a];
        if (clk & we)
            mem[a] = wd;
    end
endmodule