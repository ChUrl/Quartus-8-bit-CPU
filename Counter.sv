`default_nettype none

module Counter
  #(parameter WIDTH = 8)(
  input var logic clock,
  input var logic reset,
  input var logic decrement,
  input var logic setvalue,
  input var logic[WIDTH-1:0] valuein,
  output var logic[WIDTH-1:0] valueout
);

  var logic[WIDTH-1:0] countervalue;

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      countervalue = WIDTH'(0);
    end else if (setvalue) begin
      countervalue = valuein;
    end else begin
      countervalue = countervalue + (decrement ? -1 : 1);
    end
  end

  assign valueout = countervalue;
endmodule