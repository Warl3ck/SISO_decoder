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
	init_branch1_t,
	init_branch2_t,
	valid_out,
    // check alpha module
    alpha_0,
    alpha_1,
    alpha_2,
    alpha_3,
    alpha_4,
    alpha_5,
    alpha_6,
    alpha_7
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
	output	[15:0]	init_branch1_t;
	output	[15:0]	init_branch2_t;
	output			valid_out;
    //
    output [15:0] alpha_0;
    output [15:0] alpha_1;
    output [15:0] alpha_2;
    output [15:0] alpha_3;
    output [15:0] alpha_4;
    output [15:0] alpha_5;
    output [15:0] alpha_6;
    output [15:0] alpha_7;

    wire [15:0] sys;
    wire [15:0] parity;
    wire sys_parity_valid;
    wire [15:0] init_branch1, init_branch2;
    wire valid_branch_i;
	wire valid_alpha_i;
	wire [15:0] alpha_0_i, alpha_1_i, alpha_2_i, alpha_3_i, alpha_4_i, alpha_5_i, alpha_6_i, alpha_7_i;

    wire [15:0] init_branch_srl1_i [0:515];
    wire [15:0] init_branch_srl2_i [0:515];
    wire [15:0] counter_reg_i;

    wire [15:0] beta_reg_0_i [0:516];
    wire [15:0] beta_reg_1_i [0:516];
    wire [15:0] beta_reg_2_i [0:516];
    wire [15:0] beta_reg_3_i [0:516];
    wire [15:0] beta_reg_4_i [0:516];
    wire [15:0] beta_reg_5_i [0:516];
    wire [15:0] beta_reg_6_i [0:516];
    wire [15:0] beta_reg_7_i [0:516];

    wire [1:0] fsm_state_i;

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
        .init_branch_srl1_i (init_branch_srl1_i),
        .init_branch_srl2_i (init_branch_srl2_i),
        .counter_reg_i      (counter_reg_i),
        .beta_reg_0_i       (beta_reg_0_i),
        .beta_reg_1_i       (beta_reg_1_i),
        .beta_reg_2_i       (beta_reg_2_i),
        .beta_reg_3_i       (beta_reg_3_i),
        .beta_reg_4_i       (beta_reg_4_i),
        .beta_reg_5_i       (beta_reg_5_i),
        .beta_reg_6_i       (beta_reg_6_i),
        .beta_reg_7_i       (beta_reg_7_i),
        //
        .valid_blklen   	(valid_blklen),
        .blklen         	(blklen)
    );

	// module LLR 
	// (
	// 	clk,
	// 	rst,
	// 	valid_branch,
    //     init_branch1,
    //     init_branch2,
	// 	alpha_0,
    // 	alpha_1,
    // 	alpha_2,
    // 	alpha_3,
    // 	alpha_4,
    // 	alpha_5,
    // 	alpha_6,
    // 	alpha_7,
    // 	valid_alpha,
    //     init_branch_srl1, 
    //     init_branch_srl2,
    //     counter_reg,
    //     beta_reg_0,
    //     beta_reg_1,
    //     beta_reg_2,
    //     beta_reg_3,
    //     beta_reg_4,
    //     beta_reg_5,
    //     beta_reg_6,
    //     beta_reg_7
    // );  

	// input clk;
    // input rst;
    // input [15:0] init_branch1;
    // input [15:0] init_branch2;
    // input valid_branch;
	// input [15:0] alpha_0;
    // input [15:0] alpha_1;
    // input [15:0] alpha_2;
    // input [15:0] alpha_3;
    // input [15:0] alpha_4;
    // input [15:0] alpha_5;
    // input [15:0] alpha_6;
    // input [15:0] alpha_7;
    // input valid_alpha;
    // input [15:0] init_branch_srl1 [0:515];
    // input [15:0] init_branch_srl2 [0:515];
    // input [15:0] counter_reg;
    // input [15:0] beta_reg_0 [0:516];
    // input [15:0] beta_reg_1 [0:516];
    // input [15:0] beta_reg_2 [0:516];
    // input [15:0] beta_reg_3 [0:516];
    // input [15:0] beta_reg_4 [0:516];
    // input [15:0] beta_reg_5 [0:516];
    // input [15:0] beta_reg_6 [0:516];
    // input [15:0] beta_reg_7 [0:516];

    // reg [15:0] alpha_i [8][0:515];
    // reg [15:0] llr_1 [8];
    // reg [15:0] llr_2 [8];
    // reg [15:0] llr_1_max_0 [4];
    // reg [15:0] llr_2_max_0 [4];
    // reg [15:0] llr_1_max_1 [2];
    // reg [15:0] llr_2_max_1 [2];
    // reg [15:0] llr_1_max_2;
    // reg [15:0] llr_2_max_2;
    // reg [15:0] llr_i;
    // reg [15:0] counter_alpha = 0;

    // ///////////////////////////////////// LLR 

	// always_ff @(posedge clk) begin
	// if (valid_alpha) begin
    //     for (int i = 0; i < 516; i++) begin
	// 	    alpha_i[0] <= {alpha_0, alpha_i[0][0:514]};
    //         alpha_i[1] <= {alpha_1, alpha_i[1][0:514]};
	// 	    alpha_i[2] <= {alpha_2, alpha_i[2][0:514]};
	// 	    alpha_i[3] <= {alpha_3, alpha_i[3][0:514]};
	// 	    alpha_i[4] <= {alpha_4, alpha_i[4][0:514]};
	// 	    alpha_i[5] <= {alpha_5, alpha_i[5][0:514]};
	// 	    alpha_i[6] <= {alpha_6, alpha_i[6][0:514]};
	// 	    alpha_i[7] <= {alpha_7, alpha_i[7][0:514]};
    //     end
	// end
	// end


    // always_ff @(posedge clk) begin
    // if (counter_reg > 516) begin
    //     // max(1)
    //     llr_1[0] <= $signed(alpha_i[0][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_4[counter_alpha]);  // beta_reg - 1 because name [0:7]
    //     llr_1[1] <= $signed(alpha_i[1][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_0[counter_alpha]);
    //     // max(2)
    //     llr_1[2] <= $signed(alpha_i[2][counter_alpha] - init_branch_srl2[counter_alpha] + beta_reg_1[counter_alpha]);
    //     llr_1[3] <= $signed(alpha_i[3][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_5[counter_alpha]);
    //     // max(3) 
    //     llr_1[4] <= $signed(alpha_i[4][counter_alpha] - init_branch_srl2[counter_alpha] + beta_reg_6[counter_alpha]);
    //     llr_1[5] <= $signed(alpha_i[5][counter_alpha] - init_branch_srl2[counter_alpha] + beta_reg_2[counter_alpha]);
    //     // max(4)
    //     llr_1[6] <= $signed(alpha_i[6][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_3[counter_alpha]);
    //     llr_1[7] <= $signed(alpha_i[7][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_7[counter_alpha]);
    //     ///////////////////////////////
    //     // max(1)
    //     llr_2[0] <= $signed(alpha_i[0][counter_alpha] + init_branch_srl1[counter_alpha] + beta_reg_0[counter_alpha]); 
    //     llr_2[1] <= $signed(alpha_i[1][counter_alpha] + init_branch_srl1[counter_alpha] + beta_reg_4[counter_alpha]);
    //     // max(2)
    //     llr_2[2] <= $signed(alpha_i[2][counter_alpha] + init_branch_srl2[counter_alpha] + beta_reg_5[counter_alpha]);
    //     llr_2[3] <= $signed(alpha_i[3][counter_alpha] + init_branch_srl2[counter_alpha] + beta_reg_1[counter_alpha]);
    //     // max(3) 
    //     llr_2[4] <= $signed(alpha_i[4][counter_alpha] + init_branch_srl2[counter_alpha] + beta_reg_2[counter_alpha]);
    //     llr_2[5] <= $signed(alpha_i[5][counter_alpha] + init_branch_srl2[counter_alpha] + beta_reg_6[counter_alpha]);
    //     // max(4)
    //     llr_2[6] <= $signed(alpha_i[6][counter_alpha] + init_branch_srl1[counter_alpha] + beta_reg_7[counter_alpha]);
    //     llr_2[7] <= $signed(alpha_i[7][counter_alpha] + init_branch_srl1[counter_alpha] + beta_reg_3[counter_alpha]);

    //     counter_alpha <= counter_alpha + 1;  
    // end
    // end

    // always_ff @(posedge clk) begin
    // if (counter_alpha > 0) begin
    //     for (int i = 0; i < 4; i++) begin
    //         llr_1_max_0[i] <= ($signed(llr_1[(i*2)+1]) > $signed(llr_1[(i*2)])) ? llr_1[(i*2)+1] : llr_1[i*2];
    //         llr_2_max_0[i] <= ($signed(llr_2[(i*2)+1]) > $signed(llr_2[(i*2)])) ? llr_2[(i*2)+1] : llr_2[i*2];
    //     end
    // end
    // end

    // always_ff @(posedge clk) begin
    // if (counter_alpha > 1) begin
    //     for (int i = 0; i < 2; i++) begin
    //         llr_1_max_1[i] <= ($signed(llr_1_max_0[(i*2)+1]) > $signed(llr_1_max_0[(i*2)])) ? llr_1_max_0[(i*2)+1] : llr_1_max_0[i*2];
    //         llr_2_max_1[i] <= ($signed(llr_2_max_0[(i*2)+1]) > $signed(llr_2_max_0[(i*2)])) ? llr_2_max_0[(i*2)+1] : llr_2_max_0[i*2];
    //     end
    // end
    // end

    // always_ff @(posedge clk) begin
    // if (counter_alpha > 2) begin
    //         llr_1_max_2 <= ($signed(llr_1_max_1[0]) > $signed(llr_1_max_1[1])) ? llr_1_max_1[0] : llr_1_max_1[1];
    //         llr_2_max_2 <= ($signed(llr_2_max_1[0]) > $signed(llr_2_max_1[1])) ? llr_2_max_1[0] : llr_2_max_1[1];
    //         llr_i <= $signed(llr_1_max_2 - llr_2_max_2);
    // end
    // end




	// endmodule


	// LLR LLR_inst
	// (
	// 	.clk                (clk),
    //     .rst                (rst),
    //     .valid_branch       (valid_branch_i),
    //     .init_branch1       (init_branch1),
    //     .init_branch2       (init_branch2),
	// 	.alpha_0		    (alpha_0_i),
    // 	.alpha_1		    (alpha_1_i),
    // 	.alpha_2		    (alpha_2_i),
    // 	.alpha_3		    (alpha_3_i),
    // 	.alpha_4		    (alpha_4_i),
    // 	.alpha_5		    (alpha_5_i),
    // 	.alpha_6		    (alpha_6_i),
    // 	.alpha_7		    (alpha_7_i),
    // 	.valid_alpha	    (valid_alpha_i),
    //     .counter_reg        (counter_reg_i),
    //     .init_branch_srl1   (init_branch_srl1_i), 
    //     .init_branch_srl2   (init_branch_srl1),
    //     .beta_reg_0         (beta_reg_0_i),
    //     .beta_reg_1         (beta_reg_1_i),
    //     .beta_reg_2         (beta_reg_2_i),
    //     .beta_reg_3         (beta_reg_3_i),
    //     .beta_reg_4         (beta_reg_4_i),
    //     .beta_reg_5         (beta_reg_5_i),
    //     .beta_reg_6         (beta_reg_6_i),
    //     .beta_reg_7         (beta_reg_7_i)
	// );

	assign init_branch1_t = init_branch1;
	assign init_branch2_t = init_branch2;
    assign valid_out = valid_branch_i;

	assign alpha_0 = alpha_0_i;
    assign alpha_1 = alpha_1_i;
    assign alpha_2 = alpha_2_i;
    assign alpha_3 = alpha_3_i;
    assign alpha_4 = alpha_4_i;
    assign alpha_5 = alpha_5_i;
    assign alpha_6 = alpha_6_i;
    assign alpha_7 = alpha_7_i;

endmodule
