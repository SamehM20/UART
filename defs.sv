package defs;
    // For the Baud Generator.
    parameter Clock_freq = 50_000_000;
    // Note 'baud_1' must be the slowest baud rate or change the parameter 'baud_tick_1' in 'baud_calc' to whatever the slowest.
    parameter baud_1 = 1200;
    parameter baud_2 = 2400;
    parameter baud_3 = 4800;
    parameter baud_4 = 9600;
    parameter baud_tick_1 = Clock_freq / (baud_1*16);
    parameter baud_tick_2 = Clock_freq / (baud_2*16);
    parameter baud_tick_3 = Clock_freq / (baud_3*16);
    parameter baud_tick_4 = Clock_freq / (baud_4*16);
    parameter baud_calc = $clog2(baud_tick_1/2 + 1);    // The number of bits required to represent the next signals.

    // For the UART Receiver.
    parameter SAMPLE_CONST = 16;
    parameter N = SAMPLE_CONST - 1;
    parameter MID_POINT = (SAMPLE_CONST/2) - 1;
    parameter count_bits = $clog2(N);

    function void notify_baud();
        $display("Working with a Clock freqency of: %d, and The slowest baud tick is every: %d clock cycles.", Clock_freq, baud_tick_1);
        $display("Baud_Tick value for %d: %d", baud_1, baud_tick_1);
        $display("Baud_Tick value for %d: %d", baud_2, baud_tick_2);
        $display("Baud_Tick value for %d: %d", baud_3, baud_tick_3);
        $display("Baud_Tick value for %d: %d", baud_4, baud_tick_4);
        $display("The required number of bits to represent the tick rate is: %d", baud_calc);
    endfunction

    function void notify_receiver();
        $display("Working with an Oversampling of: %d ticks, and The sampling point at tick number: %d ", SAMPLE_CONST, MID_POINT);
        $display("The required number of bits to represent the Sampling Counter: %d", count_bits);
    endfunction
endpackage
