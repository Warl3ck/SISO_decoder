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
    bit [15:0] counter_i;
	wire ready_i;

	integer int_i;

    integer init_branch1_512, init_branch2_512, init_branch1_6144, init_branch2_6144;
	integer alpha0_6144, alpha1_6144, alpha2_6144, alpha3_6144, alpha4_6144, alpha5_6144, alpha6_6144, alpha7_6144;
	integer beta0_6144, beta1_6144, beta2_6144, beta3_6144, beta4_6144, beta5_6144, beta6_6144, beta7_6144;
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
	wire [15:0] alpha_0_i, alpha_1_i, alpha_2_i, alpha_3_i, alpha_4_i, alpha_5_i, alpha_6_i, alpha_7_i;
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

    integer in_f, apriori_f, ext_out;

    event reset_complete;

	always #(CLK_PERIOD/2) clk_i = ~clk_i;
	
    task write
    ( 
		input integer num
	);

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

	endtask : write


	task check
	( 
		input integer check_file
	);

	case (check_file)
        extrinsic_512: begin
	    	ext_out = $fopen("extrinsic_512.txt", "r");
        end	
        extrinsic_6144: begin
 			ext_out = $fopen("extrinsic_6144.txt", "r");
        end
    endcase

		@(posedge valid_extrinsic)
		counter_i = 0;
		while (valid_extrinsic) begin
			@(posedge clk_i)
			counter_i = counter_i + 1;
			$fgets(line_ext, ext_out);
			$display(counter_i, line_ext.atoi(), $signed(extrinsic));
       		if (line_ext.atoi() !== $signed(extrinsic))
				$display ("error_sub_llr");
		end
	endtask : check


	initial begin
        	extrinsic_512 = $fopen("extrinsic_512.txt", "r");
			extrinsic_6144 = $fopen("extrinsic_6144.txt", "r");
	end
	// always_comb begin
	// if (valid_beta) begin
	// 	counter_i = counter_i + 1;
	//  	$fgets(line_r0,beta0_6144);
    //     $fgets(line_r1,beta1_6144);
    //     $fgets(line_r2,beta2_6144);
	// 	$fgets(line_r3,beta3_6144);
	// 	$fgets(line_r4,beta4_6144);
    //     $fgets(line_r5,beta5_6144);
	// 	$fgets(line_r6,beta6_6144);
	// 	$fgets(line_r7,beta7_6144);
	// 	// $display(line_r1.atoi(), $signed(alpha_1_i), "|", line_r2.atoi(), $signed(alpha_2_i), "|", line_r3.atoi(), $signed(alpha_3_i));
	// 		$display(counter_i, line_r0.atoi(), $signed(beta_0), line_r1.atoi(), $signed(beta_1),"|", line_r2.atoi(), $signed(beta_2),"|", line_r3.atoi(), $signed(beta_3),
	// 		"|", line_r4.atoi(), $signed(beta_4), "|", line_r5.atoi(), $signed(beta_5), "|", line_r6.atoi(), $signed(beta_6), "|", line_r7.atoi(), $signed(beta_7));
	// 		if (line_r0.atoi() !== $signed(beta_0) || line_r1.atoi() !== $signed(beta_1) || line_r2.atoi() !== $signed(beta_2) || line_r3.atoi() !== $signed(beta_3)
	// 		|| line_r4.atoi() !== $signed(beta_4) || line_r5.atoi() !== $signed(beta_5) || line_r6.atoi() !== $signed(beta_6) || line_r7.atoi() !== $signed(beta_7))
	// 			$display ("error");
	// 	end
	// end


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


    
	// always_ff @(posedge clk_i) begin
	// if (valid_extrinsic) begin
	// 	counter_i <= counter_i + 1;
	// 	$fgets(line_ext,extrinsic_512);
	// 	$display(counter_i, line_ext.atoi(), $signed(extrinsic));
    //     if (line_ext.atoi() !== $signed(extrinsic))
	// 		$display ("error_sub_llr");
	// end
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
        write(512);
		check(.check_file(extrinsic_512));
		//
		write(6144);
		check(.check_file(extrinsic_6144));
		// 
		write(6144);
		check(.check_file(extrinsic_6144));
		//
        write(512);
		check(.check_file(extrinsic_512));
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
        .valid_extrinsic    (valid_extrinsic)
    );

endmodule
