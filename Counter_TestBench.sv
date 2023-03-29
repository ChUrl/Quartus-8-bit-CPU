`default_nettype none

module Counter_TestBench;

  var logic clock;
  var logic reset;
  var logic decrement;
  var logic setvalue;
  var logic[7:0] valuein;

  tri[7:0] valueout;

  Counter cnt(
    .clock(clock),
    .reset(reset),
    .decrement(decrement),
    .setvalue(setvalue),
    .valuein(valuein),
    .valueout(valueout)
  );

// synthesis translate_off
  integer ii;
  initial begin
    $timeformat(-9, 2, " ns", 20);
    
    $display("%0t Initial Reset", $time);
    #20 reset = 1'b1;
    #20 reset = 1'b0;
    assert (valueout == 1'b0);
    
    $display("%0t Increment 1024x", $time);
    decrement = 1'b0;
    for (ii = 0; ii < 1024; ii = ii + 1) begin
      #20 clock = 1'b1;
      #20 clock = 1'b0;
      assert (valueout == 8'(ii + 1));
    end
    
    $display("%0t Decrement 1024x", $time);
    decrement = 1'b1;
    for (ii = 1024; ii > 0; ii = ii - 1) begin
      #20 clock = 1'b1;
      #20 clock = 1'b0;
      assert (valueout == 8'(ii - 1));
    end
    
    $display("%0t Setvalue", $time);
    decrement = 1'b0;
    setvalue = 1'b1;
    valuein = 8'b00001111;
    #20 clock = 1'b1;
    #20 clock = 1'b0;
    assert (valueout == 8'b00001111);
    
    $display("%0t Reset", $time);
    #20 reset = 1'b1;
    #20 reset = 1'b0;
    assert (valueout == 8'b0);
    
    $display("Success!");
  end
  
// synthesis translate_on
endmodule