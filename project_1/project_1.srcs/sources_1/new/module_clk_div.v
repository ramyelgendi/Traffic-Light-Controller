`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 03:19:18 PM
// Design Name: 
// Module Name: clockdivider
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

module clk_div #(parameter n = 50000000)(input clk, input rst, output reg clk_out);
    reg [31:0] count;
    
    always @ (posedge(clk), posedge(rst)) begin
        if (rst == 1)
            count <= 0;
        else if (count == n-1)
            count <= 0;
        else
        count <= count + 1;
    end
    
    always @ (posedge(clk), posedge(rst)) begin
        if (rst == 1)
            clk_out <= 0;
        else if (count == n -1)
            clk_out <= ~clk_out;
        else
            clk_out <= clk_out;
    end
endmodule