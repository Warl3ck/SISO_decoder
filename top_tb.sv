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
    wire signed [15:0] extrinsic;
    bit valid_extrinsic;
    bit [15:0] counter_i;
	wire ready_i;
	wire signed [15:0] llr;
	wire valid_llr;

	integer extrinsic_512, LLR_512, extrinsic_6144, LLR_6144;
    integer extrinsic_out, llr_out;
	integer sys_f, llr_f, ext_out;
	integer in_f, apriori_f;
    integer clk_counter = 1;

	string line, line_llr, line_ext, line_sub_llr;

    event reset_complete, check_file_done;


	always #(CLK_PERIOD/2) clk_i = ~clk_i;
	
    task write  ( 
	            	input integer num
	            );

    case (num)
        512: begin
	        in_f = $fopen("in_512.txt", "r");	
            apriori_f = $fopen("apriori_512.txt", "r");
            blklen = 512;
        end	
        6144: begin
            in_f = $fopen("dec_in6144.txt", "r");	
            apriori_f = $fopen("dec_apriori6144.txt", "r");
            blklen = 6144;
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


	task check  ( 
	            	input integer check_file_extrinsic
	            );

	    case (check_file_extrinsic)
            extrinsic_512: begin
	        	ext_out = $fopen("extrinsic_512.txt", "r");
	    		llr_f = $fopen("LLR_512.txt", "r");
                extrinsic_out = $fopen("extrinsic_out_512.txt", "w");
                llr_out = $fopen("llr_out_512.txt", "w");
            end	
            extrinsic_6144: begin
 	    		ext_out = $fopen("extrinsic_6144.txt", "r");
	    		llr_f = $fopen("LLR_6144.txt", "r");
                extrinsic_out = $fopen("extrinsic_out_6144.txt", "w");
                llr_out = $fopen("llr_out_6144.txt", "w");
            end
        endcase

	    @(posedge valid_extrinsic)
	    counter_i = 0;
        $display("Number of tacts:", clk_counter);
	    while (valid_extrinsic) begin
	    	@(posedge clk_i) 
	    	if (valid_extrinsic) begin
	    		counter_i = counter_i + 1;
	    		$fgets(line_ext, ext_out);
	    		if (valid_llr) begin
	    			$fgets(line_llr, llr_f);
	    			$display(counter_i, line_ext.atoi(), $signed(extrinsic), line_llr.atoi(), $signed(llr));
                    $fdisplay(extrinsic_out, extrinsic);
                    $fdisplay(llr_out, llr);
        			if ((line_ext.atoi() !== $signed(extrinsic)) || (line_llr.atoi() !== $signed(llr))) begin
	    			    $display ("error");
                        $finish;
                    end
	    		end else begin
	    			$display(counter_i, line_ext.atoi(), $signed(extrinsic));
                    $fdisplay(extrinsic_out, extrinsic);
        			if ((line_ext.atoi() !== $signed(extrinsic))) begin
	    			    $display ("error");
                        $finish;
                    end
	    		end
	    	end
	    end
        -> check_file_done;
	endtask : check

    
    task check_clk_count    ( 
    	                    );
        @(posedge valid);
        forever begin
            @(posedge clk_i);
            clk_counter = clk_counter + 1;
            if (valid_extrinsic)
                break; 
        end
        clk_counter = 1;
    endtask : check_clk_count


	initial begin
        extrinsic_512 = $fopen("extrinsic_512.txt", "r");
		extrinsic_6144 = $fopen("extrinsic_6144.txt", "r");
	end

    always_ff @(posedge clk_i) begin
        valid_apriori_i <= valid_apriori;
    end
	
	initial begin
        valid_blklen <= 1'b0;
        blklen <= 0;
	 	rst <= 1'b1;
		#100ns; 
		@(posedge clk_i);
		rst <= 1'b0;
        -> reset_complete;
        check_clk_count;
        @(check_file_done);
        check_clk_count;
        // @(check_file_done);
        // check_clk_count;
        // @(check_file_done);
        // check_clk_count;
	end


    initial begin
        @(reset_complete);
        #20ns
        write(512);
		check(.check_file_extrinsic(extrinsic_512));
		//
		write(6144);
		check(.check_file_extrinsic(extrinsic_6144));
		// 
		// write(6144);
		// check(.check_file_extrinsic(extrinsic_6144));
		// //
        // write(512);
		// check(.check_file_extrinsic(extrinsic_512));
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
		.llr				(llr),
		.valid_llr			(valid_llr)
    );



endmodule
