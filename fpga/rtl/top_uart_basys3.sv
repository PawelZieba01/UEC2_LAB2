`timescale 1 ns / 1 ps

module top_uart_basys3 (
    input logic clk,
    input logic btnC,
    input logic sw,
    input logic RsRx,
    input logic btnU,

    output logic RsTx,
    output logic [1:0] JA,

    output logic [3:0] an,
    output logic [6:0] seg,
    output logic dp
);


    top_uart u_top_uart (
        .clk(clk),
        .rst(btnC),
        .btnU,
        .loopback_enable(sw),
        .rx(RsRx),
        .tx(RsTx),
        .rx_monitor(JA[0]),
        .tx_monitor(JA[1]),
        .an,
        .dp,
        .seg
    );

endmodule
