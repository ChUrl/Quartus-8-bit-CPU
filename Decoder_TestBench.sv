`default_nettype none

module Decoder_TestBench;

  var logic clock, reset;
  tri fetch, decode, execute, writeback;
  
  Decoder dec(
    .clock(clock),
    .reset(reset),
    .fetch(fetch),
    .decode(decode),
    .execute(execute),
    .writeback(writeback)
  );


// synthesis translate_off
  initial begin
    $timeformat(-9, 2, " ns", 20);

    $display("%0t Initial Reset", $time);
    clock = 1'b0;
    #20 reset = 1'b1;
    #20 reset = 1'b0;
    assert(fetch == 1'b0);
    assert(decode == 1'b0);
    assert(execute == 1'b0);
    assert(writeback == 1'b0);

    $display("%0t Fetch", $time);
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(fetch == 1'b1);
    assert(decode == 1'b0);
    assert(execute == 1'b0);
    assert(writeback == 1'b0);

    $display("%0t Decode", $time);
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(fetch == 1'b0);
    assert(decode == 1'b1);
    assert(execute == 1'b0);
    assert(writeback == 1'b0);

    $display("%0t Execute", $time);
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(fetch == 1'b0);
    assert(decode == 1'b0);
    assert(execute == 1'b1);
    assert(writeback == 1'b0);

    $display("%0t Writeback", $time);
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(fetch == 1'b0);
    assert(decode == 1'b0);
    assert(execute == 1'b0);
    assert(writeback == 1'b1);

    $display("%0t Fetch", $time);
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert(fetch == 1'b1);
    assert(decode == 1'b0);
    assert(execute == 1'b0);
    assert(writeback == 1'b0);

    $display("%0t Reset", $time);
    clock = 1'b0;
    #20 reset = 1'b1;
    #20 reset = 1'b0;
    assert(fetch == 1'b0);
    assert(decode == 1'b0);
    assert(execute == 1'b0);
    assert(writeback == 1'b0);

    $display("Success!");
  end
// synthesis translate_on

endmodule