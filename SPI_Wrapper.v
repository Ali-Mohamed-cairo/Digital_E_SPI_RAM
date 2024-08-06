module SPI_Wrapper(MOSI_W, SS_n_W, clk_W, rst_n_W, MISO_W);
parameter WIDTH = 8;
input MOSI_W, SS_n_W, clk_W, rst_n_W;
output MISO_W;

wire [WIDTH+1 : 0] rx_data_W; 
wire rx_valid_W, tx_valid_W;
wire [WIDTH-1 : 0] tx_data_W;


//Modules instantiations
SPI_Slave #(.ADDR_SIZE(WIDTH)) Slave(
    .MOSI(MOSI_W), .MISO(MISO_W), .SS_n(SS_n_W), .rx_data(rx_data_W), .rx_valid(rx_valid_W), 
    .tx_data(tx_data_W), .tx_valid(tx_valid_W), .clk(clk_W), .rst_n(rst_n_W)
);


RAM #(.ADDR_SIZE(WIDTH)) RAM_Unit(
    .din(rx_data_W), .rx_valid(rx_valid_W), .clk(clk_W), .rst_n(rst_n_W), .tx_valid(tx_valid_W), .dout(tx_data_W)
);

endmodule