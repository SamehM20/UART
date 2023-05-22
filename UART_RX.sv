import defs::*;
module UART_RX (
    input logic rx, reset_n, tick, d_num, s_num,
    input logic [1:0] par,
    output logic [7:0] data_out,
    output logic rx_done, frame_error, parity_error
);
logic [10:0] dout, stream_out;
logic [count_bits-1:0] samp_count;
logic [3:0] state_count;
logic int_tick, done, registered;
logic end_bit;
enum logic [1:0] {IDLE, DATA, PARITY, EOSTREAM} state, next;

// Controlling the Oversampling.
always_ff @(posedge tick, negedge reset_n) begin
    if(!reset_n) begin
        state <= IDLE;
        samp_count <= 0;
        state_count <= 0;
        int_tick <= 0;
    end
    else begin
        samp_count++;
        case(state)
            IDLE: if (rx == 0)
                    if (samp_count == MID_POINT) int_tick <= 1;
                    else int_tick <= 0;
                  else samp_count <= 0;
            default: if(samp_count == N) int_tick <= 1;
                    else int_tick <= 0;
        endcase
    end
end
 
// Controlling the states changes.
always_ff @(posedge int_tick, negedge reset_n) begin
    if(!reset_n) begin
        stream_out <= 0;
        rx_done <= 0;
    end else begin
        stream_out <= dout;
        rx_done <= done;
        state <= next;
        if(state == IDLE) state_count <= 0;
        else state_count++;   
    end
end
    
// Next state managing and data capture.
always_comb begin
    case (state)
        IDLE: begin 
            next = DATA;
            dout = 0;
            end_bit = 0;
            done = 0;
        end
        DATA: begin 
            dout[state_count-1] = rx;
            if(d_num && (state_count == 8)) begin 
                if((par == 2'b00) || (par == 2'b11)) next = EOSTREAM;
                else next = PARITY;
            end else if(!d_num && (state_count == 7)) begin
                if((par == 2'b00) || (par == 2'b11)) next = EOSTREAM;
                else next = PARITY;
            end
        end
        PARITY: begin 
            dout[state_count-1] = rx;
            next = EOSTREAM;
        end
        EOSTREAM: begin
            dout[state_count-1] = rx;
            if(!s_num || end_bit) begin 
                next = IDLE;
                end_bit = 0;
                done = 1;
            end else begin
                next = EOSTREAM;
                end_bit = 1;
            end
        end
    endcase
end
    
// Errors generation.
always_ff @(posedge tick, negedge reset_n) begin
    if(!reset_n) begin 
        registered <= 0;
        frame_error <= 0;
        parity_error <= 0;
        data_out <= 0;
    end else begin
    if(rx_done && (!registered)) begin
        parity_error <= 0;
        frame_error <= 1;
        if(d_num) data_out <= stream_out[7:0];
        else      data_out <= {1'b0, stream_out[6:0]};
        if(par==0 || par==3)
            case ({d_num, s_num})
                3: if(stream_out[10:8]==3'b011)  frame_error <= 0;
                2: if(stream_out[10:8]==3'b001)  frame_error <= 0;
                1: if(stream_out[10:7]==4'b0011) frame_error <= 0;
                0: if(stream_out[10:7]==4'b0001) frame_error <= 0;
            endcase
        else begin
            if(d_num) 
                if(par[0]) parity_error <= ~^(stream_out[8:0]); // Odd parity
                else parity_error <= ^(stream_out[8:0]);    // Even parity
            else 
                if(par[0]) parity_error <= ~^(stream_out[7:0]); // Odd parity
                else parity_error <= ^(stream_out[7:0]);    // Even parity
            case ({d_num, s_num})
                3: if(stream_out[10:9]==2'b11)  frame_error <= 0;
                2: if(stream_out[10:9]==2'b01)  frame_error <= 0;
                1: if(stream_out[10:8]==3'b011) frame_error <= 0;
                0: if(stream_out[10:8]==3'b001) frame_error <= 0;
            endcase  
        end
        registered <= 1;
    end else if(!rx_done) registered <= 0;
    end
end 
endmodule
