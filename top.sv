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



    module beta 
    (
        clk,
        rst,
        valid_branch,
        init_branch1,
        init_branch2,
        beta_0,
        beta_1,
        beta_2,
        beta_3,
        beta_4,
        beta_5,
        beta_6,
        beta_7
    );

    input clk;
    input rst;
    input [15:0] init_branch1;
    input [15:0] init_branch2;
    input valid_branch;
    output [15:0] beta_0;
    output [15:0] beta_1;
    output [15:0] beta_2;
    output [15:0] beta_3;
    output [15:0] beta_4;
    output [15:0] beta_5;
    output [15:0] beta_6;
    output [15:0] beta_7;

    reg [15:0] init_branch_srl1 [0:515];
    reg [15:0] init_branch_srl2 [0:515];
    reg [15:0] counter = 0;
    reg [15:0] counter_i = 0;
    reg [15:0] counter_reg = 0;


    reg [15:0] beta_0_i [0:516];
    reg [15:0] beta_1_i [0:516];
    reg [15:0] beta_2_i [0:516];
    reg [15:0] beta_3_i [0:516];
    reg [15:0] beta_4_i [0:516];
    reg [15:0] beta_5_i [0:516];
    reg [15:0] beta_6_i [0:516];
    reg [15:0] beta_7_i [0:516];

    reg [15:0] beta_reg_0 [0:516];
    reg [15:0] beta_reg_1 [0:516];
    reg [15:0] beta_reg_2 [0:516];
    reg [15:0] beta_reg_3 [0:516];
    reg [15:0] beta_reg_4 [0:516];
    reg [15:0] beta_reg_5 [0:516];
    reg [15:0] beta_reg_6 [0:516];
    reg [15:0] beta_reg_7 [0:516];
    
    
    initial begin
        for (int k = 0; k < 516; k++) begin
            beta_0_i[k] = -128;
            beta_1_i[k] = -128;
            beta_2_i[k] = -128;
            beta_3_i[k] = -128;
            beta_4_i[k] = -128;
            beta_5_i[k] = -128;
            beta_6_i[k] = -128;
            beta_7_i[k] = -128;

            beta_reg_0[k] = -128;
            beta_reg_1[k] = -128;
            beta_reg_2[k] = -128;
            beta_reg_3[k] = -128;
            beta_reg_4[k] = -128;
            beta_reg_5[k] = -128;
            beta_reg_6[k] = -128;
            beta_reg_7[k] = -128;
        end
        beta_0_i[0] = 0;
        beta_reg_0[0] = 0;

    end

    always_ff @(posedge clk) begin
        if (valid_branch & counter < blklen + 4) begin
            init_branch_srl1 <= {init_branch1, init_branch_srl1[0:514]};
            init_branch_srl2 <= {init_branch2, init_branch_srl2[0:514]};
            counter <= counter + 1;
        end
    end

    always_ff @(posedge clk) begin
        if (counter == blklen + 4) begin
            for (int i = 1; i < blklen + 6; i++) begin
                beta_0_i[i] <= ($signed(beta_0_i[i-1] + init_branch_srl1[i-1]) > $signed(beta_4_i[i-1] - init_branch_srl1[i-1])) ? beta_0_i[i-1] + init_branch_srl1[i-1] : beta_4_i[i-1] - init_branch_srl1[i-1]; 
				beta_0_i[i] <= ($signed(beta_0_i[i-1] + init_branch_srl1[i-1]) > $signed(beta_4_i[i-1] - init_branch_srl1[i-1])) ? beta_0_i[i-1] + init_branch_srl1[i-1] : beta_4_i[i-1] - init_branch_srl1[i-1];
                beta_1_i[i] <= ($signed(beta_4_i[i-1] + init_branch_srl1[i-1]) > $signed(beta_0_i[i-1] - init_branch_srl1[i-1])) ? beta_4_i[i-1] + init_branch_srl1[i-1] : beta_0_i[i-1] - init_branch_srl1[i-1]; 
                beta_2_i[i] <= ($signed(beta_5_i[i-1] + init_branch_srl2[i-1]) > $signed(beta_1_i[i-1] - init_branch_srl2[i-1])) ? beta_5_i[i-1] + init_branch_srl2[i-1] : beta_1_i[i-1] - init_branch_srl2[i-1];
                beta_3_i[i] <= ($signed(beta_1_i[i-1] + init_branch_srl2[i-1]) > $signed(beta_5_i[i-1] - init_branch_srl2[i-1])) ? beta_1_i[i-1] + init_branch_srl2[i-1] : beta_5_i[i-1] - init_branch_srl2[i-1];
                beta_4_i[i] <= ($signed(beta_2_i[i-1] + init_branch_srl2[i-1]) > $signed(beta_6_i[i-1] - init_branch_srl2[i-1])) ? beta_2_i[i-1] + init_branch_srl2[i-1] : beta_6_i[i-1] - init_branch_srl2[i-1];
                beta_5_i[i] <= ($signed(beta_6_i[i-1] + init_branch_srl2[i-1]) > $signed(beta_2_i[i-1] - init_branch_srl2[i-1])) ? beta_6_i[i-1] + init_branch_srl2[i-1] : beta_2_i[i-1] - init_branch_srl2[i-1];
                beta_6_i[i] <= ($signed(beta_7_i[i-1] + init_branch_srl1[i-1]) > $signed(beta_3_i[i-1] - init_branch_srl1[i-1])) ? beta_7_i[i-1] + init_branch_srl1[i-1] : beta_3_i[i-1] - init_branch_srl1[i-1];
                beta_7_i[i] <= ($signed(beta_3_i[i-1] + init_branch_srl1[i-1]) > $signed(beta_7_i[i-1] - init_branch_srl1[i-1])) ? beta_3_i[i-1] + init_branch_srl1[i-1] : beta_7_i[i-1] - init_branch_srl1[i-1];
            end
            counter_i <= (counter_i > blklen + 4) ? counter_i : counter_i + 1;
       end
    end

    always_ff @(posedge clk) begin
        if (counter_i == 517) begin
            // for (int j = 1; j < 517; j++) begin
                beta_reg_0[counter_reg] <= $signed(beta_0_i[counter_reg] - beta_0_i[counter_reg]);
                beta_reg_1[counter_reg] <= $signed(beta_1_i[counter_reg] - beta_0_i[counter_reg]);
                beta_reg_2[counter_reg] <= $signed(beta_2_i[counter_reg] - beta_0_i[counter_reg]);
                beta_reg_3[counter_reg] <= $signed(beta_3_i[counter_reg] - beta_0_i[counter_reg]);
                beta_reg_4[counter_reg] <= $signed(beta_4_i[counter_reg] - beta_0_i[counter_reg]);
                beta_reg_5[counter_reg] <= $signed(beta_5_i[counter_reg] - beta_0_i[counter_reg]);
                beta_reg_6[counter_reg] <= $signed(beta_6_i[counter_reg] - beta_0_i[counter_reg]);
                beta_reg_7[counter_reg] <= $signed(beta_7_i[counter_reg] - beta_0_i[counter_reg]);
            // end
        counter_reg <= (counter_reg > blklen + 4) ? counter_reg : counter_reg + 1;
        end
    end


    endmodule



	module LLR 
	(
		clk,
		rst,
		valid_branch,
        init_branch1,
        init_branch2,
		alpha_0,
    	alpha_1,
    	alpha_2,
    	alpha_3,
    	alpha_4,
    	alpha_5,
    	alpha_6,
    	alpha_7,
    	valid_alpha
	);

	input clk;
    input rst;
    input [15:0] init_branch1;
    input [15:0] init_branch2;
    input valid_branch;
	input [15:0] alpha_0;
    input [15:0] alpha_1;
    input [15:0] alpha_2;
    input [15:0] alpha_3;
    input [15:0] alpha_4;
    input [15:0] alpha_5;
    input [15:0] alpha_6;
    input [15:0] alpha_7;
    input valid_alpha;

	reg [15:0] alpha_0_i [0:515];
    reg [15:0] alpha_1_i [0:515];
    reg [15:0] alpha_2_i [0:515];
    reg [15:0] alpha_3_i [0:515];
    reg [15:0] alpha_4_i [0:515];
    reg [15:0] alpha_5_i [0:515];
    reg [15:0] alpha_6_i [0:515];
    reg [15:0] alpha_7_i [0:515];

	always_ff @(posedge clk) begin
		if (valid_alpha) begin
			alpha_0_i <= {alpha_0, alpha_0_i[0:514]};
            alpha_1_i <= {alpha_1, alpha_1_i[0:514]};
			alpha_2_i <= {alpha_2, alpha_2_i[0:514]};
			alpha_3_i <= {alpha_3, alpha_3_i[0:514]};
			alpha_4_i <= {alpha_4, alpha_4_i[0:514]};
			alpha_5_i <= {alpha_5, alpha_5_i[0:514]};
			alpha_6_i <= {alpha_6, alpha_6_i[0:514]};
			alpha_7_i <= {alpha_7, alpha_7_i[0:514]};
		end
	end




	endmodule



    beta beta_inst 
    (
        .clk            (clk),
        .rst            (rst),
        .valid_branch   (valid_branch_i),
        .init_branch1   (init_branch1),
        .init_branch2   (init_branch2)
    );

	LLR LLR_inst
	(
		.clk            (clk),
        .rst            (rst),
        .valid_branch   (valid_branch_i),
        .init_branch1   (init_branch1),
        .init_branch2   (init_branch2),
		.alpha_0		(alpha_0_i),
    	.alpha_1		(alpha_1_i),
    	.alpha_2		(alpha_2_i),
    	.alpha_3		(alpha_3_i),
    	.alpha_4		(alpha_4_i),
    	.alpha_5		(alpha_5_i),
    	.alpha_6		(alpha_6_i),
    	.alpha_7		(alpha_7_i),
    	.valid_alpha	(valid_alpha_i)
	);

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
