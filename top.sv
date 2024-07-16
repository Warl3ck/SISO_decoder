`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 11:49:15 AM
// Design Name: 
// Module Name: top
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



module top(
        clk,
        rst,
        in,
        valid_in,
        valid_apriori,
        apriori,
        blklen,
		//
		init_branch1_t,
		init_branch2_t,
		valid_out,
    );

    input           clk;  
    input           rst; 
    input   [15:0]  in;
    input           valid_in;
    input           valid_apriori;
    input   [15:0]  blklen;
    input   [15:0]  apriori;
	output	[15:0]	init_branch1_t;
	output	[15:0]	init_branch2_t;
	output			valid_out;

    
    reg select;
    reg [15:0] parity_reg;
    reg [15:0] sys_reg, sys_reg_delay;
    reg valid_parity;
    reg valid_sys, valid_sys_delay;

    reg [15:0] sum_branch1, sub_branch2;
    reg [15:0] sum_branch1_round, sub_branch2_round;
    reg [15:0] div_branch1, div_branch2, div_branch1_i, div_branch2_i;
    reg [15:0] init_branch1, init_branch2;



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


    // init_branch
    assign sum_branch1 = (valid_parity & valid_sys_delay & valid_apriori) ? ((apriori + sys_reg_delay + parity_reg)) : sum_branch1;
    assign sub_branch2 = (valid_parity & valid_sys_delay & valid_apriori) ? ((apriori + sys_reg_delay - parity_reg)) : sub_branch2;

    // round
    assign sum_branch1_round = (sum_branch1[0] & sum_branch1[15]) ? sum_branch1 + 16'hFFFF : (sum_branch1[0] & !sum_branch1[15])  ? sum_branch1 + 1'b1 : sum_branch1;
    assign sub_branch2_round = (sub_branch2[0] & sub_branch2[15]) ? sub_branch2 + 16'hFFFF : (sub_branch2[0] & !sub_branch2[15])  ? sub_branch2 + 1'b1 : sub_branch2;

    // divider
    assign div_branch1 = sum_branch1_round >> 1 ;
    assign div_branch2 = sub_branch2_round >> 1;

    assign div_branch1_i = {div_branch1[14], div_branch1[14:0]};
    assign div_branch2_i = {div_branch2[14], div_branch2[14:0]};

    // divider round
    assign init_branch1 = (div_branch1_i[0] & div_branch1_i[15]) ? ~(div_branch1_i + 16'hFFFF) : ~div_branch1_i + 1'b1;
    assign init_branch2 = (div_branch2_i[0] & div_branch2_i[15]) ? ~(div_branch2_i + 16'hFFFF) : ~div_branch2_i + 1'b1;


	assign init_branch1_t = init_branch1;
	assign init_branch2_t = init_branch2;
    assign valid_out = select;
 
    


endmodule
