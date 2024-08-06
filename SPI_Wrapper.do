vlib work

vlog SPI_Wrapper.v SPI_Slave.v RAM.v GPR.v Counter.v SPI_Wrapper_tb.v

vsim -voptargs=+acc work.SPI_tb

add wave -position insertpoint  \
sim:/SPI_tb/clk_W_tb

add wave -position insertpoint  \
sim:/SPI_tb/rst_n_W_tb

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/SS_n

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/MOSI

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/cs

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/Counter_rst

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/SPI_Counter/start

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/counter_out

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/tx_valid

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/tx_data

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/RAM_Unit/dout

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/GPReg/Parallel_In_SR

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/GPReg/Load

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/GPR_Out

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/rx_data

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/rx_valid

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/RAM_Unit/din

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/Slave/MISO

add wave -position insertpoint  \
sim:/SPI_tb/SPI_W_tb/RAM_Unit/mem



run -all 
