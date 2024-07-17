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
        .alpha_0            (alpha_0),
        .alpha_1            (alpha_1),
        .alpha_2            (alpha_2),
        .alpha_3            (alpha_3),
        .alpha_4            (alpha_4),
        .alpha_5            (alpha_5),
        .alpha_6            (alpha_6),
        .alpha_7            (alpha_7),
        .valid_alpha        ()
    );



    module beta
    (
        clk,
        rst,
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
        beta_7
    );

    input clk;
    input rst;
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


    //     beta(1,k)=max((beta(1,k+1)+init_branch1(k)),(beta(5,k+1)-init_branch1(k))) ;
    //     beta(2,k)=max((beta(5,k+1)+init_branch1(k)),(beta(1,k+1)-init_branch1(k))) ;
    //     beta(3,k)=max((beta(6,k+1)+init_branch2(k)),(beta(2,k+1)-init_branch2(k))) ;
    //     beta(4,k)=max((beta(2,k+1)+init_branch2(k)),(beta(6,k+1)-init_branch2(k))) ;
    //     beta(5,k)=max((beta(3,k+1)+init_branch2(k)),(beta(7,k+1)-init_branch2(k))) ;
    //     beta(6,k)=max((beta(7,k+1)+init_branch2(k)),(beta(3,k+1)-init_branch2(k))) ;
    //     beta(7,k)=max((beta(8,k+1)+init_branch1(k)),(beta(4,k+1)-init_branch1(k))) ;
    //     beta(8,k)=max((beta(4,k+1)+init_branch1(k)),(beta(8,k+1)-init_branch1(k))) ;

    reg [15:0] counter = 0;
    reg [15:0] beta_0_i [0:1] = {0, 0};
    reg [15:0] beta_1_i [0:1] = {-128, -128};
    reg [15:0] beta_2_i [0:1] = {-128, -128};
    reg [15:0] beta_3_i [0:1] = {-128, -128};
    reg [15:0] beta_4_i [0:1] = {-128, -128};
    reg [15:0] beta_5_i [0:1] = {-128, -128};
    reg [15:0] beta_6_i [0:1] = {-128, -128};
    reg [15:0] beta_7_i [0:1] = {-128, -128};

    always_ff @(posedge clk) begin
       if (valid_branch) begin
           beta_0_i[0] <= ($signed(beta_0_i[1] + init_branch1) > $signed(beta_4_i[1] - init_branch1)) ? beta_0_i[1] + init_branch1 : beta_4_i[1] - init_branch1; 
           beta_1_i[0] <= ($signed(beta_4_i[1] + init_branch1) > $signed(beta_0_i[1] - init_branch1)) ? beta_4_i[1] + init_branch1 : beta_0_i[1] - init_branch1; 
           beta_2_i[0] <= ($signed(beta_5_i[1] + init_branch2) > $signed(beta_1_i[1] - init_branch2)) ? beta_5_i[1] + init_branch2 : beta_1_i[1] - init_branch2;
           beta_3_i[0] <= ($signed(beta_1_i[1] + init_branch2) > $signed(beta_5_i[1] - init_branch2)) ? beta_1_i[1] + init_branch2 : beta_5_i[1] - init_branch2;
           beta_4_i[0] <= ($signed(beta_2_i[1] + init_branch2) > $signed(beta_6_i[1] - init_branch2)) ? beta_2_i[1] + init_branch2 : beta_6_i[1] - init_branch2;
           beta_5_i[0] <= ($signed(beta_6_i[1] + init_branch2) > $signed(beta_2_i[1] - init_branch2)) ? beta_6_i[1] + init_branch2 : beta_2_i[1] - init_branch2;
           beta_6_i[0] <= ($signed(beta_7_i[1] + init_branch1) > $signed(beta_3_i[1] - init_branch1)) ? beta_7_i[1] + init_branch1 : beta_3_i[1] - init_branch1;
           beta_7_i[0] <= ($signed(beta_3_i[1] + init_branch1) > $signed(beta_7_i[1] - init_branch1)) ? beta_3_i[1] + init_branch1 : beta_7_i[1] - init_branch1;
       end else begin
           beta_0_i[1] <= beta_0_i[0];
           beta_1_i[1] <= beta_1_i[0];
           beta_2_i[1] <= beta_2_i[0];
           beta_3_i[1] <= beta_3_i[0];
           beta_4_i[1] <= beta_4_i[0];
           beta_5_i[1] <= beta_5_i[0];
           beta_6_i[1] <= beta_6_i[0];
           beta_7_i[1] <= beta_7_i[0];
       end
    end

    assign beta_0 = $signed(beta_0_i[1] - beta_0_i[0]);
    assign beta_1 = $signed(beta_1_i[1] - beta_0_i[0]);
    assign beta_2 = $signed(beta_2_i[1] - beta_0_i[0]);
    assign beta_3 = $signed(beta_3_i[1] - beta_0_i[0]);
    assign beta_4 = $signed(beta_4_i[1] - beta_0_i[0]);
    assign beta_5 = $signed(beta_5_i[1] - beta_0_i[0]);
    assign beta_6 = $signed(beta_6_i[1] - beta_0_i[0]);
    assign beta_7 = $signed(beta_7_i[1] - beta_0_i[0]);


    endmodule


    beta beta_inst 
    (
        .clk            (clk),
        .rst            (rst),
        .valid_branch   (valid_branch_i),
        .init_branch1   (init_branch1),
        .init_branch2   (init_branch2)
    );



	assign init_branch1_t = init_branch1;
	assign init_branch2_t = init_branch2;
    assign valid_out = valid_branch_i;


endmodule
