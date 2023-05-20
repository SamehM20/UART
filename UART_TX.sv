module UART_TX (
    input logic reset_n, tick,
    input logic send,
    input logic d_num,
    input logic [7:0] data_in,
    input logic s_num,
    input logic [1:0] par,
    output logic parity_out,
    output logic stream_out,
    output logic tx_active, tx_done
);
logic [10:0] frame_out;
logic [11:0] frame_full;        // Frame including the start bit.
logic [3:0] count;
logic [1:0] count_end;
logic tick_tx;
frame fram0(.*);
parity_chk parity(.*);
tx_counter counter(.*);

typedef enum logic [1:0] {IDLE, STREAM, EOSTREAM} state_t;
state_t state, next;
assign tx_active = ~(state == IDLE);
assign tx_done   = (state == EOSTREAM);
assign frame_full = {frame_out, 1'b0};      // Adding the start bit.

always_ff @(posedge tick_tx, negedge reset_n) begin
    if(!reset_n) begin 
                    state <= IDLE;
                    count <= 0;
                 end
    else begin
        if(state == STREAM) count++;
        else count <= 0;
        state <= next;
    end   
end

always_comb begin   // Calculating required cycles before end bits.
    case ({d_num, s_num, par})
        4'b0000, 4'b0011: count_end = 0;  // 8 bits:  7 bits data, 1 stop bit, no parity.
        4'b0100, 4'b0111: count_end = 1;  // 9 bits:  7 bits data, 2 stop bit, no parity.
        4'b1000, 4'b1011: count_end = 1;  // 9 bits:  8 bits data, 1 stop bit, no parity.
        4'b1100, 4'b1111: count_end = 2;  // 10 bits:  8 bits data, 2 stop bit, no parity.
        4'b0001, 4'b0010: count_end = 1;  // 9 bits:  7 bits data, 1 stop bit, 1 bit parity.
        4'b0101, 4'b0110: count_end = 2;  // 10 bits:  7 bits data, 2 stop bit, 1 bit parity.
        4'b1001, 4'b1010: count_end = 2;  // 10 bits:  8 bits data, 1 stop bit, 1 bit parity.
        4'b1101, 4'b1110: count_end = 3;  // 11 bits:  8 bits data, 2 stop bit, 1 bit parity.
    endcase
end

always_comb begin
    case (state)
        IDLE:     begin 
                      stream_out = 1;
                      if(send) next = STREAM;
                      else next = IDLE;
                  end
        STREAM:   begin
                      stream_out = frame_full[count];
                      case (count_end)
                          0: if(count == 8)  next = EOSTREAM;
                          1: if(count == 9)  next = EOSTREAM;
                          2: if(count == 10) next = EOSTREAM;
                          3: if(count == 11) next = EOSTREAM;
                      endcase
                  end
        EOSTREAM: begin
                      stream_out = 1;
                      next = IDLE;
                  end 
    endcase
end

endmodule