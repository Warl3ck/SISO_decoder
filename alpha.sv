`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2024 16:45:41
// Design Name: 
// Module Name: alpha
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


module alpha 
(
    clk,
    rst,
    valid_branch,
    init_branch1,
    init_branch2,
    fsm_state,
    alpha_0,
    alpha_1,
    alpha_2,
    alpha_3,
    alpha_4,
    alpha_5,
    alpha_6,
    alpha_7,
    valid_alpha
);

    input clk;
    input rst;
    input [15:0] init_branch1;
    input [15:0] init_branch2;
    input valid_branch;
    input [1:0] fsm_state;
    output [15:0] alpha_0;
    output [15:0] alpha_1;
    output [15:0] alpha_2;
    output [15:0] alpha_3;
    output [15:0] alpha_4;
    output [15:0] alpha_5;
    output [15:0] alpha_6;
    output [15:0] alpha_7;
    output valid_alpha;

    reg [15:0] alpha_0_i [0:1];
    reg [15:0] alpha_1_i [0:1];
    reg [15:0] alpha_2_i [0:1];
    reg [15:0] alpha_3_i [0:1];
    reg [15:0] alpha_4_i [0:1];
    reg [15:0] alpha_5_i [0:1];
    reg [15:0] alpha_6_i [0:1];
    reg [15:0] alpha_7_i [0:1];


    always_ff @(posedge clk) begin
        if (rst || fsm_state == 2'b00) begin
            alpha_0_i [0:1] <= {0, 0};
            alpha_1_i [0:1] <= {-128, -128};
            alpha_2_i [0:1] <= {-128, -128};
            alpha_3_i [0:1] <= {-128, -128};
            alpha_4_i [0:1] <= {-128, -128};
            alpha_5_i [0:1] <= {-128, -128};
            alpha_6_i [0:1] <= {-128, -128};
            alpha_7_i [0:1] <= {-128, -128};
        end else if (valid_branch) begin
            alpha_0_i[0] <= ($signed(alpha_0_i[1] + init_branch1) > $signed(alpha_1_i[1] - init_branch1)) ? alpha_0_i[1] + init_branch1 : alpha_1_i[1] - init_branch1; 
            alpha_1_i[0] <= ($signed(alpha_2_i[1] - init_branch2) > $signed(alpha_3_i[1] + init_branch2)) ? alpha_2_i[1] - init_branch2 : alpha_3_i[1] + init_branch2; 
            alpha_2_i[0] <= ($signed(alpha_4_i[1] + init_branch2) > $signed(alpha_5_i[1] - init_branch2)) ? alpha_4_i[1] + init_branch2 : alpha_5_i[1] - init_branch2;
            alpha_3_i[0] <= ($signed(alpha_6_i[1] - init_branch1) > $signed(alpha_7_i[1] + init_branch1)) ? alpha_6_i[1] - init_branch1 : alpha_7_i[1] + init_branch1;
            alpha_4_i[0] <= ($signed(alpha_0_i[1] - init_branch1) > $signed(alpha_1_i[1] + init_branch1)) ? alpha_0_i[1] - init_branch1 : alpha_1_i[1] + init_branch1;
            alpha_5_i[0] <= ($signed(alpha_2_i[1] + init_branch2) > $signed(alpha_3_i[1] - init_branch2)) ? alpha_2_i[1] + init_branch2 : alpha_3_i[1] - init_branch2;
            alpha_6_i[0] <= ($signed(alpha_4_i[1] - init_branch2) > $signed(alpha_5_i[1] + init_branch2)) ? alpha_4_i[1] - init_branch2 : alpha_5_i[1] + init_branch2;
            alpha_7_i[0] <= ($signed(alpha_6_i[1] + init_branch1) > $signed(alpha_7_i[1] - init_branch1)) ? alpha_6_i[1] + init_branch1 : alpha_7_i[1] - init_branch1;
        end else begin
            alpha_0_i[1] <= alpha_0_i[0];
            alpha_1_i[1] <= alpha_1_i[0];
            alpha_2_i[1] <= alpha_2_i[0];
            alpha_3_i[1] <= alpha_3_i[0];
            alpha_4_i[1] <= alpha_4_i[0];
            alpha_5_i[1] <= alpha_5_i[0];
            alpha_6_i[1] <= alpha_6_i[0];
            alpha_7_i[1] <= alpha_7_i[0];
        end
    end

    assign alpha_0 = $signed(alpha_0_i[1] - alpha_0_i[0]);
    assign alpha_1 = $signed(alpha_1_i[1] - alpha_0_i[0]);
    assign alpha_2 = $signed(alpha_2_i[1] - alpha_0_i[0]);
    assign alpha_3 = $signed(alpha_3_i[1] - alpha_0_i[0]);
    assign alpha_4 = $signed(alpha_4_i[1] - alpha_0_i[0]);
    assign alpha_5 = $signed(alpha_5_i[1] - alpha_0_i[0]);
    assign alpha_6 = $signed(alpha_6_i[1] - alpha_0_i[0]);
    assign alpha_7 = $signed(alpha_7_i[1] - alpha_0_i[0]);
    assign valid_alpha = valid_branch;


endmodule
