`timescale 1ns / 1ps
// Cycle: GREEN_red >> YELLOW_red >> RED_green >> RED_yellow >> 
module cycle_basic(input clk,reset,walk,sensor, output reg [2:0]light_main,output reg[2:0]light_side, output reg light_walk);
parameter GREEN_red = 3'b000, YELLOW_red = 3'b001, RED_green = 3'b010, RED_yellow = 3'b011, RED_red = 3'b100;
parameter off = 3'b000, green = 3'b100, yellow = 3'b010, red = 3'b001;
reg [3:0] count; 
reg [3:0] tBASE;
reg [3:0] tEXT;
reg [3:0] tYEL;
reg [2:0] state;
reg [3:0]m_light;
reg [3:0]s_light;
wire new_clk;
wire sig1;
wire out;
clk_div clock(clk,rst,new_clk);
module_synchro sync( clk, sig, sig1);
debouncer bouncer(en, clk, out);
always @(posedge new_clk) begin
    count <= count + 1;
    if(reset) begin
        tBASE <= 4'd6;
        tEXT <= 4'd3;
        tYEL <= 4'd2;
        state <= RED_yellow;
        m_light <= 2*tBASE;
        s_light <= tBASE;
        light_main <= 3'b0;
        light_side <= 3'b0;
        count <= 4'b0;
    end
    
    if(sensor && GREEN_red && count == tBASE) begin
    m_light <= tBASE + tEXT;
    end
    if(sensor && RED_green && count == tBASE)begin
    s_light <= tBASE + tEXT;
    end
    
    case(state)
GREEN_red:  if(count == m_light) begin
                count <= 4'b0;
                state <= YELLOW_red;
                light_main <= yellow;
                light_side <= red;
            end
YELLOW_red:  if(count == tYEL) begin
if(!walk) begin
                count <= 4'b0;
                state <= RED_green;
                light_main <= red;
                light_side <= green;
            end
            else begin
             count <= 4'b0;
                           state <= RED_red;
                           light_walk <= 1'b1;
                           light_main <= red;
                           light_side <= red;
                           end
                           end
            
RED_green:  if(count == s_light) begin
                count <= 4'b0;
                state <= RED_yellow;
                light_main <= red;
                light_side <= yellow;
            end
RED_yellow:  if(count == tYEL) begin
                count <= 4'b0;
                state <= GREEN_red;
                light_main <= green;
                light_side <= red;
            end
RED_red: if(count == tEXT)begin
count <= 4'b0;
               state <= RED_green;
               light_main <= red;
               light_side <= green;
               light_walk <= 1'b0;
               end
    endcase


    end
endmodule
