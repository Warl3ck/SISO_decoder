`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2024 16:38:48
// Design Name: 
// Module Name: sys_parity
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sys_parity 
(
    clk,
    rst,
    in,
    valid_in,
    parity,
    sys,
    valid_out
);

    input clk;
    input rst;
    input [15:0] in;
    input valid_in;
    output [15:0] parity;
    output [15:0] sys;
    output valid_out;
    
    reg select;
    reg [15:0] parity_reg;
    reg [15:0] sys_reg, sys_reg_delay;
    reg valid_parity;
    reg valid_sys, valid_sys_delay;



    // sys_parity
    always_ff @(posedge clk) 
    begin
        if (rst)
            select <= 1'b0;
        else if (valid_in)  
            select <= (!select) ? 1'b1 : 1'b0;    
    end

    assign parity_reg = (select) ? in : parity_reg;
    assign sys_reg = (!select) ? in : sys_reg; 

    assign valid_parity = (valid_in) ? select : 1'b0;
    assign valid_sys = (valid_in) ? !select : 1'b0;
    ////

    always_ff @(posedge clk)
    begin
        if (rst) begin
            sys_reg_delay <= {16{1'b0}};
            valid_sys_delay <= 1'b0;
        end else begin
            sys_reg_delay <= sys_reg;
            valid_sys_delay <= valid_sys;
        end
    end

    assign sys = sys_reg_delay;
    assign parity = parity_reg;
    assign valid_out = valid_sys_delay & valid_parity;

endmodule
