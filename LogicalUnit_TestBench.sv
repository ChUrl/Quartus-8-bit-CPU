`default_nettype none

module LogicalUnit_TestBench;

var logic[2:0] opcode;
var logic[7:0] operandA;
var logic[7:0] operandB;
tri[7:0] result;

LogicalUnit lu(
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

    $display("%0t AND 1", $time);
    opcode = 3'b000;
    #20 assert(result == 8'b00000000);

    $display("%0t OR 1", $time);
    opcode = 3'b001;
    #20 assert(result == 8'b01010101);

    $display("%0t NAND 1", $time);
    opcode = 3'b010;
    #20 assert(result == 8'b11111111);

    $display("%0t NOR 1", $time);
    opcode = 3'b011;
    #20 assert(result == 8'b10101010);

    // Second set of operands
    operandA = 8'b11111111;
    operandB = 8'b01010101;

    $display("%0t AND 2", $time);
    opcode = 3'b000;
    #20 assert(result == 8'b01010101);

    $display("%0t OR 2", $time);
    opcode = 3'b001;
    #20 assert(result == 8'b11111111);

    $display("%0t NAND 2", $time);
    opcode = 3'b010;
    #20 assert(result == 8'b10101010);

    $display("%0t NOR 2", $time);
    opcode = 3'b011;
    #20 assert(result == 8'b00000000);

    // Third set of operands
    operandA = 8'b00001111;
    operandB = 8'b01010101;

    $display("%0t AND 3", $time);
    opcode = 3'b000;
    #20 assert(result == 8'b00000101);

    $display("%0t OR 3", $time);
    opcode = 3'b001;
    #20 assert(result == 8'b01011111);

    $display("%0t NAND 3", $time);
    opcode = 3'b010;
    #20 assert(result == 8'b11111010);

    $display("%0t NOR 3", $time);
    opcode = 3'b011;
    #20 assert(result == 8'b10100000);

    $display("Success!");
end
// synthesis translate_on

endmodule