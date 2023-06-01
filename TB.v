module TB ();
    reg clk,rst;
    wire done;
    CA2 ca(clk,rst,done);
    always 
        #10 clk=~clk;
    initial begin
        #10 rst=1;
        #30 rst=0;
        #1000 
    end
endmodule