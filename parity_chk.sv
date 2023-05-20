module parity_chk (
    input logic [7:0] data_in,
    input logic [1:0] par,   // 0 is for no parity, 1 is for odd parity and 2 is for even parity.
    input logic reset_n, d_num, 
    output logic parity_out
);
logic even_par;
assign even_par = d_num?(^(data_in)):(^(data_in[6:0]));
assign parity_out = (reset_n)?((par==2)?even_par:(par==1)?!even_par:0):0;
endmodule