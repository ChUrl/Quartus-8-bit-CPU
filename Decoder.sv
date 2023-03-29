`default_nettype none

module Decoder(
  input var logic clock,
  input var logic reset,
  output var logic fetch,
  output var logic decode,
  output var logic execute,
  output var logic writeback
);

  var logic was_reset;
  var logic setvalue;
  var logic[1:0] reset_val;

  var logic[1:0] mode;
  Counter #(.WIDTH(2)) mode_cnt(
    .clock(clock),
    .reset(0),
    .decrement(0),
    .setvalue(setvalue),
    .valuein(reset_val),
    .valueout(mode)
  );

  always @(posedge clock or posedge reset) if (reset) begin
    // Set each output to 0 by setting was_reset.
    was_reset = 1'b1;

    // Also we already prepare the counter reset for the next clock, as the clock already
    // happened when this is "executed".
    setvalue = 1'b1;
    reset_val = 2'b00;
  end else if (was_reset == 1'b1) begin
    // The counter uses the same clock as this, so the reset is performed "now".
    // We can now "reset the reset" and continue counting regularly.
    was_reset = 1'b0;
    setvalue = 1'b0;
    reset_val = 2'b00;
  end

  assign fetch = ~was_reset && (mode == 2'b00);
  assign decode = ~was_reset && (mode == 2'b01);
  assign execute = ~was_reset && (mode == 2'b10);
  assign writeback = ~was_reset && (mode == 2'b11);

endmodule