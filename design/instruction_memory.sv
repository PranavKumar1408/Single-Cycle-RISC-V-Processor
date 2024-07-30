`timescale 1ns/1ns

module instruction_memory#(parameter noal=8)(//number of address lines
  input[noal-1:0] read_address,//256 memory locations
  output[31:0] instruction_out//each inst is 32 bits
);
  reg [7:0] inst_mem[(2**noal)-1:0];//each location is 1 byte wide
  
  initial
    begin
      {inst_mem[3],inst_mem[2],inst_mem[1],inst_mem[0]}=32'b000000000000_00000_011_00001_0000011;//lw x1,0(x0)-->x1=1
      {inst_mem[7],inst_mem[6],inst_mem[5],inst_mem[4]}=32'b0000000_00000_00001_000_00010_0110011;//add x2,x1,x0-->x2=1
      {inst_mem[11],inst_mem[10],inst_mem[9],inst_mem[8]}=32'b0000000_00010_00001_010_00011_0100011;//sw x2,3(x1)-->datamem[4]=1
    end
  assign instruction_out={inst_mem[read_address+3],inst_mem[read_address+2],inst_mem[read_address+1],inst_mem[read_address]};//little endian
endmodule
  