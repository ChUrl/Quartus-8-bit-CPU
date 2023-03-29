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
  input var logic signed[7:0] operandA,
  input var logic signed[7:0] operandB,
  output var logic signed[7:0] result
);

  // This is a var logic, because I only want a single driver.
  // It should be synthesized to a wire, as nothing is stored (hopefully?).
  var logic signed[7:0] lu_result;
  LogicalUnit lu(
    .opcode(opcode),
    .operandA(operandA),
    .operandB(operandB),
    .result(lu_result)
  );

  var logic signed[7:0] au_result;
  ArithmeticUnit au(
    .opcode(opcode),
    .operandA(operandA),
    .operandB(operandB),
    .result(au_result)
  );

  // Originally, I used the same sensitivity list as with the LogicalUnit/ArithmeticUnit:
  // "always @(opcode or operandA or operandB)"
  // This didn't work though, the result didn't update correctly.
  // TODO: Figure out why
  always @(lu_result or au_result) case (opcode)
    3'b000,
    3'b001,
    3'b010,
    3'b011: result = lu_result;
    3'b100,
    3'b101: result = au_result;
    default: result = 0;
  endcase
endmodule
