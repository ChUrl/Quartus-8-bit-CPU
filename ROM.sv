`default_nettype none

module ROM(
  input var logic[7:0] address,
  output var logic[7:0] dataout
);

  // Add and jump
  always @(address) case (address)
    8'b00000000: dataout = 8'b00000101; // reg0 = 5
    8'b00000001: dataout = 8'b10000001; // Move reg0 to reg1
    8'b00000010: dataout = 8'b00001010; // reg0 = 10
    8'b00000011: dataout = 8'b10000010; // Move reg0 to reg2
    8'b00000100: dataout = 8'b01000100; // reg3 = reg1 + reg2
    8'b00000101: dataout = 8'b10011001; // Move reg3 to reg1
    8'b00000110: dataout = 8'b00001111; // reg0 = 15
    8'b00000111: dataout = 8'b10000010; // Move reg0 to reg2
    8'b00001000: dataout = 8'b01000101; // reg3 = reg1 - reg2
    8'b00001001: dataout = 8'b00000000; // reg0 = 0
    8'b00001010: dataout = 8'b11000001; // Jump to 0 if reg3 == 0
    default: dataout = 8'b00000000;
  endcase

endmodule
