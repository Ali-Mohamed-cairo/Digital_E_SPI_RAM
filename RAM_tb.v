module RAM_test;
parameter MEM_DEPTH_tb = 15,
          ADDR_SIZE_tb = 8;
//Signals declarations
reg [ADDR_SIZE_tb+1 : 0] din_tb;
reg rx_valid_tb, clk_tb, rst_n_tb;
wire tx_valid_tb;
wire [ADDR_SIZE_tb-1 : 0] dout_tb;

//Module instantiation
RAM #(.MEM_DEPTH(MEM_DEPTH_tb), .ADDR_SIZE(ADDR_SIZE_tb)) R(
    .din(din_tb), .rx_valid(rx_valid_tb), .clk(clk_tb), .rst_n(rst_n_tb), .tx_valid(tx_valid_tb), .dout(dout_tb)
);

initial begin
    clk_tb = 1;
    forever #1 clk_tb =~clk_tb;
end

initial begin
    rst_n_tb = 0;
    din_tb = 14; rx_valid_tb = 1;
    @(negedge clk_tb);
    rst_n_tb = 1;
    @(negedge clk_tb);
    repeat(10) begin
        din_tb = $random; rx_valid_tb = $random;
        @(negedge clk_tb);        
    end
    $stop;
end

endmodule