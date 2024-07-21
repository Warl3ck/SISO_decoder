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
		parameter blklen_w = 512
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
		extrinsic
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
    input [15:0] alpha_0;
    input [15:0] alpha_1;
    input [15:0] alpha_2;
    input [15:0] alpha_3;
    input [15:0] alpha_4;
    input [15:0] alpha_5;
    input [15:0] alpha_6;
    input [15:0] alpha_7;
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
	output valid_extrinsic;
	output [15:0] extrinsic;

    reg [15:0] init_branch_srl1 [0:blklen_w + 3];
    reg [15:0] init_branch_srl2 [0:blklen_w + 3];
	reg [15:0] init_branch1_inv, init_branch2_inv;
	
    // reg [15:0] bet_0_i [0:1] = {0, 0};
    // reg [15:0] bet_1_i [0:1] = {-128, -128};
    // reg [15:0] bet_2_i [0:1] = {-128, -128};
    // reg [15:0] bet_3_i [0:1] = {-128, -128};
    // reg [15:0] bet_4_i [0:1] = {-128, -128};
    // reg [15:0] bet_5_i [0:1] = {-128, -128};
    // reg [15:0] bet_6_i [0:1] = {-128, -128};
    // reg [15:0] bet_7_i [0:1] = {-128, -128};

    reg [15:0] apriori_srl [0:blklen_w + 3];
    reg [15:0] sys_srl [0:blklen_w + 3];
    reg [15:0] sub_llr_sys_apriori;
    reg [15:0] llr_sys_apriori_divide;
    reg [15:0] sub_llr_sys_apriori_delay;

    reg [15:0] counter;

	// reg [15:0] bet_sum [8];
	// reg [15:0] bet_sub [8];


    reg [15:0] beta_0_i [0:blklen_w + 4];
    reg [15:0] beta_1_i [0:blklen_w + 4];
    reg [15:0] beta_2_i [0:blklen_w + 4];
    reg [15:0] beta_3_i [0:blklen_w + 4];
    reg [15:0] beta_4_i [0:blklen_w + 4];
    reg [15:0] beta_5_i [0:blklen_w + 4];
    reg [15:0] beta_6_i [0:blklen_w + 4];
    reg [15:0] beta_7_i [0:blklen_w + 4];

    reg [15:0] beta_reg_0 [0:blklen_w + 4];
    reg [15:0] beta_reg_1 [0:blklen_w + 4];
    reg [15:0] beta_reg_2 [0:blklen_w + 4];
    reg [15:0] beta_reg_3 [0:blklen_w + 4];
    reg [15:0] beta_reg_4 [0:blklen_w + 4];
    reg [15:0] beta_reg_5 [0:blklen_w + 4];
    reg [15:0] beta_reg_6 [0:blklen_w + 4];
    reg [15:0] beta_reg_7 [0:blklen_w + 4];
    //
    reg [15:0] alpha_i [8][0:blklen_w + 3];
    reg [15:0] llr_1 [8];
    reg [15:0] llr_2 [8];
    reg [15:0] llr_1_max_0 [4];
    reg [15:0] llr_2_max_0 [4];
    reg [15:0] llr_1_max_1 [2];
    reg [15:0] llr_2_max_1 [2];
    reg [15:0] llr_1_max_2;
    reg [15:0] llr_2_max_2;
    reg [15:0] llr_i;



	reg valid_extrinsic_i;
    reg [15:0] extrinsic_i;
	reg [0:512] valid_branch_srl;


    // FSM
    typedef enum reg[2:0] { IDLE, CALCULATE_0, CALCULATE_1, CALCULATE_1_1, NORMALIZE_BETA, MAX_0, MAX_1 } statetype;
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
						if (counter == 0)					next_state = NORMALIZE_BETA;
						else						    	next_state = CALCULATE_1;
		end
        NORMALIZE_BETA 	: begin
						if (counter > blklen + 4)			next_state = MAX_0;
						else						    	next_state = NORMALIZE_BETA;
        end
        MAX_0           : begin
                        if (counter == 0)					next_state = IDLE;
						else						    	next_state = MAX_0;
        end
		endcase
	end

	always_ff @(posedge clk)
	begin
		case (state)
			IDLE 			: begin
	                        counter <= 0;
                            for (int k = 0; k < blklen_w + 4; k++) begin //
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
                            beta_reg_0[blklen_w + 4] = 0; //
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
							if (valid_branch_srl[512]) begin
								beta_0_i[blklen_w+5-counter] <= ($signed(beta_0_i[blklen_w+4-counter] + init_branch1_inv) > $signed(beta_4_i[blklen_w+4-counter] - init_branch1_inv)) ? beta_0_i[blklen_w+4-counter] + init_branch1_inv : beta_4_i[blklen_w+4-counter] - init_branch1_inv;		
                            	beta_1_i[blklen_w+5-counter] <= ($signed(beta_4_i[blklen_w+4-counter] + init_branch1_inv) > $signed(beta_0_i[blklen_w+4-counter] - init_branch1_inv)) ? beta_4_i[blklen_w+4-counter] + init_branch1_inv : beta_0_i[blklen_w+4-counter] - init_branch1_inv; 
                            	beta_2_i[blklen_w+5-counter] <= ($signed(beta_5_i[blklen_w+4-counter] + init_branch2_inv) > $signed(beta_1_i[blklen_w+4-counter] - init_branch2_inv)) ? beta_5_i[blklen_w+4-counter] + init_branch2_inv : beta_1_i[blklen_w+4-counter] - init_branch2_inv;
                            	beta_3_i[blklen_w+5-counter] <= ($signed(beta_1_i[blklen_w+4-counter] + init_branch2_inv) > $signed(beta_5_i[blklen_w+4-counter] - init_branch2_inv)) ? beta_1_i[blklen_w+4-counter] + init_branch2_inv : beta_5_i[blklen_w+4-counter] - init_branch2_inv;
                            	beta_4_i[blklen_w+5-counter] <= ($signed(beta_2_i[blklen_w+4-counter] + init_branch2_inv) > $signed(beta_6_i[blklen_w+4-counter] - init_branch2_inv)) ? beta_2_i[blklen_w+4-counter] + init_branch2_inv : beta_6_i[blklen_w+4-counter] - init_branch2_inv;
                            	beta_5_i[blklen_w+5-counter] <= ($signed(beta_6_i[blklen_w+4-counter] + init_branch2_inv) > $signed(beta_2_i[blklen_w+4-counter] - init_branch2_inv)) ? beta_6_i[blklen_w+4-counter] + init_branch2_inv : beta_2_i[blklen_w+4-counter] - init_branch2_inv;
                            	beta_6_i[blklen_w+5-counter] <= ($signed(beta_7_i[blklen_w+4-counter] + init_branch1_inv) > $signed(beta_3_i[blklen_w+4-counter] - init_branch1_inv)) ? beta_7_i[blklen_w+4-counter] + init_branch1_inv : beta_3_i[blklen_w+4-counter] - init_branch1_inv;
                            	beta_7_i[blklen_w+5-counter] <= ($signed(beta_3_i[blklen_w+4-counter] + init_branch1_inv) > $signed(beta_7_i[blklen_w+4-counter] - init_branch1_inv)) ? beta_3_i[blklen_w+4-counter] + init_branch1_inv : beta_7_i[blklen_w+4-counter] - init_branch1_inv;
								
								counter <= (counter != 0) ? counter - 1 : counter;
							end				

            end
            NORMALIZE_BETA  : begin
                            	beta_reg_0[counter] <= $signed(beta_0_i[counter] - beta_0_i[counter]); 
                            	beta_reg_1[counter] <= $signed(beta_1_i[counter] - beta_0_i[counter]);
                            	beta_reg_2[counter] <= $signed(beta_2_i[counter] - beta_0_i[counter]);
                            	beta_reg_3[counter] <= $signed(beta_3_i[counter] - beta_0_i[counter]);
                            	beta_reg_4[counter] <= $signed(beta_4_i[counter] - beta_0_i[counter]);
                            	beta_reg_5[counter] <= $signed(beta_5_i[counter] - beta_0_i[counter]);
                            	beta_reg_6[counter] <= $signed(beta_6_i[counter] - beta_0_i[counter]);
                            	beta_reg_7[counter] <= $signed(beta_7_i[counter] - beta_0_i[counter]);
								counter <= (counter > blklen + 4) ? counter : counter + 1;
            end
            MAX_0           : begin
                                llr_1[0] <= $signed(alpha_i[0][(blklen_w + 5)-counter] - init_branch_srl1[(blklen_w + 5)-counter] + beta_reg_4[(blklen_w + 5)-counter]);  // beta_reg - 1 because name [0:7]
                                llr_1[1] <= $signed(alpha_i[1][(blklen_w + 5)-counter] - init_branch_srl1[(blklen_w + 5)-counter] + beta_reg_0[(blklen_w + 5)-counter]);
                                llr_1[2] <= $signed(alpha_i[2][(blklen_w + 5)-counter] - init_branch_srl2[(blklen_w + 5)-counter] + beta_reg_1[(blklen_w + 5)-counter]);
                                llr_1[3] <= $signed(alpha_i[3][(blklen_w + 5)-counter] - init_branch_srl2[(blklen_w + 5)-counter] + beta_reg_5[(blklen_w + 5)-counter]);
                                llr_1[4] <= $signed(alpha_i[4][(blklen_w + 5)-counter] - init_branch_srl2[(blklen_w + 5)-counter] + beta_reg_6[(blklen_w + 5)-counter]);
                                llr_1[5] <= $signed(alpha_i[5][(blklen_w + 5)-counter] - init_branch_srl2[(blklen_w + 5)-counter] + beta_reg_2[(blklen_w + 5)-counter]);
                                llr_1[6] <= $signed(alpha_i[6][(blklen_w + 5)-counter] - init_branch_srl1[(blklen_w + 5)-counter] + beta_reg_3[(blklen_w + 5)-counter]);
                                llr_1[7] <= $signed(alpha_i[7][(blklen_w + 5)-counter] - init_branch_srl1[(blklen_w + 5)-counter] + beta_reg_7[(blklen_w + 5)-counter]);
                                ///////////////////////////////
                                llr_2[0] <= $signed(alpha_i[0][(blklen_w + 5)-counter] + init_branch_srl1[(blklen_w + 5)-counter] + beta_reg_0[(blklen_w + 5)-counter]); 
                                llr_2[1] <= $signed(alpha_i[1][(blklen_w + 5)-counter] + init_branch_srl1[(blklen_w + 5)-counter] + beta_reg_4[(blklen_w + 5)-counter]);
                                llr_2[2] <= $signed(alpha_i[2][(blklen_w + 5)-counter] + init_branch_srl2[(blklen_w + 5)-counter] + beta_reg_5[(blklen_w + 5)-counter]);
                                llr_2[3] <= $signed(alpha_i[3][(blklen_w + 5)-counter] + init_branch_srl2[(blklen_w + 5)-counter] + beta_reg_1[(blklen_w + 5)-counter]);
                                llr_2[4] <= $signed(alpha_i[4][(blklen_w + 5)-counter] + init_branch_srl2[(blklen_w + 5)-counter] + beta_reg_2[(blklen_w + 5)-counter]);
                                llr_2[5] <= $signed(alpha_i[5][(blklen_w + 5)-counter] + init_branch_srl2[(blklen_w + 5)-counter] + beta_reg_6[(blklen_w + 5)-counter]);
                                llr_2[6] <= $signed(alpha_i[6][(blklen_w + 5)-counter] + init_branch_srl1[(blklen_w + 5)-counter] + beta_reg_7[(blklen_w + 5)-counter]);
                                llr_2[7] <= $signed(alpha_i[7][(blklen_w + 5)-counter] + init_branch_srl1[(blklen_w + 5)-counter] + beta_reg_3[(blklen_w + 5)-counter]);

								counter <= counter - 1;

                                if (counter < 517) begin					                            
                                	llr_1_max_0[0] <= ($signed(llr_1[1]) > $signed(llr_1[0])) ? llr_1[1] : llr_1[0];
									llr_1_max_0[1] <= ($signed(llr_1[3]) > $signed(llr_1[2])) ? llr_1[3] : llr_1[2];
									llr_1_max_0[2] <= ($signed(llr_1[5]) > $signed(llr_1[4])) ? llr_1[5] : llr_1[4];
									llr_1_max_0[3] <= ($signed(llr_1[7]) > $signed(llr_1[6])) ? llr_1[7] : llr_1[6];

									llr_2_max_0[0] <= ($signed(llr_2[1]) > $signed(llr_2[0])) ? llr_2[1] : llr_2[0];
									llr_2_max_0[1] <= ($signed(llr_2[3]) > $signed(llr_2[2])) ? llr_2[3] : llr_2[2];
									llr_2_max_0[2] <= ($signed(llr_2[5]) > $signed(llr_2[4])) ? llr_2[5] : llr_2[4];
									llr_2_max_0[3] <= ($signed(llr_2[7]) > $signed(llr_2[6])) ? llr_2[7] : llr_2[6];
                                end
            
                                if (counter < 516) begin
									llr_1_max_1[0] <= ($signed(llr_1_max_0[1]) > $signed(llr_1_max_0[0])) ? llr_1_max_0[1] : llr_1_max_0[0];
									llr_1_max_1[1] <= ($signed(llr_1_max_0[3]) > $signed(llr_1_max_0[2])) ? llr_1_max_0[3] : llr_1_max_0[2];
									llr_1_max_1[2] <= ($signed(llr_1_max_0[5]) > $signed(llr_1_max_0[4])) ? llr_1_max_0[5] : llr_1_max_0[4];
									llr_1_max_1[3] <= ($signed(llr_1_max_0[7]) > $signed(llr_1_max_0[6])) ? llr_1_max_0[7] : llr_1_max_0[6];

									llr_2_max_1[0] <= ($signed(llr_2_max_0[1]) > $signed(llr_2_max_0[0])) ? llr_2_max_0[1] : llr_2_max_0[0];
									llr_2_max_1[1] <= ($signed(llr_2_max_0[3]) > $signed(llr_2_max_0[2])) ? llr_2_max_0[3] : llr_2_max_0[2];
									llr_2_max_1[2] <= ($signed(llr_2_max_0[5]) > $signed(llr_2_max_0[4])) ? llr_2_max_0[5] : llr_2_max_0[4];
									llr_2_max_1[3] <= ($signed(llr_2_max_0[7]) > $signed(llr_2_max_0[6])) ? llr_2_max_0[7] : llr_2_max_0[6];
                                end
           
                                if (counter < 515) begin
                                	llr_1_max_2 <= ($signed(llr_1_max_1[0]) > $signed(llr_1_max_1[1])) ? llr_1_max_1[0] : llr_1_max_1[1];
                                	llr_2_max_2 <= ($signed(llr_2_max_1[0]) > $signed(llr_2_max_1[1])) ? llr_2_max_1[0] : llr_2_max_1[1];
                                	llr_i <= $signed(llr_1_max_2 - llr_2_max_2);
                                end

                                if (counter < 514) begin
                                    sub_llr_sys_apriori <= $signed(llr_i - sys_srl[517 - counter - 5] - apriori_srl[517 - counter - 5]);
                                    //sub_llr_sys_apriori_delay <= sub_llr_sys_apriori;
                                end

                                if (counter < 513) begin
                                	extrinsic_i <= 2 * $signed(sub_llr_sys_apriori); //(sub_llr_sys_apriori[15]) ? {1'b1, 1'b1, llr_sys_apriori_divide[13:0]} : llr_sys_apriori_divide;
                                end

								valid_extrinsic_i <= (counter < 517-5 && counter != 0) ? 1'b1 : 1'b0;
            end
                                
	        endcase
        end


	always_ff @(posedge clk)
	begin
		valid_branch_srl <= {valid_branch, valid_branch_srl[0:511]};
	end



	assign init_branch1_inv = (state == CALCULATE_1) ? init_branch_srl1[(blklen_w + 5)-counter-1] : init_branch1_inv;
	assign init_branch2_inv = (state == CALCULATE_1) ? init_branch_srl2[(blklen_w + 5)-counter-1] : init_branch1_inv;

	
	assign extrinsic = extrinsic_i;
	assign valid_extrinsic = valid_extrinsic_i;


    // assign llr_sys_apriori_divide = (sub_llr_sys_apriori[1:0] == 1) ? (sub_llr_sys_apriori + 1) >> 2 : (sub_llr_sys_apriori[1:0] == 2) ? (sub_llr_sys_apriori + 2) >> 2 : 
	//  (sub_llr_sys_apriori[1:0] == 3) ? (sub_llr_sys_apriori + 3) >> 2 : sub_llr_sys_apriori >> 2 ;
	// assign extrinsic_i = $signed(sub_llr_sys_apriori_delay - extrinsic_i);


	// ********************************* DEBUG
