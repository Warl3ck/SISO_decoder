`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2024 22:24:23
// Design Name: 
// Module Name: beta_llr
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

module beta_llr #(
		parameter blklen_w = 6144,
		parameter const1 = 2//0.75
	)
    (
        clk,
        rst,
		apriori,
		valid_apriori,
        valid_sys,
        sys,
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
        beta_7,
		valid_beta,
        //
		alpha_0,
    	alpha_1,
    	alpha_2,
    	alpha_3,
    	alpha_4,
    	alpha_5,
    	alpha_6,
    	alpha_7,
    	valid_alpha,
        valid_blklen,
        blklen,
		valid_extrinsic,
		extrinsic,
		fsm_state,
		ready
    );

    input clk;
    input rst;
	input valid_apriori;
	input [15:0] apriori;
    input [15:0] sys;
    input valid_sys;
    input [15:0] init_branch1;
    input [15:0] init_branch2;
    input valid_branch;
    input [18:0] alpha_0;
    input [18:0] alpha_1;
    input [18:0] alpha_2;
    input [18:0] alpha_3;
    input [18:0] alpha_4;
    input [18:0] alpha_5;
    input [18:0] alpha_6;
    input [18:0] alpha_7;
    input valid_alpha;
    input [15:0] blklen;
    input valid_blklen;
	//
	output [15:0] beta_0;
    output [15:0] beta_1;
    output [15:0] beta_2;
    output [15:0] beta_3;
    output [15:0] beta_4;
    output [15:0] beta_5;
    output [15:0] beta_6;
    output [15:0] beta_7;
	output valid_beta;
	output valid_extrinsic;
	output [15:0] extrinsic;
	output [1:0] fsm_state;
	output ready;

    reg [15:0] init_branch_srl1 [0:blklen_w + 3];
    reg [15:0] init_branch_srl2 [0:blklen_w + 3];
	reg [15:0] init_branch1_inv, init_branch2_inv;
	reg [15:0] init_branch1_inv_del [2];
	reg [15:0] init_branch2_inv_del [2];

    reg [15:0] apriori_srl [0:blklen_w + 3];
    reg [15:0] sys_srl [0:blklen_w + 3];
	reg [15:0] sys_i;
	reg [15:0] apriori_i;
	reg [15:0] sys_i_srl [7];
	reg [15:0] apriori_i_srl [7];
    reg [15:0] sub_llr_sys_apriori;
    reg [15:0] llr_sys_apriori_divide;

    reg [15:0] counter;

	reg [16:0] beta_0_i [0:1]; // = {0, 0};
    reg [16:0] beta_1_i [0:1]; // = {-128, -128};
    reg [16:0] beta_2_i [0:1]; // = {-128, -128};
    reg [16:0] beta_3_i [0:1]; // = {-128, -128};
    reg [16:0] beta_4_i [0:1]; // = {-128, -128};
    reg [16:0] beta_5_i [0:1]; // = {-128, -128};
    reg [16:0] beta_6_i [0:1]; // = {-128, -128};
    reg [16:0] beta_7_i [0:1]; // = {-128, -128};
	//
    reg [15:0] beta_reg_0; //[0:blklen_w + 4];
    reg [15:0] beta_reg_1; //[0:blklen_w + 4];
    reg [15:0] beta_reg_2; //[0:blklen_w + 4];
    reg [15:0] beta_reg_3; //[0:blklen_w + 4];
    reg [15:0] beta_reg_4; //[0:blklen_w + 4];
    reg [15:0] beta_reg_5; //[0:blklen_w + 4];
    reg [15:0] beta_reg_6; //[0:blklen_w + 4];
    reg [15:0] beta_reg_7; //[0:blklen_w + 4];
	//
	reg [15:0] beta_reg_0_del; //[0:blklen_w + 4];
    reg [15:0] beta_reg_1_del; //[0:blklen_w + 4];
    reg [15:0] beta_reg_2_del; //[0:blklen_w + 4];
    reg [15:0] beta_reg_3_del; //[0:blklen_w + 4];
    reg [15:0] beta_reg_4_del; //[0:blklen_w + 4];
    reg [15:0] beta_reg_5_del; //[0:blklen_w + 4];
    reg [15:0] beta_reg_6_del; //[0:blklen_w + 4];
    reg [15:0] beta_reg_7_del;
    //
    reg [18:0] alpha_i [8][0:blklen_w + 3];
	reg [18:0] alpha_0_reg;
	reg [18:0] alpha_0_reg_del [2];
	reg [18:0] alpha_1_reg;
	reg [18:0] alpha_1_reg_del [2];
	reg [18:0] alpha_2_reg;
	reg [18:0] alpha_2_reg_del [2];
	reg [18:0] alpha_3_reg;
	reg [18:0] alpha_3_reg_del [2];
	reg [18:0] alpha_4_reg;
	reg [18:0] alpha_4_reg_del [2];
	reg [18:0] alpha_5_reg;
	reg [18:0] alpha_5_reg_del [2];
	reg [18:0] alpha_6_reg;
	reg [18:0] alpha_6_reg_del [2];
	reg [18:0] alpha_7_reg;
	reg [18:0] alpha_7_reg_del [2];

    reg [16:0] llr_1 [8];
    reg [16:0] llr_2 [8];
	reg [15:0] llr_1_reg [8];
    reg [15:0] llr_2_reg [8];
    reg [15:0] llr_1_max_0 [4];
    reg [15:0] llr_2_max_0 [4];
	reg [15:0] llr_1_max_0_reg [4];
    reg [15:0] llr_2_max_0_reg [4];
    reg [15:0] llr_1_max_1 [2];
    reg [15:0] llr_2_max_1 [2];
    reg [15:0] llr_1_max_2;
    reg [15:0] llr_2_max_2;
    reg [15:0] llr_i;
	reg [15:0] llr_i_reg;

	reg valid_i;
	reg [0:3] valid_extrinsic_i;
    reg [15:0] extrinsic_i;

	reg ready_i;
	// reg valid_llr;


    // FSM
    typedef enum reg[1:0] { IDLE, CALCULATE_0, CALCULATE_1 } statetype;
    statetype state, next_state;


    always_ff @(posedge clk)
	begin
		if (rst) 
			state <= IDLE;
		else 
			state <= next_state;
	end

    always_comb  
	begin
		case (state)
		IDLE 			: begin
						if (valid_blklen)  			    	next_state = CALCULATE_0;
						else						    	next_state = IDLE;
		end
		CALCULATE_0	: 	begin
						if (counter == blklen + 4)	    	next_state = CALCULATE_1;
						else						    	next_state = CALCULATE_0;
		end
		CALCULATE_1 	: begin
						if (counter == 0)					next_state = IDLE;
						else						    	next_state = CALCULATE_1;
		end
		endcase
	end

	always_ff @(posedge clk)
	begin
		case (state)
			IDLE 			: begin
	                        counter <= 0;
                            for (int k = 0; k < 2; k++) begin 
                                beta_0_i[k] = 0;
                                beta_1_i[k] = -128;
                                beta_2_i[k] = -128;
                                beta_3_i[k] = -128;
                                beta_4_i[k] = -128;
                                beta_5_i[k] = -128;
                                beta_6_i[k] = -128;
                                beta_7_i[k] = -128;
                            end
							for (int i = 0; i < 8; i ++) begin
								for (int j = 0; j < blklen_w + 3; j++) begin
									alpha_i[i][j] <= {16{1'b0}};
								end
							end
							valid_i <= 1'b0;
							ready_i <= 1'b1;
			end
			CALCULATE_0		: begin
                                if (valid_branch) begin
									counter <= counter + 1;
                                    init_branch_srl1 <= {init_branch1, init_branch_srl1[0:blklen_w + 2]};
                                    init_branch_srl2 <= {init_branch2, init_branch_srl2[0:blklen_w + 2]};
		                            alpha_i[0] <= {alpha_0, alpha_i[0][0:blklen_w + 2]};
                                    alpha_i[1] <= {alpha_1, alpha_i[1][0:blklen_w + 2]};
		                            alpha_i[2] <= {alpha_2, alpha_i[2][0:blklen_w + 2]};
		                            alpha_i[3] <= {alpha_3, alpha_i[3][0:blklen_w + 2]};
		                            alpha_i[4] <= {alpha_4, alpha_i[4][0:blklen_w + 2]};
		                            alpha_i[5] <= {alpha_5, alpha_i[5][0:blklen_w + 2]};
		                            alpha_i[6] <= {alpha_6, alpha_i[6][0:blklen_w + 2]};
		                            alpha_i[7] <= {alpha_7, alpha_i[7][0:blklen_w + 2]};      
                                end

                                if (valid_apriori)
                                    apriori_srl <= {apriori, apriori_srl[0:blklen_w + 2]};
                                if (valid_sys)
                                    sys_srl <= {sys, sys_srl[0:blklen_w + 2]};
			end
			CALCULATE_1		: begin
							// counter_i <= counter_i + 1;
							valid_i <= (!valid_i) ? 1'b1 : 1'b0; 
							ready_i <= 1'b0;
							if (valid_i) begin
								beta_0_i[0] <= ($signed(beta_0_i[1] + init_branch1_inv) > $signed(beta_4_i[1] - init_branch1_inv)) ? beta_0_i[1] + init_branch1_inv : beta_4_i[1] - init_branch1_inv;		
                            	beta_1_i[0] <= ($signed(beta_4_i[1] + init_branch1_inv) > $signed(beta_0_i[1] - init_branch1_inv)) ? beta_4_i[1] + init_branch1_inv : beta_0_i[1] - init_branch1_inv; 
                            	beta_2_i[0] <= ($signed(beta_5_i[1] + init_branch2_inv) > $signed(beta_1_i[1] - init_branch2_inv)) ? beta_5_i[1] + init_branch2_inv : beta_1_i[1] - init_branch2_inv;
                            	beta_3_i[0] <= ($signed(beta_1_i[1] + init_branch2_inv) > $signed(beta_5_i[1] - init_branch2_inv)) ? beta_1_i[1] + init_branch2_inv : beta_5_i[1] - init_branch2_inv;
                            	beta_4_i[0] <= ($signed(beta_2_i[1] + init_branch2_inv) > $signed(beta_6_i[1] - init_branch2_inv)) ? beta_2_i[1] + init_branch2_inv : beta_6_i[1] - init_branch2_inv;
                            	beta_5_i[0] <= ($signed(beta_6_i[1] + init_branch2_inv) > $signed(beta_2_i[1] - init_branch2_inv)) ? beta_6_i[1] + init_branch2_inv : beta_2_i[1] - init_branch2_inv;
                            	beta_6_i[0] <= ($signed(beta_7_i[1] + init_branch1_inv) > $signed(beta_3_i[1] - init_branch1_inv)) ? beta_7_i[1] + init_branch1_inv : beta_3_i[1] - init_branch1_inv;
                            	beta_7_i[0] <= ($signed(beta_3_i[1] + init_branch1_inv) > $signed(beta_7_i[1] - init_branch1_inv)) ? beta_3_i[1] + init_branch1_inv : beta_7_i[1] - init_branch1_inv;
								
								counter <= (counter != 0) ? counter - 1 : counter;
							end	else begin
								beta_0_i[1] <= beta_0_i[0];
            					beta_1_i[1] <= beta_1_i[0];
            					beta_2_i[1] <= beta_2_i[0];
            					beta_3_i[1] <= beta_3_i[0];
            					beta_4_i[1] <= beta_4_i[0];
            					beta_5_i[1] <= beta_5_i[0];
            					beta_6_i[1] <= beta_6_i[0];
            					beta_7_i[1] <= beta_7_i[0];
							end		
            end                    
	        endcase
        end

	assign	beta_reg_0 = (state == CALCULATE_1 && valid_i) ? $signed(beta_0_i[1] - beta_0_i[0]) : beta_reg_0; 
    assign	beta_reg_1 = (state == CALCULATE_1 && valid_i) ? $signed(beta_1_i[1] - beta_0_i[0]) : beta_reg_1;
    assign	beta_reg_2 = (state == CALCULATE_1 && valid_i) ? $signed(beta_2_i[1] - beta_0_i[0]) : beta_reg_2;
    assign	beta_reg_3 = (state == CALCULATE_1 && valid_i) ? $signed(beta_3_i[1] - beta_0_i[0]) : beta_reg_3;
    assign	beta_reg_4 = (state == CALCULATE_1 && valid_i) ? $signed(beta_4_i[1] - beta_0_i[0]) : beta_reg_4;
    assign	beta_reg_5 = (state == CALCULATE_1 && valid_i) ? $signed(beta_5_i[1] - beta_0_i[0]) : beta_reg_5;
    assign	beta_reg_6 = (state == CALCULATE_1 && valid_i) ? $signed(beta_6_i[1] - beta_0_i[0]) : beta_reg_6;
    assign	beta_reg_7 = (state == CALCULATE_1 && valid_i) ? $signed(beta_7_i[1] - beta_0_i[0]) : beta_reg_7;

	assign init_branch1_inv = (state == CALCULATE_1) ? init_branch_srl1[(blklen + 5) - counter - 1] : init_branch1_inv;
	assign init_branch2_inv = (state == CALCULATE_1) ? init_branch_srl2[(blklen + 5) - counter - 1] : init_branch1_inv;

	assign sys_i = (state == CALCULATE_1) ? sys_srl[(blklen + 5) - counter - 1] : sys_i;
	assign apriori_i = (state == CALCULATE_1) ? apriori_srl[(blklen + 5) - counter - 1] : apriori_i;

	assign alpha_0_reg = (state == CALCULATE_1) ? alpha_i[0][(blklen + 5) - counter - 1] : alpha_0_reg;
	assign alpha_1_reg = (state == CALCULATE_1) ? alpha_i[1][(blklen + 5) - counter - 1] : alpha_1_reg;
	assign alpha_2_reg = (state == CALCULATE_1) ? alpha_i[2][(blklen + 5) - counter - 1] : alpha_2_reg;
	assign alpha_3_reg = (state == CALCULATE_1) ? alpha_i[3][(blklen + 5) - counter - 1] : alpha_3_reg;
	assign alpha_4_reg = (state == CALCULATE_1) ? alpha_i[4][(blklen + 5) - counter - 1] : alpha_4_reg;
	assign alpha_5_reg = (state == CALCULATE_1) ? alpha_i[5][(blklen + 5) - counter - 1] : alpha_5_reg;
	assign alpha_6_reg = (state == CALCULATE_1) ? alpha_i[6][(blklen + 5) - counter - 1] : alpha_6_reg;
	assign alpha_7_reg = (state == CALCULATE_1) ? alpha_i[7][(blklen + 5) - counter - 1] : alpha_7_reg;

	always_ff @(posedge clk)
	begin
		if (rst) begin
			for (int i = 0; i < 2; i++) begin
				alpha_0_reg_del[i] <= {16{1'b0}};
				init_branch1_inv_del[i] <= {16{1'b0}};
			end
			beta_reg_0_del <= {16{1'b0}};
			beta_reg_1_del <= {16{1'b0}};
			beta_reg_2_del <= {16{1'b0}};
			beta_reg_3_del <= {16{1'b0}};
			beta_reg_4_del <= {16{1'b0}};
			beta_reg_5_del <= {16{1'b0}};
			beta_reg_6_del <= {16{1'b0}};
			beta_reg_7_del <= {16{1'b0}};
		end else begin
			init_branch1_inv_del <= {init_branch1_inv, init_branch1_inv_del[0]};
			init_branch2_inv_del <= {init_branch2_inv, init_branch2_inv_del[0]};
			alpha_0_reg_del <= {alpha_0_reg, alpha_0_reg_del[0]};
			alpha_1_reg_del <= {alpha_1_reg, alpha_1_reg_del[0]};
			alpha_2_reg_del <= {alpha_2_reg, alpha_2_reg_del[0]};
			alpha_3_reg_del <= {alpha_3_reg, alpha_3_reg_del[0]};
			alpha_4_reg_del <= {alpha_4_reg, alpha_4_reg_del[0]};
			alpha_5_reg_del <= {alpha_5_reg, alpha_5_reg_del[0]};
			alpha_6_reg_del <= {alpha_6_reg, alpha_6_reg_del[0]};
			alpha_7_reg_del <= {alpha_7_reg, alpha_7_reg_del[0]};
			beta_reg_0_del <= beta_reg_0;
			beta_reg_1_del <= beta_reg_1;
			beta_reg_2_del <= beta_reg_2;
			beta_reg_3_del <= beta_reg_3;
			beta_reg_4_del <= beta_reg_4;
			beta_reg_5_del <= beta_reg_5;
			beta_reg_6_del <= beta_reg_6;
			beta_reg_7_del <= beta_reg_7;
		end
	end


	always_comb
	begin
		if (state == CALCULATE_1 && counter <= blklen + 3) begin
			llr_1[0] = $signed(alpha_0_reg_del[1] - init_branch1_inv_del[1] + beta_reg_4_del);  // beta_reg - 1 because name [0:7]
			llr_1[1] = $signed(alpha_1_reg_del[1] - init_branch1_inv_del[1] + beta_reg_0_del);
            llr_1[2] = $signed(alpha_2_reg_del[1] - init_branch2_inv_del[1] + beta_reg_1_del);
            llr_1[3] = $signed(alpha_3_reg_del[1] - init_branch2_inv_del[1] + beta_reg_5_del);
            llr_1[4] = $signed(alpha_4_reg_del[1] - init_branch2_inv_del[1] + beta_reg_6_del);
            llr_1[5] = $signed(alpha_5_reg_del[1] - init_branch2_inv_del[1] + beta_reg_2_del);
            llr_1[6] = $signed(alpha_6_reg_del[1] - init_branch1_inv_del[1] + beta_reg_3_del);
            llr_1[7] = $signed(alpha_7_reg_del[1] - init_branch1_inv_del[1] + beta_reg_7_del);
            ///////////////////////////////
            llr_2[0] = $signed(alpha_0_reg_del[1] + init_branch1_inv_del[1] + beta_reg_0_del); 
            llr_2[1] = $signed(alpha_1_reg_del[1] + init_branch1_inv_del[1] + beta_reg_4_del);
            llr_2[2] = $signed(alpha_2_reg_del[1] + init_branch2_inv_del[1] + beta_reg_5_del);
            llr_2[3] = $signed(alpha_3_reg_del[1] + init_branch2_inv_del[1] + beta_reg_1_del);
            llr_2[4] = $signed(alpha_4_reg_del[1] + init_branch2_inv_del[1] + beta_reg_2_del);
            llr_2[5] = $signed(alpha_5_reg_del[1] + init_branch2_inv_del[1] + beta_reg_6_del);
            llr_2[6] = $signed(alpha_6_reg_del[1] + init_branch1_inv_del[1] + beta_reg_7_del);
            llr_2[7] = $signed(alpha_7_reg_del[1] + init_branch1_inv_del[1] + beta_reg_3_del);
		end
	end

	assign valid_llr = (state == CALCULATE_1 && counter <= blklen + 3) ? valid_i : 1'b0;

	always_ff @(posedge clk)
	begin
		llr_1_reg[0] <= llr_1[0];
		llr_1_reg[1] <= llr_1[1];
		llr_1_reg[2] <= llr_1[2];
		llr_1_reg[3] <= llr_1[3];
		llr_1_reg[4] <= llr_1[4];
		llr_1_reg[5] <= llr_1[5];
		llr_1_reg[6] <= llr_1[6];
		llr_1_reg[7] <= llr_1[7];
		///////////////////////////////
		llr_2_reg[0] <=	llr_2[0];
		llr_2_reg[1] <=	llr_2[1];
		llr_2_reg[2] <=	llr_2[2];
		llr_2_reg[3] <=	llr_2[3];
		llr_2_reg[4] <=	llr_2[4];
		llr_2_reg[5] <=	llr_2[5];
		llr_2_reg[6] <=	llr_2[6];
		llr_2_reg[7] <=	llr_2[7];
	end


	always_comb
	begin
		if (state == CALCULATE_1 && counter <= blklen + 3) begin                  				                            
            llr_1_max_0[0] = ($signed(llr_1_reg[1]) > $signed(llr_1_reg[0])) ? llr_1_reg[1] : llr_1_reg[0];
			llr_1_max_0[1] = ($signed(llr_1_reg[3]) > $signed(llr_1_reg[2])) ? llr_1_reg[3] : llr_1_reg[2];
			llr_1_max_0[2] = ($signed(llr_1_reg[5]) > $signed(llr_1_reg[4])) ? llr_1_reg[5] : llr_1_reg[4];
			llr_1_max_0[3] = ($signed(llr_1_reg[7]) > $signed(llr_1_reg[6])) ? llr_1_reg[7] : llr_1_reg[6];
			llr_2_max_0[0] = ($signed(llr_2_reg[1]) > $signed(llr_2_reg[0])) ? llr_2_reg[1] : llr_2_reg[0];
			llr_2_max_0[1] = ($signed(llr_2_reg[3]) > $signed(llr_2_reg[2])) ? llr_2_reg[3] : llr_2_reg[2];
			llr_2_max_0[2] = ($signed(llr_2_reg[5]) > $signed(llr_2_reg[4])) ? llr_2_reg[5] : llr_2_reg[4];
			llr_2_max_0[3] = ($signed(llr_2_reg[7]) > $signed(llr_2_reg[6])) ? llr_2_reg[7] : llr_2_reg[6];
		end
	end

	always_ff @(posedge clk)
	begin
		llr_1_max_0_reg[0] <= llr_1_max_0[0];
		llr_1_max_0_reg[1] <= llr_1_max_0[1];
		llr_1_max_0_reg[2] <= llr_1_max_0[2];
		llr_1_max_0_reg[3] <= llr_1_max_0[3];
		llr_2_max_0_reg[0] <= llr_2_max_0[0];
		llr_2_max_0_reg[1] <= llr_2_max_0[1];
		llr_2_max_0_reg[2] <= llr_2_max_0[2];
		llr_2_max_0_reg[3] <= llr_2_max_0[3];
	end

	always_comb
	begin
		if (state == CALCULATE_1 && counter <= blklen + 2) begin  
			llr_1_max_1[0] = ($signed(llr_1_max_0_reg[1]) > $signed(llr_1_max_0_reg[0])) ? llr_1_max_0_reg[1] : llr_1_max_0_reg[0];
			llr_1_max_1[1] = ($signed(llr_1_max_0_reg[3]) > $signed(llr_1_max_0_reg[2])) ? llr_1_max_0_reg[3] : llr_1_max_0_reg[2];
			llr_2_max_1[0] = ($signed(llr_2_max_0_reg[1]) > $signed(llr_2_max_0_reg[0])) ? llr_2_max_0_reg[1] : llr_2_max_0_reg[0];
			llr_2_max_1[1] = ($signed(llr_2_max_0_reg[3]) > $signed(llr_2_max_0_reg[2])) ? llr_2_max_0_reg[3] : llr_2_max_0_reg[2];
        end
	end

	always_comb
	begin
		if (state == CALCULATE_1 && counter <= blklen + 2) begin  
        	llr_1_max_2 = ($signed(llr_1_max_1[0]) > $signed(llr_1_max_1[1])) ? llr_1_max_1[0] : llr_1_max_1[1];
        	llr_2_max_2 = ($signed(llr_2_max_1[0]) > $signed(llr_2_max_1[1])) ? llr_2_max_1[0] : llr_2_max_1[1];
        	llr_i = $signed(llr_1_max_2 - llr_2_max_2);
		end
	end
 
 	always_ff @(posedge clk)
	begin
		if (rst) begin
			for (int i = 0; i < 7; i++) begin
				sys_i_srl[i] <= {16{1'b0}};
				apriori_i_srl[i] <= {16{1'b0}};
			end
			valid_extrinsic_i <= {4{1'b0}};
		end else begin
			valid_extrinsic_i <= {valid_i, valid_extrinsic_i[0:2]};
			sys_i_srl <= {sys_i, sys_i_srl[0:5]};
			apriori_i_srl <= {apriori_i, apriori_i_srl[0:5]};
			llr_i_reg <= llr_i;

		end
	end

       
    assign sub_llr_sys_apriori = $signed(llr_i_reg - sys_i_srl[4] - apriori_i_srl[4]); 
	assign extrinsic_i = const1 * $signed(sub_llr_sys_apriori);
    
	
	assign extrinsic = extrinsic_i;
	assign valid_extrinsic = valid_extrinsic_i[3];

	assign fsm_state = state;
	assign ready = ready_i;

	assign beta_0 = llr_1[0];//beta_reg_0;
	assign beta_1 = llr_1[1];//beta_reg_1;
	assign beta_2 = llr_1[2];//beta_reg_2;
	assign beta_3 = beta_reg_3;
	assign beta_4 = beta_reg_4;
	assign beta_5 = beta_reg_5;
	assign beta_6 = beta_reg_6;
	assign beta_7 = beta_reg_7;	
	assign valid_beta = valid_llr; //valid_i;

    // assign llr_sys_apriori_divide = (sub_llr_sys_apriori[1:0] == 1) ? (sub_llr_sys_apriori + 1) >> 2 : (sub_llr_sys_apriori[1:0] == 2) ? (sub_llr_sys_apriori + 2) >> 2 : 
	//  (sub_llr_sys_apriori[1:0] == 3) ? (sub_llr_sys_apriori + 3) >> 2 : sub_llr_sys_apriori >> 2 ;
	// assign extrinsic_i = $signed(sub_llr_sys_apriori_delay - extrinsic_i);


    integer llr1_0, llr1_1, llr1_2, llr1_3, llr1_4, llr1_5, llr1_6, llr1_7, llr2_0, llr2_1, llr2_2, llr2_3, llr2_4, llr2_5, llr2_6, llr2_7;
    integer bet0,bet1,bet2,bet3,bet4,bet5,bet6,bet7;
	integer init_branch1_r, init_branch2_r;
	integer sub_LLR, extrinsic0, LLR;
	integer sys_f;
	string line_sys;
	string line_llr, line_ext, line_sub_llr;
	string line_r1, line_r2;
	string line_0_0, line_0_1, line_0_2, line_0_3, line_0_4, line_0_5, line_0_6, line_0_7;
	reg [15:0] counter_i = 0;


	    initial begin
		llr1_0 = $fopen("llrm_1_0.txt", "r");
		llr1_1 = $fopen("llrm_1_1.txt", "r");
		llr1_2 = $fopen("llrm_1_2.txt", "r");
		llr1_3 = $fopen("llrm_1_3.txt", "r");

		llr1_4 = $fopen("llrm_1_4.txt", "r");
		llr1_5 = $fopen("llrm_1_5.txt", "r");
		llr1_6 = $fopen("llrm_1_6.txt", "r");
		llr1_7 = $fopen("llrm_1_7.txt", "r");

		// llr2_0 = $fopen("llrm_2_0.txt", "r");
		// llr2_1 = $fopen("llrm_2_1.txt", "r");
		// llr2_2 = $fopen("llrm_2_2.txt", "r");
		// llr2_3 = $fopen("llrm_2_3.txt", "r");

		// llr2_4 = $fopen("llrm_2_4.txt", "r");
		// llr2_5 = $fopen("llrm_2_5.txt", "r");
		// llr2_6 = $fopen("llrm_2_6.txt", "r");
		// llr2_7 = $fopen("llrm_2_7.txt", "r");


		// bet0 = $fopen("beta_0.txt", "r");
		// bet1 = $fopen("beta_1.txt", "r");
		// bet2 = $fopen("beta_2.txt", "r");
		// bet3 = $fopen("beta_3.txt", "r");
		// bet4 = $fopen("beta_4.txt", "r");
		// bet5 = $fopen("beta_5.txt", "r");
		// bet6 = $fopen("beta_6.txt", "r");
		// bet7 = $fopen("beta_7.txt", "r");

		end

	always_comb begin
		if (valid_llr) begin
			$fgets(line_0_0, llr1_0);
			$fgets(line_0_1, llr1_1);
			$fgets(line_0_2, llr1_2);
			$fgets(line_0_3, llr1_3);
			$fgets(line_0_4, llr1_4);
			$fgets(line_0_5, llr1_5);
			$fgets(line_0_6, llr1_6);
			$fgets(line_0_7, llr1_7);

$display(counter_i, line_0_0.atoi(), $signed(llr_1[0]), line_0_1.atoi(), $signed(llr_1[1]), line_0_2.atoi(), $signed(llr_1[2]), line_0_3.atoi(), $signed(llr_1[3]), 
		line_0_4.atoi(), $signed(llr_1[4]), line_0_5.atoi(), $signed(llr_1[5]), line_0_6.atoi(), $signed(llr_1[6]), line_0_7.atoi(), $signed(llr_1[7]));
			// if (line_0_0.atoi() !== $signed(beta_reg_0) || line_0_1.atoi() !== $signed(beta_reg_1) || line_0_2.atoi() !== $signed(beta_reg_2) || line_0_3.atoi() !== $signed(beta_reg_3) || 
			// line_0_4.atoi() !== $signed(beta_reg_4) || line_0_5.atoi() !== $signed(beta_reg_5) || line_0_6.atoi() !== $signed(beta_reg_6) || line_0_7.atoi() !== $signed(beta_reg_7))
			// 	$display ("error_llr1_0");
		end
	end



	// 	always_comb
	// 	begin
	// 	if(valid_llr) begin
	// 		$fgets(line_0_0, llr1_0);
	// 		$fgets(line_0_1, llr1_1);
	// 		$fgets(line_0_2, llr1_2);
	// 		$fgets(line_0_3, llr1_3);
	// 		$fgets(line_0_4, llr1_4);
	// 		$fgets(line_0_5, llr1_5);
	// 		$fgets(line_0_6, llr1_6);
	// 		$fgets(line_0_7, llr1_7);
	// 		$display(line_0_0.atoi(), 	$signed(llr_1[0]), 	line_0_1.atoi(), 	$signed(llr_1[1]), 	line_0_2.atoi(), 	$signed(llr_1[2]), 	line_0_3.atoi(), 	$signed(llr_1[3]), 	line_0_4.atoi(), 	$signed(llr_1[4]),
	// 		line_0_5.atoi(), 	$signed(llr_1[5]), 	line_0_6.atoi(), 	$signed(llr_1[6]), 	line_0_7.atoi(), 	$signed(llr_1[7]));
	// 		if (line_0_0.atoi() !== $signed(llr_1[0]) || line_0_1.atoi() !== $signed(llr_1[1]) || line_0_2.atoi() !== $signed(llr_1[2]) || line_0_3.atoi() !== $signed(llr_1[3]) || 
	// 		line_0_4.atoi() !== $signed(llr_1[4]) || line_0_5.atoi() !== $signed(llr_1[5]) || line_0_6.atoi() !== $signed(llr_1[6]) || line_0_7.atoi() !== $signed(llr_1[7]))
	// 			$display ("error_llr1_0");
	// 	end
	// end

    endmodule
