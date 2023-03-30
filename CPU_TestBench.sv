`default_nettype none

module CPU_TestBench;

  var logic enable, clock, reset;
  var logic[7:0] cpuin;
  tri[7:0] cpuout;

  // Debug connections
  tri ftch, decd, exec, wrtb;
  tri[7:0] pc, rom, saveb, loadb, jmpt, aluA, aluB, aluR;
  
  CPU cpu(
    .enable(enable),
    .clock(clock),
    .reset(reset),
    .cpuin(cpuin),
    .cpuout(cpuout),

    .dbg_fetch(ftch),
    .dbg_decode(decd),
    .dbg_execute(exec),
    .dbg_writeback(wrtb),
    .dbg_pcout(pc),
    .dbg_romout(rom),
    .dbg_savebus(saveb),
    .dbg_loadbus(loadb),
    .dbg_jumptarget(jmpt),
    .dbg_aluopA(aluA),
    .dbg_aluopB(aluB),
    .dbg_aluresult(aluR)
  );

  // TODO: Move the disabled stuff to a separate testbench
  // TODO: Move this to a ROM specific testbench, allow creating other ROM specific testbenches
  // NOTE: This testbench is written for the Input/Output ROM
  
// synthesis translate_off
  integer ii;
  initial begin
    $timeformat(-9, 2, " ns", 20);

    $display("%0t Initial Reset", $time);
    enable = 1'b0;
    clock = 1'b0;
    #20 reset = 1'b1;
    #20 reset = 1'b0;
    assert(cpuout == 8'b0);

    // $display("%0t Disabled CPU with Clock", $time);
    // for (ii = 0; ii < 4; ii = ii + 1) begin
    //   #20 clock = 1'b1;
    //   #20 clock = 1'b0;
    //   assert(ftch == 1'b0);
    //   assert(decd == 1'b0);
    //   assert(exec == 1'b0);
    //   assert(wrtb == 1'b0);
    // end

    $display("%0t Enable CPU", $time);
    #20 enable = 1'b1;
    #20 cpuin = 8'b00000101;

    // $display("%0t Clock => Fetch 1", $time);
    // #20 clock = 1'b1;
    // #20 clock = 1'b0;
    // assert(ftch == 1'b1);
    // assert(decd == 1'b0);
    // assert(exec == 1'b0);
    // assert(wrtb == 1'b0);

    // $display("%0t Clock => Decode 1", $time);
    // #20 clock = 1'b1;
    // #20 clock = 1'b0;
    // assert(ftch == 1'b0);
    // assert(decd == 1'b1);
    // assert(exec == 1'b0);
    // assert(wrtb == 1'b0);

    // $display("%0t Clock => Execute 1", $time);
    // #20 clock = 1'b1;
    // #20 clock = 1'b0;
    // assert(ftch == 1'b0);
    // assert(decd == 1'b0);
    // assert(exec == 1'b1);
    // assert(wrtb == 1'b0);

    // $display("%0t Clock => Writeback 1", $time);
    // #20 clock = 1'b1;
    // #20 clock = 1'b0;
    // assert(ftch == 1'b0);
    // assert(decd == 1'b0);
    // assert(exec == 1'b0);
    // assert(wrtb == 1'b1);

    // Next CPU cycle (reg1 = cpuin)
    $display("%0t reg1 (aluA) = cpuin", $time);
    for (ii = 0; ii < 4; ii = ii + 1) begin
      #20 clock = 1'b1;
      #20 clock = 1'b0;
    end
    assert(aluA == 8'b00000101);

    // Next CPU cycle (reg0 = 10)
    $display("%0t reg0 (jmpt) = 00001010", $time);
    for (ii = 0; ii < 4; ii = ii + 1) begin
      #20 clock = 1'b1;
      #20 clock = 1'b0;
    end
    assert(jmpt == 8'b00001010);
    assert(aluA == 8'b00000101);

    // Next CPU cycle (reg2 = reg0)
    $display("%0t reg2 (aluB) = reg0 (jmpt)", $time);
    for (ii = 0; ii < 4; ii = ii + 1) begin
      #20 clock = 1'b1;
      #20 clock = 1'b0;
    end
    assert(jmpt == 8'b00001010);
    assert(aluA == 8'b00000101);
    assert(aluB == 8'b00001010);

    // Next CPU cycle (reg3 = reg1 + reg2)
    $display("%0t reg3 (aluR) = reg1 (aluA) + reg2 (aluB)", $time);
    for (ii = 0; ii < 4; ii = ii + 1) begin
      #20 clock = 1'b1;
      #20 clock = 1'b0;
    end
    assert(jmpt == 8'b00001010);
    assert(aluA == 8'b00000101);
    assert(aluB == 8'b00001010);
    assert(aluR == 8'b00001111);

    // Next CPU cycle (cpuout = reg3)
    $display("%0t cpuout = reg3 (aluR)", $time);
    for (ii = 0; ii < 4; ii = ii + 1) begin
      #20 clock = 1'b1;
      #20 clock = 1'b0;
    end
    assert(jmpt == 8'b00001010);
    assert(aluA == 8'b00000101);
    assert(aluB == 8'b00001010);
    assert(aluR == 8'b00001111);
    assert(cpuout == 8'b00001111);

    $display("Success!");
  end
// synthesis translate_on

endmodule