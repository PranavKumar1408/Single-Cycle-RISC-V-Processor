`timescale 1ns/1ns

module register_file(
  input[4:0] read_reg_1,
  input[4:0] read_reg_2,
  input[4:0] write_reg,
  input[31:0] write_data,
  input reg_write,
  output[31:0] read_data_1,
  output[31:0] read_data_2
);
  reg[4:0] registers[31:0];
  initial
    registers[0]='0;//x0=0
  assign read_data_1=registers[read_reg_1];
  assign read_data_2=registers[read_reg_2];
  
  always@(*)
    begin
      if(reg_write)
        registers[write_reg]=write_data;
    end
  initial begin
    $display($time, " x0='h%0h", registers[0]);
    $monitor($time, " x1='h%0h,x2='h%0h", registers[1],registers[2]);
end
endmodule