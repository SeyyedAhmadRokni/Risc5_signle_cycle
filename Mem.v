module Mem(clk, rst, a, we, wd, out);
    input clk, we;
    input [31:0] wd;
    input [15:0] a;
    wire [31:0] address;
    assign address = {16'b0,a};
    output reg [31:0] out;
    reg [31:0] mem [16000:0];

    always @(a, posedge clk, posedge rst)begin
        if (rst)begin
            $readmemb("C:/Users/SeyyedAhmadRokniHoss/Documents/CA_CA2/ram.txt", mem);
        end
        else begin
            out = mem[address];
            if (clk & we)
                mem[address] = wd;
        end
    end
endmodule



