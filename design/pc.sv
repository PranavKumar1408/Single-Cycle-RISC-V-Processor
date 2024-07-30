`timescale 1ns/1ns

module pc(
  input clk,
  input reset,
  input[31:0] pc_in,
  output reg[31:0] pc_out
);
  always@(posedge clk)
    begin
      if(reset)
        pc_out<=0;
      else
        pc_out<=pc_in;
    end
endmodule