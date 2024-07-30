`include "instruction_memory.sv"
`include "register_file.sv"
`include "mux2_1.sv"
`include "immediate_generator.sv"
`include "alu.sv"
`include "alu_control.sv"
`include "data_memory.sv"
`include "pc.sv"
`include "control_unit.sv"
`include "adder.sv"

`timescale 1ns/1ns

module top(
  input clk,
  input reset
);
  wire[31:0] pc_out;
  //wire[31:0] pc2adder2;
  //wire[31:0] pc2instmem;
  wire[31:0] mux2pc;
  //wire[6:0]  instmem2controlunit;
  //wire[4:0]  instmem2read_reg_1;
  //wire[4:0]  instmem2read_reg_2;
  //wire[4:0]  instmem2write_reg;
  //wire[31:0] instmem2immgen;
  //wire[3:0]  instmem2alu_control;
  wire[31:0] instmemout;
  wire[31:0] mux2write_data_reg;
  wire[31:0] read_data_12alu;
  wire[31:0] read_data_2;
  wire[31:0] mux2alu;
  //wire[31:0] immgen2mux;
  //wire[31:0] immgen2adder;
  wire[31:0] immgenout;
  wire[31:0] read_data_datamem;
  //wire[31:0] read_data_22write_data_datamem;
  //wire[31:0] alu2addr_datamem;
  //wire[31:0] alu2mux;
  wire[31:0] aluresult;
  wire[31:0] adder2mux1;
  wire[31:0] adder2mux2;
  wire       branch;
  wire       memread;
  wire       memtoreg;
  wire[1:0]  aluop;
  wire[3:0]  alucontrolout;
  wire       memwrite;
  wire       alusrc;
  wire       regwrite;
  wire       zero;
  wire       and2mux;
  wire[31:0] constant_value_wire;
  
  assign constant_value_wire=32'd4;
  
  pc pc1(
    .clk(clk),
    .reset(reset),
    .pc_in(mux2pc), 
    .pc_out(pc_out));
  
  instruction_memory #(.noal(8))instmem1(
    .read_address(pc_out),
    .instruction_out(instmemout));
  
  register_file register_file1(
    .read_reg_1(instmemout[19:15]),
    .read_reg_2(instmemout[24:20]),
    .write_reg(instmemout[11:7]),
    .write_data(mux2write_data_reg),
    .reg_write(regwrite),
    .read_data_1(read_data_12alu),
    .read_data_2(read_data_2)
);
  
  immediate_generator immgen1(
    .inst(instmemout),
    .out(immgenout)
);
  
  alu alu1(
    .in1(read_data_12alu),
    .in2(mux2alu),
    .alu_control(alucontrolout),
    .out(aluresult),
    .zero(zero)
);
  
  alu_control alu_control1(
    .aluop(aluop),
    .func({instmemout[30],instmemout[14:12]}),
    .alu_control(alucontrolout)
);
  
  data_memory #(.noal(8))data_memory1(
    .memread(memread),
    .memwrite(memwrite),
    .address(aluresult),
    .write_data(read_data_2),
    .read_data(read_data_datamem)
);
  
  control_unit cu1(
    .inst_slice(instmemout[6:0]),
    .alusrc(alusrc),
    .memtoreg(memtoreg),
    .regwrite(regwrite),
    .memread(memread),
    .memwrite(memwrite),
    .branch(branch),
    .aluop(aluop)
);
  
  mux2_1 register_file2alu(
    .in1(read_data_2),
    .in2(immgenout),
    .s(alusrc),
    .out(mux2alu)
);
  
  mux2_1 datamem2register_file(
    .in1(aluresult),
    .in2(read_data_datamem),
    .s(memtoreg),
    .out(mux2write_data_reg)
);
  
  mux2_1 adder2pc(
    .in1(adder2mux1),
    .in2(adder2mux2),
    .s(and2mux),
    .out(mux2pc)
);
  
  and and1(and2mux,branch,zero);
  
  adder adder1(
    .in1(pc_out),
    .in2(constant_value_wire),
    .out(adder2mux1)
);
  
  adder adder2(
    .in1(pc_out),
    .in2(immgenout),
    .out(adder2mux2)
);
  
endmodule