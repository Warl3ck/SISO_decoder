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

	integer init_branch1i, init_branch2i;
    integer init_branch1_r, init_branch2_r;

    integer llr1_0, llr1_1, llr1_2, llr1_3, llr1_4, llr1_5, llr1_6, llr1_7, llr2_0, llr2_1, llr2_2, llr2_3, llr2_4, llr2_5, llr2_6, llr2_7;
	integer init_branch1_r, init_branch2_r;
	integer sub_LLR, extrinsic0, LLR;
	integer sys_f;
	string line_sys;
	string line_llr, line_ext, line_sub_llr;
	string line_r1, line_r2;
	string line_0_0, line_0_1, line_0_2, line_0_3, line_0_4, line_0_5, line_0_6, line_0_7;

	bit [15:0] init_branch1, init_branch2;
	bit valid_out;

    integer in_f, apriori_f;
    string line, line_r1, line_r2;

    event reset_complete;

	always #(CLK_PERIOD/2) clk_i = ~clk_i;
	
    task write
    ( 
		input string file
	);

    case (file)
        "512": begin
	        in_f = $fopen("in_512.txt", "r");	
            apriori_f = $fopen("apriori_512.txt", "r");
            blklen <= 512;
        end	
        "6144": begin
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

    initial begin
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
		extrinsic0 = $fopen("extrinsic.txt", "r");
		// LLR = $fopen("LLR.txt", "r");
		// sys_f = $fopen("sys.txt", "r");
    end

    
	// always_ff @(posedge clk_i) begin
	// if (valid_extrinsic) begin
	// 	counter_i <= counter_i + 1;
	// 	$fgets(line_ext,extrinsic0);
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
        write("512");
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
		//
		// .init_branch1_t (init_branch1),
		// .init_branch2_t (init_branch2),
		// .valid_out		(valid_out)
    );


endmodule
