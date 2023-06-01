module ram_(rst, add, out);
    input rst;
    input [2:0] add;
    reg [7:0] mem [7:0];
    output reg [7:0] out;
    always@(posedge rst)begin
        $readmemb("C:/Users/SeyyedAhmadRokniHoss/Documents/CA_CA2/ram.txt", mem);
    end

    always@(add) begin
        out = mem[add];
    end

endmodule