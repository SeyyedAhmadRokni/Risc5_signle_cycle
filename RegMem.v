module RegMem(clk, we, a1, a2, a3, wd, rd1, rd2);
    input clk, we;
    input [4:0] a1, a2, a3;
    input [31:0] wd;
    output reg [31:0] rd1, rd2;
    reg [31:0] regmem [4:0];
    always @(a1, a2, posedge clk)begin
        rd1 = regmem[a1];
        rd2 = regmem[a2];
        if (clk | we)
            regmem[a3] = wd;
      
    end

endmodule