/*  AGH 2023 
 * 
 * Created by:
 * Pawel Zieba
 * 
 * Description:
 * Uart monitor module for tx and rx signals redirection through additionals output pins.
 * Support of 7-seg display and resending last recieved byte.
 */

`timescale 1 ns / 1 ps

module top_uart (
    input logic clk,
    input logic rst,
    input logic loopback_enable,
    input logic rx,
    input logic btnU,

    output logic tx,
    output logic rx_monitor,
    output logic tx_monitor,

    output logic [3:0] an,
    output logic [6:0] seg,
    output logic dp
);

    logic tx_nxt;
    logic tx_uart;

    logic rd_uart, wr_uart, wr_uart_nxt;
    logic [7:0] w_data, w_data_nxt;
    logic tx_full, rx_empty;
    logic [7:0] r_data;

    logic [3:0] hex3, hex2, hex1, hex0;
    logic [3:0] hex3_nxt, hex2_nxt, hex1_nxt, hex0_nxt;

    logic db_btnU;


/* ----------- UART MONITOR -----------*/
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
            tx_nxt = tx_uart;
        end
    end
/*-------------------------------------*/

debounce u_debounce (
    .clk,
    .reset(rst),
    .sw(btnU),
    .db_level(),
    .db_tick(db_btnU)
);

uart #( .DBIT(8),
        .SB_TICK(16),
        .DVSR(54),
        .DVSR_BIT(7),
        .FIFO_W(1) 
        )
u_uart (
    .clk,
    .reset(rst),
    .rd_uart,
    .wr_uart,
    .rx,
    .tx(tx_uart),
    .w_data,
    .tx_full,
    .rx_empty,
    .r_data
);

disp_hex_mux u_disp_hex_mux (
    .clk,
    .reset(rst),
    .hex0,
    .hex1,
    .hex2,
    .hex3,
    .dp_in(4'b1111),
    .an,
    .sseg({dp, seg})
);
    

/* SIGNALS ASSIGMENTS*/
assign rd_uart = !rx_empty;
/* ----------------- */


always_ff @(posedge clk) begin : hex_blk
    if(rst) begin
        hex0 <= 4'b0;
        hex1 <= 4'b0;
        hex2 <= 4'b0;
        hex3 <= 4'b0;
    end
    else begin
        hex0 <= hex0_nxt;
        hex1 <= hex1_nxt;
        hex2 <= hex2_nxt;
        hex3 <= hex3_nxt;
    end
end

always_comb begin : hex_nxt_blk
    if(rx_empty == 0) begin
        hex0_nxt = r_data[3:0];
        hex1_nxt = r_data[7:4];
        hex2_nxt = hex0;
        hex3_nxt = hex1;
    end
    else begin
        hex0_nxt = hex0;
        hex1_nxt = hex1;
        hex2_nxt = hex2;
        hex3_nxt = hex3;
    end
end

always_ff @(posedge clk) begin : tx_data_blk
    if(rst) begin
        w_data <= '0;
        wr_uart <= '0;
    end
    else begin
        w_data <= w_data_nxt;
        wr_uart <= wr_uart_nxt;
    end
end

always_comb begin : tx_data_nxt
    if(db_btnU) begin
        w_data_nxt = {hex1, hex0};     //last recieved byte
        wr_uart_nxt = 1'b1;
    end
    else begin
        w_data_nxt = '0;
        wr_uart_nxt = 1'b0;
    end
end
endmodule