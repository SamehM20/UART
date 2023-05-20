module frame (
    input logic reset_n, 
    input logic d_num,
    input logic [7:0] data_in,
    input logic s_num,
    input logic [1:0] par,
    input logic parity_out,
    output logic [10:0] frame_out
);

always_comb begin
    if(!reset_n) frame_out = 0;
    else if(par==0) // Checking if there is a parity bit.
        if(d_num)   // Number of data bits 1 for 8 bits and 0 for 7 bits.
            frame_out = {1'b0, s_num?2'b11:2'b01, data_in[7:0]};
        else
            frame_out = {2'b00, s_num?2'b11:2'b01, data_in[6:0]};
    else 
        if(d_num)
            frame_out = {s_num?2'b11:2'b01, parity_out, data_in[7:0]};
        else
            frame_out = {1'b0, s_num?2'b11:2'b01, parity_out, data_in[6:0]};
end
endmodule