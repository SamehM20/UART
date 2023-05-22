import defs::*;
module UART_TOP (
    input logic reset_n, clk, 
    input logic [1:0] bd_rate,
    input logic send, rx
    input logic d_num, s_num,
    input logic [7:0] data_in,
    input logic [1:0] par,
    output logic parity_out, tick,
    output logic stream_out,
    output logic tx_active, tx_done,
    output logic [7:0] data_out,
    output logic rx_done, frame_error, parity_error
);
// Displaying the work parameters defined in the package 'defs'.
initial begin
    notify_receiver();
    notify_baud();
end
    
baud_gen baud_gen0(.*);
UART_TX uart_tx0(.*);
UART_RX uart_rx0(.*);
    

endmodule
