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
		parameter blklen_w = 6144
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
		fsm_state
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
	output valid_extrinsic;
	output [15:0] extrinsic;
	output [1:0] fsm_state;

	reg [15:0] sys_i;
	reg [15:0] apriori_i;
    reg signed [15:0] sub_llr_sys_apriori [2];
	reg [15:0] sub_llr_sys_apriori_un;
	reg [15:0] sub_llr_sys_apriori_round;
	reg sub_llr_round;
    reg [15:0] counter;

	reg [15:0] alpha_0_reg;
	reg [15:0] alpha_1_reg;
	reg [15:0] alpha_2_reg;
	reg [15:0] alpha_3_reg;
	reg [15:0] alpha_4_reg;
	reg [15:0] alpha_5_reg;
	reg [15:0] alpha_6_reg;
	reg [15:0] alpha_7_reg;

	reg signed [18:0] beta_0_i [0:1];
    reg signed [18:0] beta_1_i [0:1];
    reg signed [18:0] beta_2_i [0:1];
    reg signed [18:0] beta_3_i [0:1];
    reg signed [18:0] beta_4_i [0:1];
    reg signed [18:0] beta_5_i [0:1];
    reg signed [18:0] beta_6_i [0:1];
    reg signed [18:0] beta_7_i [0:1];
	//
    reg [18:0] beta_reg_0;
    reg [18:0] beta_reg_1;
    reg [18:0] beta_reg_2;
    reg [18:0] beta_reg_3;
    reg [18:0] beta_reg_4;
    reg [18:0] beta_reg_5;
    reg [18:0] beta_reg_6;
    reg [18:0] beta_reg_7;
    //
    reg [15:0] sub_alpha_init_branch1 [8];
	reg [15:0] sub_alpha_init_branch2 [8];

    reg signed [15:0] llr_1 [8];
    reg signed [15:0] llr_2 [8];
	reg [15:0] llr_1_reg [8];
    reg [15:0] llr_2_reg [8];
    reg signed [15:0] llr_1_max_0 [4];
    reg signed [15:0] llr_2_max_0 [4];
	reg signed [15:0] llr_1_max_0_reg [4];
    reg signed [15:0] llr_2_max_0_reg [4];
    reg signed [15:0] llr_1_max_1 [2];
    reg signed [15:0] llr_2_max_1 [2];
    reg signed [15:0] llr_1_max_2;
    reg signed [15:0] llr_2_max_2;
    reg signed [15:0] llr_i;
	reg signed [15:0] llr_i_reg;

	reg [3:0] valid_branch_i;
	reg [12:0] counter_init_branch_i [3:0];
	reg [15:0] alpha_i [7:0];
	reg [15:0] alpha_reg [7:0];
	reg [3:0] enable;

	reg  [15:0] extrinsic_array [blklen_w + 4];

	reg valid_i;
	reg [0:7] valid_extrinsic_i;
    reg [15:0] extrinsic_i;
	reg [15:0] llr_sys_apriori_predivide;
	reg [15:0] llr_sys_apriori_divide;
	reg [15:0] extrinsic_a;
	reg valid_ex_a;

	wire signed [15:0] init_branch1_dout;
	wire signed [15:0] init_branch2_dout;
	wire [15:0] counter_init_branch;


    // FSM
    typedef enum reg[1:0] { IDLE, CALCULATE_0, CALCULATE_1, SAVE_ARRAY } statetype;
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
		CALCULATE_0		: 	begin
						if (counter == blklen + 4)	    	next_state = CALCULATE_1;
						else						    	next_state = CALCULATE_0;
		end
		CALCULATE_1 	: begin
						if (counter == 0)					next_state = SAVE_ARRAY;
						else						    	next_state = CALCULATE_1;
		end
		SAVE_ARRAY 		: begin
						if (counter == blklen + 10)			next_state = IDLE;
						else						    	next_state = SAVE_ARRAY;
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

							for (int i = 0; i < 8; i++) begin
								sub_alpha_init_branch1[i] <= {16{1'b0}};
								sub_alpha_init_branch2[i] <= {16{1'b0}};
							end

							valid_i <= 1'b0;
							extrinsic_a <= {16{1'b0}};
							valid_ex_a <= 1'b0;
			end
			CALCULATE_0		: begin
                            if (valid_branch) begin
								counter <= counter + 1;    
                            end
			end
			CALCULATE_1		: begin

							valid_i <= (!valid_i) ? 1'b1 : 1'b0; 

							if (valid_i) begin
								beta_0_i[0] <= ((beta_0_i[1] + init_branch1_dout) > (beta_4_i[1] - init_branch1_dout)) ? beta_0_i[1] + init_branch1_dout : beta_4_i[1] - init_branch1_dout;		
                            	beta_1_i[0] <= ((beta_4_i[1] + init_branch1_dout) > (beta_0_i[1] - init_branch1_dout)) ? beta_4_i[1] + init_branch1_dout : beta_0_i[1] - init_branch1_dout; 
                            	beta_2_i[0] <= ((beta_5_i[1] + init_branch2_dout) > (beta_1_i[1] - init_branch2_dout)) ? beta_5_i[1] + init_branch2_dout : beta_1_i[1] - init_branch2_dout;
                            	beta_3_i[0] <= ((beta_1_i[1] + init_branch2_dout) > (beta_5_i[1] - init_branch2_dout)) ? beta_1_i[1] + init_branch2_dout : beta_5_i[1] - init_branch2_dout;
                            	beta_4_i[0] <= ((beta_2_i[1] + init_branch2_dout) > (beta_6_i[1] - init_branch2_dout)) ? beta_2_i[1] + init_branch2_dout : beta_6_i[1] - init_branch2_dout;
                            	beta_5_i[0] <= ((beta_6_i[1] + init_branch2_dout) > (beta_2_i[1] - init_branch2_dout)) ? beta_6_i[1] + init_branch2_dout : beta_2_i[1] - init_branch2_dout;
                            	beta_6_i[0] <= ((beta_7_i[1] + init_branch1_dout) > (beta_3_i[1] - init_branch1_dout)) ? beta_7_i[1] + init_branch1_dout : beta_3_i[1] - init_branch1_dout;
                            	beta_7_i[0] <= ((beta_3_i[1] + init_branch1_dout) > (beta_7_i[1] - init_branch1_dout)) ? beta_3_i[1] + init_branch1_dout : beta_7_i[1] - init_branch1_dout;
								counter <= counter - 1;
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

							sub_alpha_init_branch1[0] <= alpha_0_reg - init_branch1_dout;  
							sub_alpha_init_branch1[1] <= alpha_1_reg - init_branch1_dout;
							sub_alpha_init_branch1[2] <= alpha_2_reg - init_branch2_dout;
							sub_alpha_init_branch1[3] <= alpha_3_reg - init_branch2_dout;
							sub_alpha_init_branch1[4] <= alpha_4_reg - init_branch2_dout;
							sub_alpha_init_branch1[5] <= alpha_5_reg - init_branch2_dout;
							sub_alpha_init_branch1[6] <= alpha_6_reg - init_branch1_dout;
							sub_alpha_init_branch1[7] <= alpha_7_reg - init_branch1_dout;
							sub_alpha_init_branch2[0] <= alpha_0_reg + init_branch1_dout; 
    						sub_alpha_init_branch2[1] <= alpha_1_reg + init_branch1_dout;
    						sub_alpha_init_branch2[2] <= alpha_2_reg + init_branch2_dout;
    						sub_alpha_init_branch2[3] <= alpha_3_reg + init_branch2_dout;
    						sub_alpha_init_branch2[4] <= alpha_4_reg + init_branch2_dout;
    						sub_alpha_init_branch2[5] <= alpha_5_reg + init_branch2_dout;
    						sub_alpha_init_branch2[6] <= alpha_6_reg + init_branch1_dout;
    						sub_alpha_init_branch2[7] <= alpha_7_reg + init_branch1_dout;	

							llr_1[0] <= sub_alpha_init_branch1[0] + beta_reg_4[15:0];  
							llr_1[1] <= sub_alpha_init_branch1[1] + beta_reg_0[15:0];
            				llr_1[2] <= sub_alpha_init_branch1[2] + beta_reg_1[15:0];
            				llr_1[3] <= sub_alpha_init_branch1[3] + beta_reg_5[15:0];
            				llr_1[4] <= sub_alpha_init_branch1[4] + beta_reg_6[15:0];
            				llr_1[5] <= sub_alpha_init_branch1[5] + beta_reg_2[15:0];
            				llr_1[6] <= sub_alpha_init_branch1[6] + beta_reg_3[15:0];
            				llr_1[7] <= sub_alpha_init_branch1[7] + beta_reg_7[15:0];
            				llr_2[0] <= sub_alpha_init_branch2[0] + beta_reg_0[15:0]; 
            				llr_2[1] <= sub_alpha_init_branch2[1] + beta_reg_4[15:0];
            				llr_2[2] <= sub_alpha_init_branch2[2] + beta_reg_5[15:0];
            				llr_2[3] <= sub_alpha_init_branch2[3] + beta_reg_1[15:0];
            				llr_2[4] <= sub_alpha_init_branch2[4] + beta_reg_2[15:0];
            				llr_2[5] <= sub_alpha_init_branch2[5] + beta_reg_6[15:0];
            				llr_2[6] <= sub_alpha_init_branch2[6] + beta_reg_7[15:0];
            				llr_2[7] <= sub_alpha_init_branch2[7] + beta_reg_3[15:0];	


							if (valid_extrinsic_i[7])
								extrinsic_array <= {extrinsic_i, extrinsic_array[0:blklen_w + 2]};
								
            end        
			SAVE_ARRAY		: begin
							valid_i <= 1'b0;

							if (valid_extrinsic_i[5])
								extrinsic_array <= {extrinsic_i, extrinsic_array[0:blklen_w + 2]};

							if (counter > 6) begin
								extrinsic_a <= extrinsic_array[counter - 7];
								valid_ex_a <= 1'b1;
							end
							counter <= (counter != blklen + 10) ? counter + 1 : counter;
			end            
	        endcase
        end

	assign beta_reg_0 = beta_0_i[1] - beta_0_i[0]; 
    assign beta_reg_1 = beta_1_i[1] - beta_0_i[0];
    assign beta_reg_2 = beta_2_i[1] - beta_0_i[0];
    assign beta_reg_3 = beta_3_i[1] - beta_0_i[0];
    assign beta_reg_4 = beta_4_i[1] - beta_0_i[0];
    assign beta_reg_5 = beta_5_i[1] - beta_0_i[0];
    assign beta_reg_6 = beta_6_i[1] - beta_0_i[0];
    assign beta_reg_7 = beta_7_i[1] - beta_0_i[0];

	always_comb
	begin
		if (valid_i) begin                  				                            
            llr_1_max_0[0] = (llr_1[1] > llr_1[0]) ? llr_1[1] : llr_1[0];
			llr_1_max_0[1] = (llr_1[3] > llr_1[2]) ? llr_1[3] : llr_1[2];
			llr_1_max_0[2] = (llr_1[5] > llr_1[4]) ? llr_1[5] : llr_1[4];
			llr_1_max_0[3] = (llr_1[7] > llr_1[6]) ? llr_1[7] : llr_1[6];
			llr_2_max_0[0] = (llr_2[1] > llr_2[0]) ? llr_2[1] : llr_2[0];
			llr_2_max_0[1] = (llr_2[3] > llr_2[2]) ? llr_2[3] : llr_2[2];
			llr_2_max_0[2] = (llr_2[5] > llr_2[4]) ? llr_2[5] : llr_2[4];
			llr_2_max_0[3] = (llr_2[7] > llr_2[6]) ? llr_2[7] : llr_2[6];
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
		if (valid_i || valid_extrinsic_i[1]) begin  
			llr_1_max_1[0] = (llr_1_max_0_reg[1] > llr_1_max_0_reg[0]) ? llr_1_max_0_reg[1] : llr_1_max_0_reg[0];
			llr_1_max_1[1] = (llr_1_max_0_reg[3] > llr_1_max_0_reg[2]) ? llr_1_max_0_reg[3] : llr_1_max_0_reg[2];
			llr_2_max_1[0] = (llr_2_max_0_reg[1] > llr_2_max_0_reg[0]) ? llr_2_max_0_reg[1] : llr_2_max_0_reg[0];
			llr_2_max_1[1] = (llr_2_max_0_reg[3] > llr_2_max_0_reg[2]) ? llr_2_max_0_reg[3] : llr_2_max_0_reg[2];
			//
        	llr_1_max_2 = (llr_1_max_1[0] > llr_1_max_1[1]) ? llr_1_max_1[0] : llr_1_max_1[1];
        	llr_2_max_2 = (llr_2_max_1[0] > llr_2_max_1[1]) ? llr_2_max_1[0] : llr_2_max_1[1];
        	llr_i = llr_1_max_2 - llr_2_max_2;
		end
	end
 
 	always_ff @(posedge clk)
	begin
		if (rst) begin
			valid_extrinsic_i <= {4{1'b0}};
		end else begin
			valid_extrinsic_i <= {valid_i, valid_extrinsic_i[0:6]};
			llr_i_reg <= llr_i;

		end
	end

	assign valid_branch_i = {valid_branch, valid_branch, valid_branch, valid_branch};

	assign counter_init_branch_i[0] = counter_init_branch[12:0]; 
	assign counter_init_branch_i[1] = counter_init_branch[12:0]; 
	assign counter_init_branch_i[2] = counter_init_branch[12:0]; 
	assign counter_init_branch_i[3] = counter_init_branch[12:0]; 

	assign alpha_i[0] = alpha_0;
	assign alpha_i[1] = alpha_1;
	assign alpha_i[2] = alpha_2;
	assign alpha_i[3] = alpha_3;
	assign alpha_i[4] = alpha_4;
	assign alpha_i[5] = alpha_5;
	assign alpha_i[6] = alpha_6;
	assign alpha_i[7] = alpha_7;

	assign alpha_0_reg = alpha_reg[0];
	assign alpha_1_reg = alpha_reg[1];
	assign alpha_2_reg = alpha_reg[2];
	assign alpha_3_reg = alpha_reg[3];
	assign alpha_4_reg = alpha_reg[4];
	assign alpha_5_reg = alpha_reg[5];
	assign alpha_6_reg = alpha_reg[6];
	assign alpha_7_reg = alpha_reg[7];

	assign enable = {1'b1, 1'b1, 1'b1, 1'b1};

	assign counter_init_branch = (state == CALCULATE_1) ? counter - 1 : counter;

	always_ff @(posedge clk)
	begin
		if (rst) begin
			for (int i = 0; i < 2; i++) begin
				sub_llr_sys_apriori[i] <= {16{1'b0}};
			end
		end else begin
			sub_llr_sys_apriori[0] <= llr_i_reg - sys_i - apriori_i; 
			sub_llr_sys_apriori[1] <= sub_llr_sys_apriori[0];
		end
	end

	assign sub_llr_sys_apriori_un = (sub_llr_sys_apriori[0][15]) ? (~sub_llr_sys_apriori[0] + 1) : sub_llr_sys_apriori[0];
	assign llr_sys_apriori_divide = sub_llr_sys_apriori_un >> 2;
	assign llr_sys_apriori_predivide = llr_sys_apriori_divide << 2;
	assign sub_llr_round = ((sub_llr_sys_apriori_un - llr_sys_apriori_predivide) == 3) ? 1'b1 : 1'b0;


	always_ff @(posedge clk)
	begin
		if (rst)
			sub_llr_sys_apriori_round <= {16{1'b0}};
		else
			sub_llr_sys_apriori_round <= (sub_llr_round) ? llr_sys_apriori_divide + 1 : llr_sys_apriori_divide;
	end 

	always_ff @(posedge clk)
	begin
		// if (sub_llr_sys_apriori[1][15])
			extrinsic_i <= (sub_llr_sys_apriori[1][15]) ? sub_llr_sys_apriori[1] - (- sub_llr_sys_apriori_round) : sub_llr_sys_apriori[1] - sub_llr_sys_apriori_round;
	end

	ram ram_sys_inst
	(
		.clk	(clk),
		.we		(valid_sys),
		.addr	(counter),
		.di		(sys),
		.dout	(sys_i)
	);

	ram ram_apriori_inst
	(
		.clk	(clk),
		.we		(valid_apriori),
		.addr	(counter),
		.di		(apriori),
		.dout	(apriori_i)
	);

	ram ram_init_branch1_inst
	(
		.clk	(clk),
		.we		(valid_branch),
		.addr	(counter_init_branch),
		.di		(init_branch1),
		.dout	(init_branch1_dout)
	);

	ram ram_init_branch2_inst
	(
		.clk	(clk),
		.we		(valid_branch),
		.addr	(counter_init_branch),
		.di		(init_branch2),
		.dout	(init_branch2_dout)
	);

 	ram_3d  #(.NUM_RAMS(4), .A_WID(13), .D_WID(16))
	ram_3d_inst0
	(
		.clk	(clk),
		.we		(valid_branch_i),
		.ena	(enable),
		.addr	(counter_init_branch_i),
		.din 	(alpha_i[3:0]),
		.dout	(alpha_reg[3:0])
	);

	ram_3d  #(.NUM_RAMS(4), .A_WID(13), .D_WID(16))
	ram_3d_inst1
	(
		.clk	(clk),
		.we		(valid_branch_i),
		.ena	(enable),
		.addr	(counter_init_branch_i),
		.din 	(alpha_i[7:4]),
		.dout	(alpha_reg[7:4])
	);

	// assign we_extrinsic_ram = (state == CALCULATE_1) ? (valid_extrinsic_i[7]) : (state == SAVE_ARRAY) ? valid_extrinsic_i[5] : 1'b0;

	// ram extrinsic_array_inst
	// (
	// 	.clk	(clk),
	// 	.we		(we_extrinsic_ram),
	// 	.addr	(counter),
	// 	.di		(extrinsic_i),
	// 	.dout	(ram_dout)
	// );

	assign extrinsic = extrinsic_a; 
	assign valid_extrinsic = valid_ex_a; 

	assign fsm_state = state;

    endmodule
