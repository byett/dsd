// Greg Stitt
// University of Florida
//
// This file demonstrates how to use a loop to generate a structural pattern
// in a circuit. Specifically, it creates a ripple carry adder with a
// parameterized width by instantiating full adders in a loop.
//
// See ripple_carry_adder.pdf for an illustration of the schematic being
// created. Remember that all strucutural architectures should start from a
// schematic.


// Module: full_adder
// Description: A basic behavioral implementation of a full adder.

module full_adder 
( input logic A,B,Cin,
  output logic Co,S);
    assign Co = (A & B) | (A & Cin) | (B & Cin);
    assign S = A ^ B ^ Cin;

endmodule  // full_adder


// Module: ripple_carry_adder
// Description: A structural ripple carry adder with a parameter for width,
// built from the preceding full_adder module. Demonstrates how to use a
// generate statement and for loop.

module ripple_carry_adder #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             Cin,
    output logic [WIDTH-1:0] S,
    output logic             Co
);
    // Create an internal signal to store the carries between all full adders.
    // Note that this is WIDTH+1 bits to account for the overall carry out.
    logic [WIDTH:0] carry;

    // Connect the first carry to the carry in.
    assign carry[0] = Cin;

    // Instantiate WIDTH separate full adders using a for loop, and connect them
    // into a ripple-carry by connecting the carry out from one full adder into
    // the carry in of the next.
    //
    // You can also use an if statement within a generate, but keep in mind that
    // the condition must be a function of constants and parameters. No dynamic
    // values can be used because the synthesis tool must resolve the condition
    // at compile time.
    generate
        for (genvar i = 0; i < WIDTH; i++) begin : ripple_carry_gen
            full_adder FA (
                .A   (A[i]),
                .B   (B[i]),
                .S   (S[i]),
                .Cin (carry[i]),
                .Co (carry[i+1])
            );
        end
    endgenerate

    // Connect the last carry to the carry out.
    assign Co = carry[WIDTH];

endmodule

