module RAM(din, rx_valid, clk, rst_n, tx_valid, dout);
parameter  ADDR_SIZE = 8,
	       MEM_DEPTH = 2**ADDR_SIZE;
input [ADDR_SIZE+1 : 0] din;
input rx_valid, clk, rst_n;
output reg tx_valid;
output reg [ADDR_SIZE-1 : 0] dout;

reg [ADDR_SIZE-1 : 0] mem[MEM_DEPTH-1 : 0], Address_Saver;

always @(posedge clk) begin
    if(~rst_n) begin
        dout     <= 0;
        tx_valid <= 0;
        Address_Saver <= 0;
    end
    else
        case(din[ADDR_SIZE+1])
        1'b0://Write command
        begin
            if(rx_valid) begin
                dout     <= 0;
                tx_valid <= 0;
                case(din[ADDR_SIZE])
                1'b0: Address_Saver      <= din[ADDR_SIZE-1 : 0];
                1'b1: mem[Address_Saver] <= din[ADDR_SIZE-1 : 0];
                endcase
            end
        end
        1'b1://Read command
        begin
            case(din[ADDR_SIZE])
            1'b0: 
            begin
                dout     <= 0;
                tx_valid <= 0;
                Address_Saver <= din[ADDR_SIZE-1 : 0];
            end
            1'b1: 
            begin
                dout     <= mem[Address_Saver];
                tx_valid <= 1;
            end
            endcase
        end
        endcase
end
endmodule