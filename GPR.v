//Out_Mode values are either:
`define Parallel         0
`define Series           1
module GPR(Parallel_In_SR, Serial_In_SR, Load, clk_SR, rst_n_SR, Parallel_Out_SR);
parameter WIDTH_SR = 8;

input  [WIDTH_SR-3 : 0] Parallel_In_SR;
input  Serial_In_SR, Load, clk_SR, rst_n_SR;
output reg [WIDTH_SR-1 : 0] Parallel_Out_SR;

always @(posedge clk_SR) begin
    if(~rst_n_SR) 
        Parallel_Out_SR <= 0;
    else
        if(Load)
            Parallel_Out_SR <= {Parallel_In_SR, 2'b00};
        else
            Parallel_Out_SR <=(Parallel_Out_SR << 1) | Serial_In_SR;
            
end
endmodule