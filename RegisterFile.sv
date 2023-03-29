`default_nettype none

// Regs: 000 - reg0 (Constant load)
//       001 - reg1 (ALU operandA)
//       010 - reg2 (ALU operandB)
//       011 - reg3 (ALU result/conditional operand)
//       100 - reg4 (General purpose A)
//       101 - reg5 (General purpose B)
module RegisterFile(
  // Control inputs
  input var logic clock,
  input var logic reset,
  input var logic save,

  // Save/load
  input var logic[2:0] saveselector,
  input var logic[7:0] savebus,
  input var logic[2:0] loadselector,
  output var logic[7:0] loadbus,

  // Fixed outputs
  output var logic[7:0] jumptarget,
  output var logic[7:0] aluoperandA,
  output var logic[7:0] aluoperandB,
  output var logic[7:0] aluresult
);

  // Our data is stored in here
  var logic[7:0] registers[5:0];

  // Reset everything to 0 or save value
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      for (int ii = 0; ii < 6; ii = ii + 1) begin
        registers[ii] <= 8'b0;
      end
    end else if (save) begin
        registers[saveselector] <= savebus;
    end
  end

  // Load selected register value to loadbus
  assign loadbus = registers[loadselector];

  // Always propagate contents of ALU registers
  assign jumptarget = registers[0];
  assign aluoperandA = registers[1];
  assign aluoperandB = registers[2];
  assign aluresult = registers[3];
endmodule
