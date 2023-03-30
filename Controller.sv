`default_nettype none

module Controller(
  input var logic clock,
  input var logic reset,
  input var logic[7:0] databus,

  // Fixed outputs
  output var logic[1:0] opcode,
  output var logic[5:0] arg,
  output var logic[2:0] arg0,
  output var logic[2:0] arg1,
  
  // Outputs depending on opcode
  output var logic regs_set,
  output var logic[2:0] regs_savesel,
  output var logic[2:0] regs_loadsel,
  output var logic[2:0] alu_opc,
  output var logic[2:0] cond_opc,
  output var logic pc_set
);

  assign opcode = databus[7:6];
  assign arg = databus[5:0];
  assign arg0 = databus[2:0];
  assign arg1 = databus[5:3];

  always @(posedge clock or posedge reset) if (reset) begin
      regs_set = 1'b0;
      regs_savesel = 3'b000;
      regs_loadsel = 3'b000;
      alu_opc = 3'b000;
      cond_opc = 3'b000;
      pc_set = 1'b0;
  end else case (opcode)
    2'b00: begin
      // Load
      regs_set = 1'b1;
      regs_savesel = 3'b000; // Always save to reg0
      regs_loadsel = 3'b000;
      alu_opc = 3'b000;
      cond_opc = 3'b000;
      pc_set = 1'b0;
    end
    2'b01: begin
      // ALU
      regs_set = 1'b1;
      regs_savesel = 3'b011; // Always save to reg3
      regs_loadsel = 3'b000;
      alu_opc = arg0;
      cond_opc = 3'b000;
      pc_set = 1'b0;
    end
    2'b10: begin
      // Copy
      regs_set = 1'b1;
      regs_savesel = arg0;
      regs_loadsel = arg1;
      alu_opc = 3'b000;
      cond_opc = 3'b000;
      pc_set = 1'b0;
    end
    2'b11: begin
      // Cond
      regs_set = 1'b0;
      regs_savesel = 3'b000;
      regs_loadsel = 3'b000;
      alu_opc = 3'b000;
      cond_opc = arg0;
      pc_set = 1'b1;
    end
  endcase

endmodule