`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2024 16:42:12
// Design Name: 
// Module Name: init_branch
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


module init_branch 
(
    clk,
    rst,
    valid_sys_parity,
    valid_apriori,
    apriori,
    sys,
    parity,
    init_branch1,
    init_branch2,
    valid_branch
);

    input clk;
    input rst;
    input valid_sys_parity;
    input valid_apriori;
    input [15:0] apriori;
    input [15:0] sys;
    input [15:0] parity;
    output [15:0] init_branch1;
    output [15:0] init_branch2;
    output valid_branch;



    reg [15:0] sum_branch1, sub_branch2;
    reg [15:0] sum_branch1_round, sub_branch2_round;
    reg [15:0] div_branch1, div_branch2, div_branch1_i, div_branch2_i;
    reg [15:0] init_branch1_i, init_branch2_i;
    reg valid_i, valid_i_delay;

    always_ff @(posedge clk) begin
        if (rst) begin
            sum_branch1 <= {16{1'b0}};
            sub_branch2 <= {16{1'b0}};
        end else if (valid_sys_parity & valid_apriori) begin
            sum_branch1 <= apriori + sys + parity;
            sub_branch2 <= apriori + sys - parity;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) 
            valid_i <= 1'b0;
        else 
            valid_i <= valid_sys_parity & valid_apriori;
    end

    // round
    assign sum_branch1_round = (sum_branch1[0] & sum_branch1[15]) ? sum_branch1 + 16'hFFFF : (sum_branch1[0] & !sum_branch1[15])  ? sum_branch1 + 1'b1 : sum_branch1;
    assign sub_branch2_round = (sub_branch2[0] & sub_branch2[15]) ? sub_branch2 + 16'hFFFF : (sub_branch2[0] & !sub_branch2[15])  ? sub_branch2 + 1'b1 : sub_branch2;

    // divider
    assign div_branch1 = sum_branch1_round >> 1 ;
    assign div_branch2 = sub_branch2_round >> 1;

    assign div_branch1_i = {div_branch1[14], div_branch1[14:0]};
    assign div_branch2_i = {div_branch2[14], div_branch2[14:0]};

    // divider round
    always_ff @(posedge clk) begin
        if (rst) begin
            init_branch1_i <= {16{1'b0}};
            init_branch2_i <= {16{1'b0}};
            valid_i_delay <= 1'b0;
        end else begin
            init_branch1_i <= (div_branch1_i[0] & div_branch1_i[15]) ? ~(div_branch1_i + 16'hFFFF) : ~div_branch1_i + 1'b1;
            init_branch2_i <= (div_branch2_i[0] & div_branch2_i[15]) ? ~(div_branch2_i + 16'hFFFF) : ~div_branch2_i + 1'b1;
            valid_i_delay <= valid_i;
        end
    end

    assign init_branch1 = init_branch1_i;
    assign init_branch2 = init_branch2_i;
    assign valid_branch = valid_i_delay;


endmodule
