`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2024 21:23:27
// Design Name: 
// Module Name: ram
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


module ram (clk, we, addr, di, dout);
input clk;
input we;
input [12:0] addr;
input [15:0] di;
output [15:0] dout;

(*rom_style = "block" *) reg [15:0] ram [6144 + 2:0];
reg [15:0] dout;

initial
begin
	for (int k = 0; k < 6144 + 3; k++) begin 
        ram[k] = 0;
    end
end


always @(posedge clk)
begin
if (we)
ram[addr] <= di;
dout <= ram[addr];
end

endmodule
