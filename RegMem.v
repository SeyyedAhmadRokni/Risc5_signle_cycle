module RegMem(clk, we, a1, a2, a3, wd, rd1, rd2);
    input clk, we;
    input [4:0] a1, a2, a3;
    input [31:0] wd;
    output[31:0] rd1, rd2;
    reg [31:0] regmem [0:31];
    assign rd1 = regmem[a1];
    assign rd2 = regmem[a2];
    always @(posedge clk)begin
        if (clk & we)
            regmem[a3] = wd;      
    end

endmodule