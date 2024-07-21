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



module top 
(
    clk,
    rst,
    in,
    valid_in,
    valid_apriori,
    apriori,
    blklen,
    valid_blklen,
	// check init_branch module
	// init_branch1_t,
	// init_branch2_t,
	// valid_out,
    // check alpha module
    // alpha_0,
    // alpha_1,
    // alpha_2,
    // alpha_3,
    // alpha_4,
    // alpha_5,
    // alpha_6,
    // alpha_7,
	valid_extrinsic,
	extrinsic
);

    input           clk;  
    input           rst; 
    input   [15:0]  in;
    input           valid_in;
    input           valid_apriori;
    input   [15:0]  blklen;
    input           valid_blklen;
    input   [15:0]  apriori;
    //
	// output	[15:0]	init_branch1_t;
	// output	[15:0]	init_branch2_t;
	// output			valid_out;
    // output [15:0] alpha_0;
    // output [15:0] alpha_1;
    // output [15:0] alpha_2;
    // output [15:0] alpha_3;
    // output [15:0] alpha_4;
    // output [15:0] alpha_5;
    // output [15:0] alpha_6;
    // output [15:0] alpha_7;
	output valid_extrinsic;
	output [15:0] extrinsic;

    wire [15:0] sys;
    wire [15:0] parity;
    wire sys_parity_valid;
    wire [15:0] init_branch1, init_branch2;
    wire valid_branch_i;
	wire valid_alpha_i;
	wire [15:0] alpha_0_i, alpha_1_i, alpha_2_i, alpha_3_i, alpha_4_i, alpha_5_i, alpha_6_i, alpha_7_i;

    sys_parity sys_parity_inst
    (
        .clk                (clk),
        .rst                (rst),
        .in                 (in),
        .valid_in           (valid_in),
        .parity             (parity),
        .sys                (sys),
        .valid_out          (sys_parity_valid)
    );

    init_branch init_branch_inst
    (
        .clk                (clk),
        .rst                (rst),
        .valid_sys_parity   (sys_parity_valid),
        .valid_apriori      (valid_apriori),
        .apriori            (apriori),
        .sys                (sys),
        .parity             (parity),
        .init_branch1       (init_branch1),
        .init_branch2       (init_branch2),
        .valid_branch       (valid_branch_i)
    );


    alpha alpha_inst
    (
        .clk                (clk),
        .rst                (rst),
        .valid_branch       (valid_branch_i),
        .init_branch1       (init_branch1),
        .init_branch2       (init_branch2),
        .alpha_0            (alpha_0_i),
        .alpha_1            (alpha_1_i),
        .alpha_2            (alpha_2_i),
        .alpha_3            (alpha_3_i),
        .alpha_4            (alpha_4_i),
        .alpha_5            (alpha_5_i),
        .alpha_6            (alpha_6_i),
        .alpha_7            (alpha_7_i),
        .valid_alpha        (valid_alpha_i)
    );

    beta_llr beta_llr_inst 
    (
        .clk                (clk),
        .rst                (rst),
		.apriori			(apriori),
		.valid_apriori		(valid_apriori),
        .sys                (sys),
        .valid_sys          (sys_parity_valid),
        .valid_branch       (valid_branch_i),
        .init_branch1       (init_branch1),
        .init_branch2       (init_branch2),
        //
        .alpha_0		    (alpha_0_i),
    	.alpha_1		    (alpha_1_i),
    	.alpha_2		    (alpha_2_i),
    	.alpha_3		    (alpha_3_i),
    	.alpha_4		    (alpha_4_i),
    	.alpha_5		    (alpha_5_i),
    	.alpha_6		    (alpha_6_i),
    	.alpha_7		    (alpha_7_i),
    	.valid_alpha	    (valid_alpha_i),
        //
        .valid_blklen   	(valid_blklen),
        .blklen         	(blklen),
		.valid_extrinsic	(valid_extrinsic),
		.extrinsic			(extrinsic)
    );

	// assign init_branch1_t = init_branch1;
	// assign init_branch2_t = init_branch2;
    // assign valid_out = valid_branch_i;

	// assign alpha_0 = alpha_0_i;
    // assign alpha_1 = alpha_1_i;
    // assign alpha_2 = alpha_2_i;
    // assign alpha_3 = alpha_3_i;
    // assign alpha_4 = alpha_4_i;
    // assign alpha_5 = alpha_5_i;
    // assign alpha_6 = alpha_6_i;
    // assign alpha_7 = alpha_7_i;

endmodule
