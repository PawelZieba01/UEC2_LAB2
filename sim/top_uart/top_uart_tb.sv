`timescale 1 ns / 1 ps

module top_uart_tb;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 10;     // 100 MHz


/**
 * Local variables and signals
 */

logic clk, rst;
logic rx, tx;
logic rx_monitor, tx_monitor;
logic loopback_enable;



/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end



/**
 * Submodules instances
 */

top_uart dut (
    .clk,
    .rst,
    .loopback_enable,
    .rx,
    .tx,
    .rx_monitor,
    .tx_monitor
);




/**
 * Main test
 */

initial begin
    $display("Start simulation.");
    loopback_enable = 1'b1;
    rst = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;

    

    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $finish;
end

endmodule
