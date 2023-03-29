`default_nettype none

// Inst: MD     OP
//       11 000 XXX
// OPs:         000 - Never
//              001 - == 0
//              010 - <  0
//              011 - <= 0
//              100 - Always
//              101 - != 0
//              110 - >  0
//              111 - >= 0
module ConditionalUnit(
  input var logic clock,
  input var logic[2:0] opcode,
  input var logic signed[7:0] operand,
  output var logic result
);

  // This could be simplified significantly (basically removed), if I had ALU flags.
  always @(posedge clock) case (opcode)
    3'b000: result = 0;
    3'b001: result = (operand == 0);
    3'b010: result = (operand < 0);
    3'b011: result = (operand <= 0);
    3'b100: result = 1;
    3'b101: result = (operand != 0);
    3'b110: result = (operand > 0);
    3'b111: result = (operand >= 0);
    default: result = 0;
  endcase
endmodule
