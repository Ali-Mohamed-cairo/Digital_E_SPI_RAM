module Counter(start, clk_c, rstn_c, count_c);
//parameter MAX_COUNT = 15;
parameter WIDTH = 4;
input clk_c, rstn_c, start;
output reg [WIDTH-1 : 0] count_c;

always @(posedge clk_c) begin
    if(~rstn_c)
        count_c <= 0;
    else
        if(start)
            count_c <= count_c + 1;
end 

endmodule