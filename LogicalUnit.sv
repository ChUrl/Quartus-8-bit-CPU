`default_nettype none

// Inst: MD     OP
//       01 000 XXX
// OPs:         000 - AND
//              001 - OR
//              010 - NAND
//              011 - NOR
module LogicalUnit(
  input var logic[2:0] opcode,
  input var logic[7:0] operandA,
  input var logic[7:0] operandB,
  output var logic[7:0] result
);

  always @(opcode or operandA or operandB) case (opcode)
    3'b000: result = operandA & operandB;
    3'b001: result = operandA | operandB;
    3'b010: result = ~(operandA & operandB);
    3'b011: result = ~(operandA | operandB);
    default: result = 0;
  endcase
endmodule
