/*  AGH 2023 
 * 
 * Created by:
 * Pawel Zieba
 * 
 * Description:
 * Uart monitor module for tx and rx signals redirection through additionals output pins.
 */

`timescale 1 ns / 1 ps

module top_uart (
    input logic clk,
    input logic rst,
    input logic loopback_enable,
    input logic rx,

    output logic tx,
    output logic rx_monitor,
    output logic tx_monitor
);

/* ----------- UART MONITOR -----------*/

    logic tx_nxt;

    always_ff @(posedge clk) begin : monitor_blk
        if(rst) begin
            rx_monitor <= 1'b0;
            tx_monitor <= 1'b0;
        end
        else begin
            rx_monitor <= rx;
            tx_monitor <= tx;
        end
    end

    always_ff @(posedge clk) begin : tx_blk
        if(rst) begin
            tx <= 1'b0;
        end
        else begin
            tx <= tx_nxt;
        end
    end

    always_comb begin : tx_nxt_blk
        if(loopback_enable) begin
            tx_nxt = rx;
        end
        else begin
            tx_nxt = 1'b0;
        end
    end

/*-------------------------------------*/


    

endmodule