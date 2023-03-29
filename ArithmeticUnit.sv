`default_nettype none

// Inst: MD     OP
//       01 000 XXX
// OPs:         100 - ADD
//              101 - SUB
module ArithmeticUnit(
  input var logic[2:0] opcode,
  input var logic[7:0] operandA,
  input var logic[7:0] operandB,
  output var logic[7:0] result
);

  // If the least significant opcode bit is 0, it is an addition
  always @(opcode or operandA or operandB) case (opcode)
    3'b100: result = operandA + operandB;
    3'b101: result = operandA - operandB;
    default: result = 0;
  endcase
endmodule
