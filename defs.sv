package defs;
    // For the Baud Generator.
    parameter Clock_freq = 50_000_000;
    parameter baud_tick_1200 = Clock_freq / (1200*16);
    parameter baud_tick_2400 = baud_tick_1200 / 2;
    parameter baud_tick_4800 = baud_tick_2400 / 2;
    parameter baud_tick_9600 = baud_tick_4800 / 2;
    parameter baud_calc = $clog2(baud_tick_1200/2 + 1);    // The number of bits required to represent the next signals.

    // For the UART Receiver.
    parameter SAMPLE_CONST = 16;
    parameter N = SAMPLE_CONST - 1;
    parameter MID_POINT = (SAMPLE_CONST/2) - 1;
    parameter count_bits = $clog2(N);

    function void notify_baud();
        $display("Working with a Clock freqency of: %d, and The baud tick is every: %d clock cycles.", Clock_freq, baud_tick_1200);
        $display("Baud_Tick value for 1200: %d", baud_tick_1200);
        $display("Baud_Tick value for 2400: %d", baud_tick_2400);
        $display("Baud_Tick value for 4800: %d", baud_tick_4800);
        $display("Baud_Tick value for 9600: %d", baud_tick_9600);
        $display("The required number of bits to represent the tick rate is: %d", baud_calc);
    endfunction

    function void notify_receiver();
        $display("Working with an Oversampling of: %d ticks, and The sampling point at tick number: %d ", SAMPLE_CONST, MID_POINT);
        $display("The required number of bits to represent the Sampling Counter: %d", count_bits);
    endfunction
endpackage
