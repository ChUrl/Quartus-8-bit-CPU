`default_nettype none

module Counter(
  input var logic clock,
  input var logic reset,
  input var logic decrement,
  input var logic setvalue,
  input var logic[7:0] valuein,
  output var logic[7:0] valueout
);

  var logic[7:0] countervalue;

  always @(posedge clock or posedge reset)
    if (reset)
      countervalue <= 8'b0;
    else if (setvalue)
      countervalue <= valuein;
    else
      countervalue <= countervalue + (decrement ? -1 : 1);

  assign valueout = countervalue;
endmodule