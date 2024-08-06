`define READ_ADD_CASE       0
`define READ_DATA_CASE      1
`define ACTIVE_LOW          0
`define ACTIVE_HIGH         1
`define CLEAR               0
`define SET                 1
module SPI_Slave(MOSI, MISO, SS_n, rx_data, rx_valid, tx_data, tx_valid, clk, rst_n);
parameter ADDR_SIZE  = 8;
localparam COUNTER_WIDTH = 5,
           IDLE      = 0,
           CHK_CMD   = 1,
           WRITE     = 2,
           READ_ADD  = 3,
           READ_DATA = 4;
input  MOSI, SS_n, tx_valid, clk, rst_n;
input  [ADDR_SIZE-1 : 0] tx_data;
output reg MISO;
output reg rx_valid;
output reg [ADDR_SIZE+1 : 0] rx_data;

wire [COUNTER_WIDTH-1 : 0] counter_out;
wire [ADDR_SIZE+1 : 0] GPR_Out;
reg Counter_rst, Load_GPR, Read_case;

(* fsm_encoding = "sequential" *)
//Choose gray, one_hot or sequential
reg [2:0] cs, ns;

//Counter instantiation
Counter #(.WIDTH(5)) SPI_Counter(.start((~SS_n)), .clk_c(clk), .rstn_c(Counter_rst), .count_c(counter_out));

//Shift register instantiation
GPR #(.WIDTH_SR(ADDR_SIZE+2)) GPReg(
    .Parallel_In_SR(tx_data), .Serial_In_SR(MOSI), .Load(Load_GPR), .clk_SR(clk),
    .rst_n_SR(rst_n), .Parallel_Out_SR(GPR_Out)
);

//Memory stage logic + Output logic
always @(posedge clk) begin
    if(~rst_n) begin
        cs <= IDLE;
        rx_data  <= `CLEAR;
        rx_valid <= `CLEAR;
        Read_case <= `READ_ADD_CASE;
        MISO <= `CLEAR;
        Load_GPR <= `CLEAR;
    end
    else begin
        cs <= ns;
        if(cs == IDLE) begin
            rx_data  <= 0;
            rx_valid <= 0;
        end
        if(cs == WRITE || cs == READ_ADD) begin
            if(counter_out == ADDR_SIZE+3) begin
                rx_data  <= GPR_Out;
                rx_valid <= 1;
                if(cs == READ_ADD)
                    Read_case <= ~Read_case;
            end
        end
        else if(cs == READ_DATA) begin
            if(~tx_valid) begin
                if(counter_out == ADDR_SIZE+3) begin
                    rx_data  <= GPR_Out;
                    rx_valid <= 1;
                end
            end
            else if(tx_valid) begin
                if(counter_out == ADDR_SIZE+5)
                    Load_GPR <= `SET;
                else if(counter_out == 15)
                    Load_GPR <= `CLEAR;
                else begin
                    MISO <= GPR_Out[ADDR_SIZE+1];
                    if(counter_out == ADDR_SIZE+19) begin
                        Read_case <= ~Read_case;
                    end
                end
            end
        end
    end
end

//Next state logic
always @(*) begin
    case(cs)
    IDLE: 
    begin
        Counter_rst = 0;
        if(~SS_n)
            ns = CHK_CMD; 
    end
    CHK_CMD:
    begin
        if(SS_n)
            ns = IDLE;
        else begin
            if(~MOSI)
                ns = WRITE;
            else begin
                if(~Read_case)
                    ns = READ_ADD;
                else
                    ns = READ_DATA;
            end
            Counter_rst = 1;
        end
    end   
    WRITE: 
        if(SS_n) begin
            Counter_rst = 0;
            ns = IDLE;  
        end
    READ_ADD:
        if(SS_n) begin
            Counter_rst = 0;
            ns = IDLE;  
        end
    READ_DATA:
        if(SS_n) begin
            Counter_rst = 0;
            ns = IDLE; 
        end
    default: ns = IDLE;
    endcase
end


endmodule