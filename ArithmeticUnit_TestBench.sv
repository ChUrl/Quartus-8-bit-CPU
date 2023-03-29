`default_nettype none

module ArithmeticUnit_TestBench;

var logic[2:0] opcode;
var logic signed[7:0] operandA;
var logic signed[7:0] operandB;
tri signed[7:0] result;

ArithmeticUnit au(
  .opcode(opcode),
  .operandA(operandA),
  .operandB(operandB),
  .result(result)
);

// synthesis translate_off
initial begin
    $timeformat(-9, 2, " ns", 20);
    
    $display("%0t Initial Reset", $time);
    opcode = 3'b000;
    operandA = 8'b00000000;
    operandB = 8'b00000000;
    #20 assert(result == 8'b00000000);

    // First set of operands
    operandA = 8'b00000000;
    operandB = 8'b01010101;

    $display("%0t ADD 1", $time);
    opcode = 3'b100;
    #20 assert(result == 8'b01010101);

    $display("%0t SUB 1", $time);
    opcode = 3'b101;
    #20 assert(result == 8'b10101011);

    // Second set of operands
    operandA = 8'b11111111;
    operandB = 8'b01010101;

    $display("%0t ADD 2", $time);
    opcode = 3'b100;
    #20 assert(result == 8'b01010100); // With carry, we don't have flags yet

    $display("%0t SUB 2", $time);
    opcode = 3'b101;
    #20 assert(result == 8'b10101010);

    // Third set of operands
    operandA = 8'b00001111;
    operandB = 8'b01010101;

    $display("%0t ADD 3", $time);
    opcode = 3'b100;
    #20 assert(result == 8'b01100100);

    $display("%0t SUB 3", $time);
    opcode = 3'b101;
    #20 assert(result == 8'b10111010);

    $display("Success!");
end
// synthesis translate_on

endmodule