import defs::*;
module baud_gen (
    input  logic clk, reset_n,
    input  logic [1:0] bd_rate,
    output logic tick
);

logic [baud_calc-1:0] baud_freq;    // Value of the clk cycles per tick.
logic [baud_calc-1:0] baud_count;   // Internal counter.

always_comb begin : selecting_baud_freq
    unique case (bd_rate)
        0:  baud_freq = baud_tick_1 /2;   
        1:  baud_freq = baud_tick_2 /2;   
        2:  baud_freq = baud_tick_3 /2;   
        3:  baud_freq = baud_tick_4 /2;   
    endcase
end

// Generating the baud tick.
always_ff @(posedge clk or negedge reset_n) begin 
    if(!reset_n) begin 
        baud_count <= 0;
        tick <= 0;
    end
    else if (baud_count == baud_freq) begin
        baud_count <= 0;
        tick <= ~tick;
    end
    else
        baud_count++; 
end
endmodule
