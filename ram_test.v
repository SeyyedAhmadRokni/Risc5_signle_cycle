module ram_test;
    reg rst;
    reg [2:0] add;
    wire [7:0] out;
    ram_ r(rst, add, out);
    initial begin
        #10
        rst = 1;
        #10;
        rst = 0;
        #10;
        add = 3'b000;
        #10;
        add = 3'b001;
        #10;
        add = 3'b010;
        #10;
        add = 3'b011;
        #10;
        add = 3'b100;
        #10;
    end
endmodule