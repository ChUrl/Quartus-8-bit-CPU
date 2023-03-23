`default_nettype none

// Inst: MD     OP
//       01 000 XXX
// OPs:         000 - AND
//              001 - OR
//              010 - NAND
//              011 - NOR
//              100 - ADD
//              101 - SUB
module ALU(
  input var logic[2:0] opcode,
  input var logic[7:0] operandA,
  input var logic[7:0] operandB,
  output var logic[7:0] result
);

  var logic[7:0] lu_result;
  LogicalUnit lu(
    .opcode(opcode),
    .operandA(operandA),
    .operandB(operandB),
    .result(lu_result)
  );

  var logic[7:0] au_result;
  ArithmeticUnit au(
    .opcode(opcode),
    .operandA(operandA),
    .operandB(operandB),
    .result(au_result)
  );

  // If the first most significant opcode bit is 0, it is a logical operation.
  always_comb case (opcode)
    3'b000,
    3'b001,
    3'b010,
    3'b011: result = lu_result;
    3'b100,
    3'b101: result = au_result;
    default: result = 0;
  endcase
endmodule
