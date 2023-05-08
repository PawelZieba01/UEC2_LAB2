`timescale 1 ns / 1 ps

module top_uart_basys3 (
    input wire clk,
    input wire btnC,
    input wire sw,
    input wire RsRx,

    output wire RsTx,
    output wire [1:0] JA
);


    top_uart u_top_uart (
        .clk(clk),
        .rst(btnC),
        .loopback_enable(sw),
        .rx(RsRx),
        .tx(RsTx),
        .rx_monitor(JA[0]),
        .tx_monitor(JA[1])
    );

endmodule
