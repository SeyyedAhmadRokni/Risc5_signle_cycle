module InstMemory(rst, a, inst);
    input [15:0] a;
    output reg [31:0] inst;
    wire [31:0] address;
    assign address = {16'b0,a};
    reg [31:0] im [16000:0];
    always @(posedge rst)begin
        $readmemb("C:/Users/SeyyedAhmadRokniHoss/Documents/CA_CA2/ram.txt", im);
    end

    always @(a)begin
        inst = im[address];
    end
endmodule