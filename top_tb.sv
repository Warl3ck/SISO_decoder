`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2024 02:44:29 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb(
    );


    parameter CLK_PERIOD = 10ns;

	bit clk_i = 1'b0;
	bit rst = 1'b1;
	bit valid = 1'b0;
    bit [15:0] in = 0;
    bit [15:0] apriori = 0;
    bit valid_apriori, valid_apriori_i;
    bit [15:0] blklen;
    bit valid_blklen;
    bit [15:0] extrinsic;
    bit valid_extrinsic;
    bit [15:0] counter_i = 0;
	wire ready_i;

	reg [15:0] qwerty0 = 16'h7fff;
	reg [15:0] qwerty1 = 100;
	reg [15:0] sum, sum1;
	shortint ch;

	initial begin
		assign sum = $signed(qwerty0 + qwerty1);
		assign sum1 = $signed(qwerty0 - qwerty1);
		assign ch = (16'h7fff < 16'h8000) ? 16'h7fff : 16'h8000;

	end

	integer int_i;

    integer init_branch1_512, init_branch2_512, init_branch1_6144, init_branch2_6144;
	integer alpha0_6144, alpha1_6144, alpha2_6144, alpha3_6144, alpha4_6144, alpha5_6144, alpha6_6144, alpha7_6144;
	integer beta1_6144, beta2_6144, beta3_6144;
	integer qq1_6144, qq2_6144, qq3_6144;
    integer llr1_0, llr1_1, llr1_2, llr1_3, llr1_4, llr1_5, llr1_6, llr1_7, llr2_0, llr2_1, llr2_2, llr2_3, llr2_4, llr2_5, llr2_6, llr2_7;
	integer sub_LLR, extrinsic_512, LLR, extrinsic_6144;
	integer sys_f;
	string line_sys;
	string line_llr, line_ext, line_sub_llr;
	string line, line_r0, line_r1, line_r2, line_r3, line_r4, line_r5, line_r6, line_r7;
	string line_0_0, line_0_1, line_0_2, line_0_3, line_0_4, line_0_5, line_0_6, line_0_7;

	wire [15:0] init_branch1, init_branch2;
	wire valid_branch;
	wire [18:0] alpha_0_i, alpha_1_i, alpha_2_i, alpha_3_i, alpha_4_i, alpha_5_i, alpha_6_i, alpha_7_i;
    wire valid_alpha_i;

	wire [15:0] beta_0;
    wire [15:0] beta_1;
    wire [15:0] beta_2;
    wire [15:0] beta_3;
    wire [15:0] beta_4;
    wire [15:0] beta_5;
    wire [15:0] beta_6;
    wire [15:0] beta_7;
    wire valid_beta;

    integer in_f, apriori_f;

    event reset_complete;

	always #(CLK_PERIOD/2) clk_i = ~clk_i;
	
    task write
    ( 
		input integer num,
		output integer num_out
	);
	num_out = num;
    case (num)
        512: begin
	        in_f = $fopen("in_512.txt", "r");	
            apriori_f = $fopen("apriori_512.txt", "r");
            blklen <= 512;
        end	
        6144: begin
            in_f = $fopen("in_6144.txt", "r");	
            apriori_f = $fopen("apriori_6144.txt", "r");
            blklen <= 6144;
        end
    endcase

        #20ns
        @(posedge clk_i);
        valid_blklen <= 1'b1;
        #(CLK_PERIOD);
        valid_blklen <= 1'b0;
        while (!$feof(in_f)) begin
            @(posedge clk_i);
            valid <= 1'b1;
            $fgets(line,in_f);
            in <= line.atoi();
            valid_apriori <= (!valid_apriori) ? 1'b1 : 1'b0; 
            if (valid_apriori) begin
                $fgets(line,apriori_f);
                apriori <= line.atoi();
            end
        end
        valid <= 1'b0;
        valid_apriori <= 1'b0;	
		#15us;
	endtask : write

    initial begin
		init_branch1_512 = $fopen("init_branch1_512.txt", "r");
		init_branch2_512 = $fopen("init_branch2_512.txt", "r");
		init_branch1_6144 = $fopen("init_branch1_6144.txt", "r");
		init_branch2_6144 = $fopen("init_branch2_6144.txt", "r");

		extrinsic_6144 = $fopen("extrinsic_6144.txt", "r");
		extrinsic_512 = $fopen("extrinsic.txt", "r");

		// alpha0_6144 = $fopen("alpha0u_6144.txt", "r");
		// alpha1_6144 = $fopen("alpha1u_6144.txt", "r");
		// alpha2_6144 = $fopen("alpha2u_6144.txt", "r");
		// alpha3_6144 = $fopen("alpha3u_6144.txt", "r");
		// alpha4_6144 = $fopen("alpha4u_6144.txt", "r");
		// alpha5_6144 = $fopen("alpha5u_6144.txt", "r");
		// alpha6_6144 = $fopen("alpha6u_6144.txt", "r");
		// alpha7_6144 = $fopen("alpha7u_6144.txt", "r");

		// alpha1_6144 = $fopen("alpha1s_6144.txt", "r");
		// alpha2_6144 = $fopen("alpha2s_6144.txt", "r");
		// alpha3_6144 = $fopen("alpha3s_6144.txt", "r");
		// alpha4_6144 = $fopen("alpha4s_6144.txt", "r");
		// alpha5_6144 = $fopen("alpha5s_6144.txt", "r");
		// alpha6_6144 = $fopen("alpha6s_6144.txt", "r");
		// alpha7_6144 = $fopen("alpha7s_6144.txt", "r");

		// beta1_6144 = $fopen("beta1_6144.txt", "r");
		// beta2_6144 = $fopen("beta2_6144.txt", "r");
		// beta3_6144 = $fopen("beta3_6144.txt", "r");
	
		// qq1_6144 = $fopen("qq1_6144.txt", "r");
		// qq2_6144 = $fopen("qq2_6144.txt", "r");
		// qq3_6144 = $fopen("qq3_6144.txt", "r");
		
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

		// sub_LLR = $fopen("sub_LLR.txt", "r");
		// LLR = $fopen("LLR.txt", "r");
		// sys_f = $fopen("sys.txt", "r");
    end

	// always_comb begin
	// if (valid_alpha_i) begin
	// 	counter_i = counter_i + 1;
    //     // $fgets(line_r0,alpha0_6144);
    //     $fgets(line_r1,alpha1_6144);
	// 	$fgets(line_r2,alpha2_6144);
	// 	$fgets(line_r3,alpha3_6144);
	// 	$fgets(line_r4,alpha4_6144);
	// 	$fgets(line_r5,alpha5_6144);
	// 	$fgets(line_r6,alpha6_6144);
	// 	$fgets(line_r7,alpha7_6144);

	// 	// $display(line_r1.atoi(), $signed(alpha_1_i), "|", line_r2.atoi(), $signed(alpha_2_i), "|", line_r3.atoi(), $signed(alpha_3_i));
	// 		$display(counter_i, line_r1.atoi(), $signed(alpha_1_i), line_r2.atoi(), $signed(alpha_2_i),
	// 		line_r3.atoi(), $signed(alpha_3_i), line_r4.atoi(), $signed(alpha_4_i), line_r5.atoi(), $signed(alpha_5_i), line_r6.atoi(), $signed(alpha_6_i), line_r7.atoi(), $signed(alpha_7_i));
	// 		// if (line_r1.atoi() !== $signed(alpha_1_i) || line_r2.atoi() !== $signed(alpha_2_i) || line_r3.atoi() !== $signed(alpha_3_i))
	// 		// 	$display ("error");
	// 	end
	// end

	// always_comb begin
	// if (valid_beta) begin
	// 	counter_i = counter_i + 1;
    //     $fgets(line_r1,qq1_6144);
    //     $fgets(line_r2,qq2_6144);
	// 	$fgets(line_r3,qq3_6144);
	// 	// $display(line_r1.atoi(), $signed(alpha_1_i), "|", line_r2.atoi(), $signed(alpha_2_i), "|", line_r3.atoi(), $signed(alpha_3_i));
	// 		$display(counter_i, line_r1.atoi(), $signed(beta_0),"|", line_r2.atoi(), $signed(beta_1),"|", line_r3.atoi(), $signed(beta_2));
	// 		// if (line_r1.atoi() !== $signed(alpha_1_i) || line_r2.atoi() !== $signed(alpha_2_i) || line_r3.atoi() !== $signed(alpha_3_i))
	// 		// 	$display ("error");
	// 	end
	// end


    
	// always_comb begin
	// if (valid_extrinsic) begin
	// 	counter_i <= counter_i + 1;
	// 	$fgets(line_ext,extrinsic_6144);
	// 	$display(counter_i, line_ext.atoi(), $signed(extrinsic));
    //     if (line_ext.atoi() !== $signed(extrinsic))
	// 		$display ("error_sub_llr");
	// end
	// end

// ********************************* DEBUG

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
    //     $fgets(line_r1,init_branch1_6144);
    //     $fgets(line_r2,init_branch2_6144);
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


	initial begin
        valid_blklen <= 1'b0;
        blklen <= 0;
	 	rst <= 1'b1;
		#100ns; 
		@(posedge clk_i);
		rst <= 1'b0;
        -> reset_complete;
	end


    initial begin
        @(reset_complete);
        #20ns
        //write(512, .num_out (int_i));
		
		write(6144, .num_out (int_i));
    end

    always_ff @(posedge clk_i) begin
        valid_apriori_i <= valid_apriori;
    end


    top top_inst
    (
        .clk                (clk_i),
        .rst                (rst),
        .in                 (in),
        .valid_in           (valid),
        .valid_apriori      (valid_apriori_i),
        .apriori            (apriori),
        .blklen             (blklen),
        .valid_blklen       (valid_blklen),
        .extrinsic          (extrinsic),
        .valid_extrinsic    (valid_extrinsic),
		.ready				(ready_i),
		//
		.init_branch1 		(init_branch1),
		.init_branch2 		(init_branch2),
		.valid_branch		(valid_branch),
		.alpha_0		    (alpha_0_i),
    	.alpha_1		    (alpha_1_i),
    	.alpha_2		    (alpha_2_i),
    	.alpha_3		    (alpha_3_i),
    	.alpha_4		    (alpha_4_i),
    	.alpha_5		    (alpha_5_i),
    	.alpha_6		    (alpha_6_i),
    	.alpha_7		    (alpha_7_i),
    	.valid_alpha	    (valid_alpha_i),
		.beta_0             (beta_0),
        .beta_1             (beta_1),
        .beta_2             (beta_2),
        .beta_3             (beta_3),
        .beta_4             (beta_4),
        .beta_5             (beta_5),
        .beta_6             (beta_6),
        .beta_7             (beta_7),
        .valid_beta         (valid_beta)
    );


endmodule
