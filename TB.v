module TB ();
    reg clk=0,rst=0;
    CA2 ca(clk,rst);
    always 
        #10 clk=~clk;
    initial begin
        #10 rst=1;
        #5 rst=0;
        #1000 $stop;
    end
endmodule