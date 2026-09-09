// Module: single_bit_full_adder
// Description: A basic full adder based off of the logic as presented on the slides.
//& is for AND and ^ is for XOR
module adder
( input bit A,B,Cin,
  output bit Co,S);
    assign Co = (A & B) | (A & Cin) | (B & Cin);
    assign S = A ^ B ^ Cin;
endmodule




