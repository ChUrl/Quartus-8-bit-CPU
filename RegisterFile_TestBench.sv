`default_nettype none

module RegisterFile_TestBench;

var logic clock;
var logic reset;
var logic save;
var logic[2:0] saveselector;
var logic[7:0] savebus;
var logic[2:0] loadselector;

tri[7:0] loadbus;
tri[7:0] aluoperandA;
tri[7:0] aluoperandB;
tri[7:0] aluresult;

RegisterFile rf(
  .clock(clock),
  .reset(reset),
  .save(save),
  .saveselector(saveselector),
  .savebus(savebus),
  .loadselector(loadselector),
  .loadbus(loadbus),
  .aluoperandA(aluoperandA),
  .aluoperandB(aluoperandB),
  .aluresult(aluresult)
);

// synthesis translate_off
integer ii;
initial begin
    $timeformat(-9, 2, " ns", 20);

    $display("%0t Initial Reset", $time);
    clock = 1'b0;
    save = 1'b0;
    saveselector = 3'b000;
    savebus = 8'b00000000;
    loadselector = 3'b000;
    #20 reset = 1'b1;
    #20 reset = 1'b0;
    assert(aluoperandA == 8'b00000000);
    assert(aluoperandB == 8'b00000000);
    assert(aluresult == 8'b00000000);

    $display("%0t SAVE 000", $time);
    saveselector = 3'b000;
    savebus = 8'b00000001;
    loadselector = 3'b000;
    save = 1'b1;
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(loadbus == 8'b00000001);

    $display("%0t SAVE 001", $time);
    saveselector = 3'b001;
    savebus = 8'b00000010;
    loadselector = 3'b001;
    save = 1'b1;
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(loadbus == 8'b00000010);

    $display("%0t SAVE 010", $time);
    saveselector = 3'b010;
    savebus = 8'b00000011;
    loadselector = 3'b010;
    save = 1'b1;
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(loadbus == 8'b00000011);

    $display("%0t SAVE 011", $time);
    saveselector = 3'b011;
    savebus = 8'b00000100;
    loadselector = 3'b011;
    save = 1'b1;
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(loadbus == 8'b00000100);

    $display("%0t SAVE 100", $time);
    saveselector = 3'b100;
    savebus = 8'b00000101;
    loadselector = 3'b100;
    save = 1'b1;
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(loadbus == 8'b00000101);

    $display("%0t SAVE 101", $time);
    saveselector = 3'b101;
    savebus = 8'b00000110;
    loadselector = 3'b101;
    save = 1'b1;
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(loadbus == 8'b00000110);

    $display("%0t LOAD Previous", $time);
    for (ii = 0; ii < 6; ii = ii + 1) begin
      #20 loadselector = ii;
      #20 assert(loadbus == ii + 1);
    end

    $display("%0t LOAD Fixed", $time);
    assert(aluoperandA == 8'b00000010);
    assert(aluoperandB == 8'b00000011);
    assert(aluresult == 8'b00000100);

    $display("%0t SAVE 011", $time);
    saveselector = 3'b011;
    savebus = 8'b01010101;
    loadselector = 3'b011;
    save = 1'b1;
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(loadbus == 8'b01010101);
    assert(aluresult == 8'b01010101);

    $display("%0t RESET", $time);
    #20 reset = 1'b1;
    #20 reset = 1'b0;
    for (ii = 0; ii < 6; ii = ii + 1) begin
      #20 loadselector = ii;
      #20 assert(loadbus == 8'b00000000);
    end
    assert(aluoperandA == 8'b00000000);
    assert(aluoperandB == 8'b00000000);
    assert(aluresult == 8'b00000000);

    $display("Success!");
end
// synthesis translate_on

endmodule