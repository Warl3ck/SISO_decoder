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

module beta_llr 
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
        init_branch_srl1_i,
        init_branch_srl2_i,
        counter_reg_i,
        beta_reg_0_i, 
        beta_reg_1_i, 
        beta_reg_2_i, 
        beta_reg_3_i, 
        beta_reg_4_i, 
        beta_reg_5_i, 
        beta_reg_6_i, 
        beta_reg_7_i,
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
        blklen
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
    output [15:0] beta_0;
    output [15:0] beta_1;
    output [15:0] beta_2;
    output [15:0] beta_3;
    output [15:0] beta_4;
    output [15:0] beta_5;
    output [15:0] beta_6;
    output [15:0] beta_7;
    output [15:0] init_branch_srl1_i [0:515];
    output [15:0] init_branch_srl2_i [0:515];
    output [15:0] counter_reg_i;
    output [15:0] beta_reg_0_i [0:516];
    output [15:0] beta_reg_1_i [0:516];
    output [15:0] beta_reg_2_i [0:516];
    output [15:0] beta_reg_3_i [0:516];
    output [15:0] beta_reg_4_i [0:516];
    output [15:0] beta_reg_5_i [0:516];
    output [15:0] beta_reg_6_i [0:516];
    output [15:0] beta_reg_7_i [0:516];
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

    reg [15:0] init_branch_srl1 [0:515];
    reg [15:0] init_branch_srl2 [0:515];
    reg [15:0] apriori_srl [0:515];
    reg [15:0] sys_srl [0:515];
    reg [15:0] sub_llr_sys_apriori;
    reg [15:0] llr_sys_apriori_divide;
    reg [15:0] sub_llr_sys_apriori_delay;

    reg [15:0] counter;
    reg [15:0] counter_i;
    reg [15:0] counter_reg;


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
    //
    reg [15:0] alpha_i [8][0:515];
    reg [15:0] llr_1 [8];
    reg [15:0] llr_2 [8];
    reg [15:0] llr_1_max_0 [4];
    reg [15:0] llr_2_max_0 [4];
    reg [15:0] llr_1_max_1 [2];
    reg [15:0] llr_2_max_1 [2];
    reg [15:0] llr_1_max_2;
    reg [15:0] llr_2_max_2;
    reg [15:0] llr_i;
    reg [15:0] counter_alpha;
    reg [15:0] sign_extrinsic_i;
    reg [15:0] extrinsic_i;

	// debug
	reg valid_llr_i;
	integer llr1_0, llr1_1, llr1_2, llr1_3, llr1_4, llr1_5, llr1_6, llr1_7, llr2_0, llr2_1, llr2_2, llr2_3, llr2_4, llr2_5, llr2_6, llr2_7;
	integer init_branch1_r, init_branch2_r;
	integer sub_LLR, extrinsic0, LLR;
	integer sys_f;
	string line_sys;
	string line_llr, line_ext, line_sub_llr;
	string line_r1, line_r2;
	string line_0_0, line_0_1, line_0_2, line_0_3, line_0_4, line_0_5, line_0_6, line_0_7;


    // FSM
    typedef enum reg[2:0] { IDLE, CALCULATE_0, CALCULATE_1, NORMALIZE_BETA, MAX_0, MAX_1 } statetype;
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
						if (valid_blklen)  			    next_state = CALCULATE_0;
						else						    next_state = IDLE;
		end
		CALCULATE_0	: 	begin
						if (counter == blklen + 4)	    next_state = CALCULATE_1;
						else						    next_state = CALCULATE_0;
		end
		CALCULATE_1 	: begin
						if (counter_i == blklen + 5)	next_state = NORMALIZE_BETA;
						else						    next_state = CALCULATE_1;
		end
        NORMALIZE_BETA 	: begin
						if (counter_reg > blklen + 4)	next_state = MAX_0;
						else						    next_state = NORMALIZE_BETA;
        end
        MAX_0           : begin
                        if (counter_alpha > blklen + 6)	next_state = IDLE;
						else						    next_state = MAX_0;
        end

		endcase
	end

	always_ff @(posedge clk)
	begin
		case (state)
			IDLE 			: begin
	                            counter <= 0;
                                counter_alpha <= 0;
                                counter_i <= 0;
                                counter_reg <= 0;

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
                            beta_reg_0[516] = 0;
			end
			CALCULATE_0		: begin
                                if (valid_branch) begin
                                    init_branch_srl1 <= {init_branch1, init_branch_srl1[0:514]};
                                    init_branch_srl2 <= {init_branch2, init_branch_srl2[0:514]};
                                    counter <= counter + 1;
                                    //
		                            alpha_i[0] <= {alpha_0, alpha_i[0][0:514]};
                                    alpha_i[1] <= {alpha_1, alpha_i[1][0:514]};
		                            alpha_i[2] <= {alpha_2, alpha_i[2][0:514]};
		                            alpha_i[3] <= {alpha_3, alpha_i[3][0:514]};
		                            alpha_i[4] <= {alpha_4, alpha_i[4][0:514]};
		                            alpha_i[5] <= {alpha_5, alpha_i[5][0:514]};
		                            alpha_i[6] <= {alpha_6, alpha_i[6][0:514]};
		                            alpha_i[7] <= {alpha_7, alpha_i[7][0:514]};      
                                end

                                if (valid_apriori)
                                    apriori_srl <= {apriori, apriori_srl[0:514]};
                                
                                if (valid_sys)
                                    sys_srl <= {sys, sys_srl[0:514]};
			end
			CALCULATE_1		: begin
                                for (int i = 1; i < blklen + 6; i++) begin
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
            NORMALIZE_BETA  : begin
                                // for (int i = 1; i < blklen + 6; i++) begin
                                    beta_reg_0[counter_reg] <= $signed(beta_0_i[counter_reg] - beta_0_i[counter_reg]); // 515 - counter_reg
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
            MAX_0           : begin
                                llr_1[0] <= $signed(alpha_i[0][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_4[counter_alpha]);  // beta_reg - 1 because name [0:7]
                                llr_1[1] <= $signed(alpha_i[1][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_0[counter_alpha]);
                                // max(2)
                                llr_1[2] <= $signed(alpha_i[2][counter_alpha] - init_branch_srl2[counter_alpha] + beta_reg_1[counter_alpha]);
                                llr_1[3] <= $signed(alpha_i[3][counter_alpha] - init_branch_srl2[counter_alpha] + beta_reg_5[counter_alpha]);
                                // max(3) 
                                llr_1[4] <= $signed(alpha_i[4][counter_alpha] - init_branch_srl2[counter_alpha] + beta_reg_6[counter_alpha]);
                                llr_1[5] <= $signed(alpha_i[5][counter_alpha] - init_branch_srl2[counter_alpha] + beta_reg_2[counter_alpha]);
                                // max(4)
                                llr_1[6] <= $signed(alpha_i[6][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_3[counter_alpha]);
                                llr_1[7] <= $signed(alpha_i[7][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_7[counter_alpha]);
                                ///////////////////////////////
                                // max(1)
                                llr_2[0] <= $signed(alpha_i[0][counter_alpha] + init_branch_srl1[counter_alpha] + beta_reg_0[counter_alpha]); 
                                llr_2[1] <= $signed(alpha_i[1][counter_alpha] + init_branch_srl1[counter_alpha] + beta_reg_4[counter_alpha]);
                                // max(2)
                                llr_2[2] <= $signed(alpha_i[2][counter_alpha] + init_branch_srl2[counter_alpha] + beta_reg_5[counter_alpha]);
                                llr_2[3] <= $signed(alpha_i[3][counter_alpha] + init_branch_srl2[counter_alpha] + beta_reg_1[counter_alpha]);
                                // max(3) 
                                llr_2[4] <= $signed(alpha_i[4][counter_alpha] + init_branch_srl2[counter_alpha] + beta_reg_2[counter_alpha]);
                                llr_2[5] <= $signed(alpha_i[5][counter_alpha] + init_branch_srl2[counter_alpha] + beta_reg_6[counter_alpha]);
                                // max(4)
                                llr_2[6] <= $signed(alpha_i[6][counter_alpha] + init_branch_srl1[counter_alpha] + beta_reg_7[counter_alpha]);
                                llr_2[7] <= $signed(alpha_i[7][counter_alpha] + init_branch_srl1[counter_alpha] + beta_reg_3[counter_alpha]);

                                counter_alpha <= counter_alpha + 1;


                                if (counter_alpha > 0) begin
                                    for (int i = 0; i < 4; i++) begin
                                        llr_1_max_0[i] <= ($signed(llr_1[(i*2)+1]) > $signed(llr_1[(i*2)])) ? llr_1[(i*2)+1] : llr_1[i*2];
                                        llr_2_max_0[i] <= ($signed(llr_2[(i*2)+1]) > $signed(llr_2[(i*2)])) ? llr_2[(i*2)+1] : llr_2[i*2];
                                    end
									// valid_llr_i = (counter_alpha > blklen+4) ? 1'b0 : 1'b1;
                                end

            
                                if (counter_alpha > 1) begin
                                    for (int i = 0; i < 2; i++) begin
                                        llr_1_max_1[i] <= ($signed(llr_1_max_0[(i*2)+1]) > $signed(llr_1_max_0[(i*2)])) ? llr_1_max_0[(i*2)+1] : llr_1_max_0[i*2];
                                        llr_2_max_1[i] <= ($signed(llr_2_max_0[(i*2)+1]) > $signed(llr_2_max_0[(i*2)])) ? llr_2_max_0[(i*2)+1] : llr_2_max_0[i*2];
                                    end
                                end
           
                                if (counter_alpha > 2) begin
                                        llr_1_max_2 <= ($signed(llr_1_max_1[0]) > $signed(llr_1_max_1[1])) ? llr_1_max_1[0] : llr_1_max_1[1];
                                        llr_2_max_2 <= ($signed(llr_2_max_1[0]) > $signed(llr_2_max_1[1])) ? llr_2_max_1[0] : llr_2_max_1[1];
                                        llr_i <= $signed(llr_1_max_2 - llr_2_max_2);
                                end

                                if (counter_alpha > 3) begin
                                    sub_llr_sys_apriori <= $signed(llr_i - sys_srl[counter_alpha-5] - apriori_srl[counter_alpha-5]);
                                    sub_llr_sys_apriori_delay <= sub_llr_sys_apriori;
                                end

                                if (counter_alpha > 4) begin
                                    sign_extrinsic_i <= (sub_llr_sys_apriori[15]) ? {1'b1, 1'b1, llr_sys_apriori_divide[13:0]} : llr_sys_apriori_divide;
                                end
            end
                                
	        endcase
        end


    // assign llr_sys_apriori_divide = (sub_llr_sys_apriori[1:0] == 1) ? (sub_llr_sys_apriori + 1) >> 2 : (sub_llr_sys_apriori[1:0] == 2) ? (sub_llr_sys_apriori + 2) >> 2 : 
	//  (sub_llr_sys_apriori[1:0] == 3) ? (sub_llr_sys_apriori + 3) >> 2 : sub_llr_sys_apriori >> 2 ;

	// assign llr_sys_apriori_divide = (sub_llr_sys_apriori[0] && sub_llr_sys_apriori[15]) ? $signed(sub_llr_sys_apriori + -1) : (sub_llr_sys_apriori[0] && !sub_llr_sys_apriori[15] ? sub_llr_sys_apriori + 1 :
	// sub_llr_sys_apriori);
	assign extrinsic_i = $signed(sub_llr_sys_apriori_delay - sign_extrinsic_i);






	// ********************************* DEBUG

	initial begin

		init_branch1_r = $fopen("init_branch1m.txt", "r");
        init_branch2_r = $fopen("init_branch2m.txt", "r");

		llr1_0 = $fopen("llrm_1_0.txt", "r");
		llr1_1 = $fopen("llrm_1_1.txt", "r");
		llr1_2 = $fopen("llrm_1_2.txt", "r");
		llr1_3 = $fopen("llrm_1_3.txt", "r");

		llr1_4 = $fopen("llrm_1_4.txt", "r");
		llr1_5 = $fopen("llrm_1_5.txt", "r");
		llr1_6 = $fopen("llrm_1_6.txt", "r");
		llr1_7 = $fopen("llrm_1_7.txt", "r");

		llr2_0 = $fopen("llrm_2_0.txt", "r");
		llr2_1 = $fopen("llrm_2_1.txt", "r");
		llr2_2 = $fopen("llrm_2_2.txt", "r");
		llr2_3 = $fopen("llrm_2_3.txt", "r");

		llr2_4 = $fopen("llrm_2_4.txt", "r");
		llr2_5 = $fopen("llrm_2_5.txt", "r");
		llr2_6 = $fopen("llrm_2_6.txt", "r");
		llr2_7 = $fopen("llrm_2_7.txt", "r");

		sub_LLR = $fopen("sub_LLR.txt", "r");
		extrinsic0 = $fopen("extrinsic.txt", "r");
		LLR = $fopen("LLR.txt", "r");
		sys_f = $fopen("sys.txt", "r");

	end

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


	// always_comb begin
	// if (counter_alpha > 5) begin
	// 	$fgets(line_sub_llr,sub_LLR);
    //     // $fgets(line_ext,extrinsic0);
	// 	$display(line_sub_llr.atoi(), $signed(sub_llr_sys_apriori));
    //     if (line_sub_llr.atoi() !== $signed(sub_llr_sys_apriori))
	// 		$display ("error_sub_llr");
	// end
	// end

	always_comb begin
	if (counter_alpha > 6) begin
		$fgets(line_ext,extrinsic0);
        // $fgets(line_ext,extrinsic0);
		$display(line_ext.atoi(), $signed(extrinsic_i));
        if (line_ext.atoi() !== $signed(extrinsic_i))
			$display ("error_sub_llr");
	end
	end



	
    //////////////////////////////////////////////

    assign init_branch_srl1_i = init_branch_srl1;
    assign init_branch_srl2_i = init_branch_srl2;
    assign counter_reg_i = counter_reg;

    assign beta_reg_0_i = beta_reg_0;
    assign beta_reg_1_i = beta_reg_1;    
    assign beta_reg_2_i = beta_reg_2;
    assign beta_reg_3_i = beta_reg_3;
    assign beta_reg_4_i = beta_reg_4;
    assign beta_reg_5_i = beta_reg_5;
    assign beta_reg_6_i = beta_reg_6;
    assign beta_reg_7_i = beta_reg_7;


    endmodule
