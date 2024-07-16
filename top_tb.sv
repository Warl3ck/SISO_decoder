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


	integer init_branch1i, init_branch2i;
	bit [15:0] init_branch1, init_branch2;
	bit valid_out;

    integer in_512, apriori_512;
    string line;

    event reset_complete;

	always #(CLK_PERIOD/2) clk_i = ~clk_i;
	
    // always_ff @(posedge clk_i)
    // begin
    //     if (valid)
    //         in <= in + 1;
    // end
	

	initial begin
	 	rst <= 1'b1;
		#100ns; 
		@(posedge clk_i);
		rst <= 1'b0;
        -> reset_complete;
	end


    initial begin
        in_512 = $fopen("in_512.txt", "r");	
        apriori_512 = $fopen("apriori_512.txt", "r");	
        @(reset_complete);
        #20ns
        while (!$feof(in_512)) begin
            @(posedge clk_i);
            valid <= 1'b1;
            $fgets(line,in_512);
            in <= line.atoi();
            // if (valid)
                valid_apriori <= (!valid_apriori) ? 1'b1 : 1'b0; 
                if (valid_apriori) begin
                    $fgets(line,apriori_512);
                    apriori <= line.atoi();
                end
        end
    end

    always_ff @(posedge clk_i) begin
        valid_apriori_i <= valid_apriori;
    end


    top top_inst
    (
        .clk            (clk_i),
        .rst            (rst),
        .in             (in),
        .valid_in       (valid),
        .valid_apriori  (valid_apriori_i),
        .apriori        (apriori),
        .blklen         (),
		//
		.init_branch1_t (init_branch1),
		.init_branch2_t (init_branch2),
		.valid_out		(valid_out)
    );

	initial begin
		init_branch1i = $fopen("init_branch1.txt", "w");
		init_branch2i = $fopen("init_branch2.txt", "w");
	end


	always_comb begin
		if (valid_out) begin
			$fdisplay(init_branch1i, $signed(init_branch1));
			$fdisplay(init_branch2i, $signed(init_branch2));
		end
	end


endmodule
