module SPI_tb;
//Signals declaration
parameter WIDTH_tb = 8;
reg MOSI_W_tb, SS_n_W_tb, clk_W_tb, rst_n_W_tb;
wire MISO_W_tb;

//Module instantiation
SPI_Wrapper #(.WIDTH(WIDTH_tb)) SPI_W_tb(
    .MOSI_W(MOSI_W_tb), .SS_n_W(SS_n_W_tb), .clk_W(clk_W_tb), .rst_n_W(rst_n_W_tb), .MISO_W(MISO_W_tb)
);

reg [7:0] i;

initial begin
    clk_W_tb = 1;
    forever #1  clk_W_tb = ~clk_W_tb;
end

//Directed testing
initial begin
    rst_n_W_tb = 0;
    SS_n_W_tb = 0;  MOSI_W_tb = 0;
    @(negedge clk_W_tb);
    rst_n_W_tb = 1;
    //Write address and data then read address and data 
    //four successive times.
    repeat(4) begin
        i = 0;
        SS_n_W_tb = 0;  MOSI_W_tb = 0;
        @(negedge clk_W_tb);
        @(negedge clk_W_tb);
        MOSI_W_tb = 0;
        @(negedge clk_W_tb);
        MOSI_W_tb = 0;
        @(negedge clk_W_tb);
        //Test writing address (Randomized)
        repeat(WIDTH_tb) begin
            MOSI_W_tb = $random;
            i = (i << 1) | MOSI_W_tb;
            @(negedge clk_W_tb);
        end
        SS_n_W_tb = 1;
        @(negedge clk_W_tb);
        SS_n_W_tb = 0; MOSI_W_tb = 0;
        @(negedge clk_W_tb);
        @(negedge clk_W_tb);
        MOSI_W_tb = 0;
        @(negedge clk_W_tb);
        MOSI_W_tb = 1;
        @(negedge clk_W_tb);
        //Test writing data (Randomized)
        repeat(WIDTH_tb) begin
            MOSI_W_tb = $random;
            @(negedge clk_W_tb);
        end
        SS_n_W_tb = 1;
        @(negedge clk_W_tb);
        SS_n_W_tb = 0; MOSI_W_tb = 1;
        @(negedge clk_W_tb);
        @(negedge clk_W_tb);
        MOSI_W_tb = 1;
        @(negedge clk_W_tb);
        MOSI_W_tb = 0;
        @(negedge clk_W_tb);
        //Test read address  (Based on the previously entered one)
        repeat(WIDTH_tb) begin
            MOSI_W_tb = i[7];
            i = i << 1;
            @(negedge clk_W_tb);
        end
        SS_n_W_tb = 1;
        @(negedge clk_W_tb);
        SS_n_W_tb = 0; MOSI_W_tb = 1;
        @(negedge clk_W_tb);
        @(negedge clk_W_tb);
        MOSI_W_tb = 1;
        @(negedge clk_W_tb);
        MOSI_W_tb = 1;
        @(negedge clk_W_tb);
        //Test read data
        repeat(WIDTH_tb) begin
            MOSI_W_tb = $random;
            @(negedge clk_W_tb);
        end
        repeat(2*WIDTH_tb) begin
            @(negedge clk_W_tb);
        end
        SS_n_W_tb = 1;
        @(negedge clk_W_tb);
    end
    $stop;
end
endmodule