//    generate
//	if (DEBUG == 1)
	// debug
	// integer llr1_0, llr1_1, llr1_2, llr1_3, llr1_4, llr1_5, llr1_6, llr1_7, llr2_0, llr2_1, llr2_2, llr2_3, llr2_4, llr2_5, llr2_6, llr2_7;
	// integer init_branch1_r, init_branch2_r;
	// integer sub_LLR, extrinsic0, LLR;
	// integer sys_f;
	// string line_sys;
	// string line_llr, line_ext, line_sub_llr;
	// string line_r1, line_r2;
	// string line_0_0, line_0_1, line_0_2, line_0_3, line_0_4, line_0_5, line_0_6, line_0_7;

	// initial begin
	// 	init_branch1_r = $fopen("init_branch1m.txt", "r");
	// 	init_branch2_r = $fopen("init_branch2m.txt", "r");
	// 	llr1_0 = $fopen("llrm_1_0.txt", "r");
	// 	llr1_1 = $fopen("llrm_1_1.txt", "r");
	// 	llr1_2 = $fopen("llrm_1_2.txt", "r");
	// 	llr1_3 = $fopen("llrm_1_3.txt", "r");

	// 	llr1_4 = $fopen("llrm_1_4.txt", "r");
	// 	llr1_5 = $fopen("llrm_1_5.txt", "r");
	// 	llr1_6 = $fopen("llrm_1_6.txt", "r");
	// 	llr1_7 = $fopen("llrm_1_7.txt", "r");

	// 	llr2_0 = $fopen("llrm_2_0.txt", "r");
	// 	llr2_1 = $fopen("llrm_2_1.txt", "r");
	// 	llr2_2 = $fopen("llrm_2_2.txt", "r");
	// 	llr2_3 = $fopen("llrm_2_3.txt", "r");

	// 	llr2_4 = $fopen("llrm_2_4.txt", "r");
	// 	llr2_5 = $fopen("llrm_2_5.txt", "r");
	// 	llr2_6 = $fopen("llrm_2_6.txt", "r");
	// 	llr2_7 = $fopen("llrm_2_7.txt", "r");

	// 	sub_LLR = $fopen("sub_LLR.txt", "r");
	// 	extrinsic0 = $fopen("extrinsic.txt", "r");
	// 	LLR = $fopen("LLR.txt", "r");
	// 	sys_f = $fopen("sys.txt", "r");
	// end

	// always_ff @(posedge clk) begin
	// 	if(valid_llr_i) begin
	// 		// llr_1_0
	// 		$fgets(line_0_0, llr1_0);
	// 		$fgets(line_0_1, llr1_1);
	// 		$fgets(line_0_2, llr1_2);
	// 		$fgets(line_0_3, llr1_3);
	// 		$fgets(line_0_4, llr1_4);
	// 		$fgets(line_0_5, llr1_5);
	// 		$fgets(line_0_6, llr1_6);
	// 		$fgets(line_0_7, llr1_7);

	// 		$display(line_0_0.atoi(), $signed(llr_1[0]), line_0_1.atoi(), $signed(llr_1[1]), line_0_2.atoi(), $signed(llr_1[2]), line_0_3.atoi(), $signed(llr_1[3]), line_0_4.atoi(), $signed(llr_1[4]),
	// 		line_0_5.atoi(), $signed(llr_1[5]), line_0_6.atoi(), $signed(llr_1[6]), line_0_7.atoi(), $signed(llr_1[7]));
	// 		if (line_0_0.atoi() !== $signed(llr_1[0]) || line_0_1.atoi() !== $signed(llr_1[1]) || line_0_2.atoi() !== $signed(llr_1[2]) || line_0_3.atoi() !== $signed(llr_1[3]) || 
	// 		line_0_4.atoi() !== $signed(llr_1[4]) || line_0_5.atoi() !== $signed(llr_1[5]) || line_0_6.atoi() !== $signed(llr_1[6]) || line_0_7.atoi() !== $signed(llr_1[7]))
	// 			$display ("error_llr1_0");

	// 	end
	// end

	// always_comb begin
	// if (valid_branch) begin
    //     $fgets(line_r1,init_branch1_r);
    //     $fgets(line_r2,init_branch2_r);
	// 	$display(line_r1.atoi(), $signed(init_branch1), "|", line_r2.atoi(), $signed(init_branch2));
    //     if (line_r1.atoi() !== $signed(init_branch1) || line_r2.atoi() !== $signed(init_branch2))
	// 		$display ("error");
	// end
	// end


	// always_comb begin
	// if (counter_alpha > 4) begin
	// 	$fgets(line_llr,LLR);
    //     // $fgets(line_ext,extrinsic0);
	// 	$display(line_llr.atoi(), $signed(llr_i));
    //     if (line_llr.atoi() !== $signed(llr_i))
	// 		$display ("error_llr");
	// end
	// end


	// always_ff @(posedge clk) begin
	// if (counter_alpha > 5) begin
	// 	$fgets(line_sub_llr,sub_LLR);
    //     // $fgets(line_ext,extrinsic0);
	// 	$display(line_sub_llr.atoi(), $signed(sub_llr_sys_apriori));
    //     if (line_sub_llr.atoi() !== $signed(sub_llr_sys_apriori))
	// 		$display ("error_sub_llr");
	// end
	// end

	// always_ff @(posedge clk) begin
	// if (valid_extrinsic) begin
	// 	$fgets(line_ext,extrinsic0);
    //     // $fgets(line_ext,extrinsic0);
	// 	$display(line_ext.atoi(), $signed(extrinsic_i));
    //     if (line_ext.atoi() !== $signed(extrinsic_i))
	// 		$display ("error_sub_llr");
	// end
	// end
//	endgenerate


    endmodule
