import defs::count_bits;
module tx_counter(
    input logic tick, reset_n, 
    output logic tick_tx    
);

logic [count_bits-1:0] Pcout;
assign tick_tx  = &Pcout;     

always_ff @(posedge tick or negedge reset_n) begin
    if(!reset_n)  Pcout <= 0;           // Resetting the counter.
    else Pcout++; 
    end
endmodule