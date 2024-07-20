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


    // module fsm 
    // (
    //     clk,
    //     rst,
    //     valid_blklen,
    //     blklen,
    //     valid_branch,
    //     fsm_state
    // );

    // input clk;
    // input rst;
    // input [15:0] blklen;
    // input valid_blklen;
    // input valid_branch;
    // output [1:0] fsm_state;


    // reg [15:0] counter_fsm;


    // // FSM
    // typedef enum reg[1:0] { IDLE, CALCULATE_0, CALCULATE_1 } statetype;
    // statetype state, next_state;


    // always_ff @(posedge clk)
	// begin
	// 	if (rst) 
	// 		state <= IDLE;
	// 	else 
	// 		state <= next_state;
	// end

    // always_comb
	// begin
	// 	case (state)
	// 	IDLE 			: begin
	// 					if (valid_blklen)  			    next_state = CALCULATE_0;
	// 					else						    next_state = IDLE;
	// 	end
	// 	CALCULATE_0	: 	begin
	// 					if (counter_fsm == blklen + 3)	next_state = IDLE;
	// 					else						    next_state = CALCULATE_0;
	// 	end
	// 	// CALCULATE_1 	: begin
	// 	// 				if (!done)					next_state = CALCULATE_0;
	// 	// 				else if (!en)				next_state = IDLE;
	// 	// 				else						next_state = CALCULATE_1;
	// 	// end
	// 	endcase
	// end

	// always_ff @(posedge clk)
	// begin
	// 	case (state)
	// 		IDLE 			: begin
	//                             counter_fsm <= 0;
	// 						end
	// 		CALCULATE_0		: begin
    //                             if (valid_branch) begin
    //                                 counter_fsm <= counter_fsm + 1;
    //                             end

	// 						end
	// 		CALCULATE_1		: begin

	// 						end
	// 	endcase
	// end


    // assign fsm_state = state;

    // endmodule

    // fsm fsm_inst
    // (
    //     .clk            (clk),
    //     .rst            (rst),
    //     .valid_blklen   (valid_blklen),
    //     .blklen         (blklen),
    //     .valid_branch   (valid_branch_i),
    //     .fsm_state      (fsm_state_i)
    // );





    module beta 
    (
        clk,
        rst,
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
        //
        valid_blklen,
        blklen
        // fsm_state
    );

    input clk;
    input rst;
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
    //
    input [15:0] alpha_0;
    input [15:0] alpha_1;
    input [15:0] alpha_2;
    input [15:0] alpha_3;
    input [15:0] alpha_4;
    input [15:0] alpha_5;
    input [15:0] alpha_6;
    input [15:0] alpha_7;
    input valid_alpha;

    // input [1:0] fsm_state;
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
                                llr_1[3] <= $signed(alpha_i[3][counter_alpha] - init_branch_srl1[counter_alpha] + beta_reg_5[counter_alpha]);
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
                
    assign llr_sys_apriori_divide = (sub_llr_sys_apriori[0]) ?  (sub_llr_sys_apriori + 1) >> 2 : sub_llr_sys_apriori >> 2 ;
    assign extrinsic_i = $signed(sub_llr_sys_apriori_delay - sign_extrinsic_i);

    //////////////////////////////////////////////
    // always_ff @(posedge clk) begin
    //     if (valid_branch & counter < blklen + 4) begin
    //         init_branch_srl1 <= {init_branch1, init_branch_srl1[0:514]};
    //         init_branch_srl2 <= {init_branch2, init_branch_srl2[0:514]};
    //         counter <= counter + 1;
    //     end
    // end


    // always_ff @(posedge clk) begin
    //     if (counter == blklen + 4) begin
    //         for (int i = 1; i < blklen + 6; i++) begin
    //             beta_0_i[i] <= ($signed(beta_0_i[i-1] + init_branch_srl1[i-1]) > $signed(beta_4_i[i-1] - init_branch_srl1[i-1])) ? beta_0_i[i-1] + init_branch_srl1[i-1] : beta_4_i[i-1] - init_branch_srl1[i-1]; 
    //             beta_1_i[i] <= ($signed(beta_4_i[i-1] + init_branch_srl1[i-1]) > $signed(beta_0_i[i-1] - init_branch_srl1[i-1])) ? beta_4_i[i-1] + init_branch_srl1[i-1] : beta_0_i[i-1] - init_branch_srl1[i-1]; 
    //             beta_2_i[i] <= ($signed(beta_5_i[i-1] + init_branch_srl2[i-1]) > $signed(beta_1_i[i-1] - init_branch_srl2[i-1])) ? beta_5_i[i-1] + init_branch_srl2[i-1] : beta_1_i[i-1] - init_branch_srl2[i-1];
    //             beta_3_i[i] <= ($signed(beta_1_i[i-1] + init_branch_srl2[i-1]) > $signed(beta_5_i[i-1] - init_branch_srl2[i-1])) ? beta_1_i[i-1] + init_branch_srl2[i-1] : beta_5_i[i-1] - init_branch_srl2[i-1];
    //             beta_4_i[i] <= ($signed(beta_2_i[i-1] + init_branch_srl2[i-1]) > $signed(beta_6_i[i-1] - init_branch_srl2[i-1])) ? beta_2_i[i-1] + init_branch_srl2[i-1] : beta_6_i[i-1] - init_branch_srl2[i-1];
    //             beta_5_i[i] <= ($signed(beta_6_i[i-1] + init_branch_srl2[i-1]) > $signed(beta_2_i[i-1] - init_branch_srl2[i-1])) ? beta_6_i[i-1] + init_branch_srl2[i-1] : beta_2_i[i-1] - init_branch_srl2[i-1];
    //             beta_6_i[i] <= ($signed(beta_7_i[i-1] + init_branch_srl1[i-1]) > $signed(beta_3_i[i-1] - init_branch_srl1[i-1])) ? beta_7_i[i-1] + init_branch_srl1[i-1] : beta_3_i[i-1] - init_branch_srl1[i-1];
    //             beta_7_i[i] <= ($signed(beta_3_i[i-1] + init_branch_srl1[i-1]) > $signed(beta_7_i[i-1] - init_branch_srl1[i-1])) ? beta_3_i[i-1] + init_branch_srl1[i-1] : beta_7_i[i-1] - init_branch_srl1[i-1];
    //         end
    //         counter_i <= (counter_i > blklen + 4) ? counter_i : counter_i + 1;
    //    end
    // end


    // always_ff @(posedge clk) begin
    //     if (counter_i == 517) begin
    //         // for (int j = 1; j < 517; j++) begin
    //             beta_reg_0[counter_reg] <= $signed(beta_0_i[counter_reg] - beta_0_i[counter_reg]); // 515 - counter_reg
    //             beta_reg_1[counter_reg] <= $signed(beta_1_i[counter_reg] - beta_0_i[counter_reg]);
    //             beta_reg_2[counter_reg] <= $signed(beta_2_i[counter_reg] - beta_0_i[counter_reg]);
    //             beta_reg_3[counter_reg] <= $signed(beta_3_i[counter_reg] - beta_0_i[counter_reg]);
    //             beta_reg_4[counter_reg] <= $signed(beta_4_i[counter_reg] - beta_0_i[counter_reg]);
    //             beta_reg_5[counter_reg] <= $signed(beta_5_i[counter_reg] - beta_0_i[counter_reg]);
    //             beta_reg_6[counter_reg] <= $signed(beta_6_i[counter_reg] - beta_0_i[counter_reg]);
    //             beta_reg_7[counter_reg] <= $signed(beta_7_i[counter_reg] - beta_0_i[counter_reg]);
    //         // end
    //     counter_reg <= (counter_reg > blklen + 4) ? counter_reg : counter_reg + 1;
    //     end
    // end

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

    // LLR 
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

    endmodule




    beta beta_inst 
    (
        .clk                (clk),
        .rst                (rst),
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
        .valid_blklen   (valid_blklen),
        .blklen         (blklen)
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
