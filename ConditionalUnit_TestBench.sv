`default_nettype none

module ConditionalUnit_TestBench;

var logic[2:0] opcode;
var logic signed[7:0] operand;
tri result;

ConditionalUnit cu(
  .opcode(opcode),
  .operand(operand),
  .result(result)
);

// synthesis translate_off
initial begin
    $timeformat(-9, 2, " ns", 20);

    $display("%0t Initial Reset", $time);
    opcode = 3'b000;
    operand = 8'b00000000;
    #20 assert(result == 1'b0);

    // First set of operands
    operand = 8'b00000000;

    $display("%0t NEVER 1", $time);
    opcode = 3'b000;
    #20 assert(result == 1'b0);

    $display("%0t EQUAL 1", $time);
    opcode = 3'b001;
    #20 assert(result == 1'b1);

    $display("%0t LESS 1", $time);
    opcode = 3'b010;
    #20 assert(result == 1'b0);

    $display("%0t LESSEQUAL 1", $time);
    opcode = 3'b011;
    #20 assert(result == 1'b1);

    $display("%0t ALWAYS 1", $time);
    opcode = 3'b100;
    #20 assert(result == 1'b1);

    $display("%0t NOTEQUAL 1", $time);
    opcode = 3'b101;
    #20 assert(result == 1'b0);

    $display("%0t GREATER 1", $time);
    opcode = 3'b110;
    #20 assert(result == 1'b0);

    $display("%0t GREATEREQUAL 1", $time);
    opcode = 3'b111;
    #20 assert(result == 1'b1);

    // Second set of operands
    operand = 8'b11111111;

    $display("%0t NEVER 2", $time);
    opcode = 3'b000;
    #20 assert(result == 1'b0);

    $display("%0t EQUAL 2", $time);
    opcode = 3'b001;
    #20 assert(result == 1'b0);

    $display("%0t LESS 2", $time);
    opcode = 3'b010;
    #20 assert(result == 1'b1);

    $display("%0t LESSEQUAL 2", $time);
    opcode = 3'b011;
    #20 assert(result == 1'b1);

    $display("%0t ALWAYS 2", $time);
    opcode = 3'b100;
    #20 assert(result == 1'b1);

    $display("%0t NOTEQUAL 2", $time);
    opcode = 3'b101;
    #20 assert(result == 1'b1);

    $display("%0t GREATER 2", $time);
    opcode = 3'b110;
    #20 assert(result == 1'b0);

    $display("%0t GREATEREQUAL 2", $time);
    opcode = 3'b111;
    #20 assert(result == 1'b0);

    // Third set of operands
    operand = 8'b00001111;

    $display("%0t NEVER 3", $time);
    opcode = 3'b000;
    #20 assert(result == 1'b0);

    $display("%0t EQUAL 3", $time);
    opcode = 3'b001;
    #20 assert(result == 1'b0);

    $display("%0t LESS 3", $time);
    opcode = 3'b010;
    #20 assert(result == 1'b0);

    $display("%0t LESSEQUAL 3", $time);
    opcode = 3'b011;
    #20 assert(result == 1'b0);

    $display("%0t ALWAYS 3", $time);
    opcode = 3'b100;
    #20 assert(result == 1'b1);

    $display("%0t NOTEQUAL 3", $time);
    opcode = 3'b101;
    #20 assert(result == 1'b1);

    $display("%0t GREATER 3", $time);
    opcode = 3'b110;
    #20 assert(result == 1'b1);

    $display("%0t GREATEREQUAL 3", $time);
    opcode = 3'b111;
    #20 assert(result == 1'b1);

    $display("Success!");
end
// synthesis translate_on

endmodule