// Modified based on example from Greg Stitt, University of Florida

// This file shows how to implement an ALU, and how to avoid latches, which are
// a common problem with combinational logic descriptions in HDL.
//
// The ALU has a parameter for width and performs addition (sel = 2'b00),
// subtraction (sel=2'b01), and (sel=2'b10), or (sel=2'b11). There are also
// status flags to signify negative, zero, carry, and overflow.
// All 4 can be set when adding or subtracting
// Only Negative and Zero can be set when ANDing or ORing

// Module: alu1
// Description: Default ALU implementation

module alu1 #(
    parameter int WIDTH
) (
    input  logic signed [WIDTH-1:0] in0,
    input  logic signed [WIDTH-1:0] in1,
    input  logic [      1:0] sel,
    output logic             neg,
    output logic             zero,
    output logic             carry,
    output logic             over,
    output logic signed [WIDTH-1:0] out,
    output logic signed [WIDTH:0] result
);
    logic oldC, oldV;
    always_comb begin
        case (sel)
            // Addition
            2'b00: begin result = in0 + in1;
            out = result[WIDTH-1:0]; end
            // Subtraction
            2'b01: begin result = in0 - in1;
            out = result[WIDTH-1:0]; end
            // And
            2'b10: begin result = in0 & in1;
            out = result[WIDTH-1:0]; end
            // Or
            2'b11: begin result = in0 | in1;
            out = result[WIDTH-1:0]; end
        endcase
        
        //Update all our flags depending on the operation
        if (out == 0) begin
            zero = 1'b1;
        end else begin
            zero = 1'b0;
        end
        neg  = out[WIDTH-1];

        if (sel[1] == 1'b0) begin
            carry  = result[WIDTH];
        end else begin
            carry = oldC;
        end
        
        if ((sel == 2'b00 & in0[WIDTH-1] == in1[WIDTH-1] & in0[WIDTH-1] != out[WIDTH-1]) | (sel == 2'b01 & in0[WIDTH-1] != in1[WIDTH-1] & in0[WIDTH-1] != out[WIDTH-1])) begin
            over  = 1'b1;
        end else if (sel[1] == 1'b0) begin
            over = 1'b0;
        end else begin
            over = oldV;
        end
        oldC = carry;
        oldV = over;
    end
endmodule

// Module: alu2
// Description: An alternative implementation that demonstrates localparam,
// don't cares, and tasks.

module alu2 #(
    parameter int WIDTH
) (
    input  logic signed [WIDTH-1:0] in0,
    input  logic signed [WIDTH-1:0] in1,
    input  logic [      1:0] sel,
    output logic             neg,
    output logic             zero,
    output logic             carry,
    output logic             over,
    output logic signed [WIDTH-1:0] out,
    output logic signed [WIDTH:0] result
);
    logic oldC, oldV;
    // We can define constants with meaningful names to replace hardcoded values.
    localparam logic [1:0] ADD_SEL = 2'b00;
    localparam logic [1:0] SUB_SEL = 2'b01;
    localparam logic [1:0] AND_SEL = 2'b10;
    localparam logic [1:0] OR_SEL = 2'b11;

    // For operations that are common in multiple paths, we can use a task or
    // function to reduce the amount of repeated code. This task updates all
    // status flags based on the output.
    task update_NZflags();
        if (out == 0) begin
            zero = 1'b1;
        end else begin
            zero = 1'b0;
        end
        neg  = out[WIDTH-1];
    endtask

    task update_CVflags();
        carry  = result[WIDTH];
        
        if ((sel == 2'b00 & in0[WIDTH-1] == in1[WIDTH-1] & in0[WIDTH-1] != out[WIDTH-1]) | (sel == 2'b01 & in0[WIDTH-1] != in1[WIDTH-1] & in0[WIDTH-1] != out[WIDTH-1])) begin
            over  = 1'b1;
        end else begin
            over = 1'b0;
        end
    endtask
    always_comb begin
        // If we really don't care what values are assigned to the status flags
        // for operations where the flags aren't defined, we can explicitly
        // assign don't care values to potentially help synthesis simplify logic
        // Note that explicit don't cares can cause problems in some tools and
        // can cause warnings in simulations, so use them with caution.
        neg  = 1'bx;
        zero  = 1'bx;
        carry = 1'bx;
        over = 1'bx;

        case (sel)
            ADD_SEL: begin result = in0 + in1;
                out = result[WIDTH-1:0];
                update_NZflags();
                update_CVflags(); end
            SUB_SEL: begin
                result = in0 - in1;
                out = result[WIDTH-1:0];
                update_NZflags();
                update_CVflags(); end
            AND_SEL: begin result = in0 & in1;
                out = result[WIDTH-1:0];
                update_NZflags();
                carry = oldC;
                over = oldV; end
            OR_SEL:  begin result = in0 | in1;
                out = result[WIDTH-1:0];
                update_NZflags();
                carry = oldC;
                over = oldV; end
        endcase
        oldC = carry;
        oldV = over;
    end
endmodule

// Module: alu
// Description: top-level module for testing synthesis of each alu module.
//    
module alu #(
    parameter int WIDTH = 8
) (
    input  logic signed [WIDTH-1:0] in0,
    input  logic signed [WIDTH-1:0] in1,
    input  logic [      1:0] sel,
    output logic             neg,
    output logic             zero,
    output logic             carry,
    output logic             over,
    output logic signed [WIDTH-1:0] out,
    output logic signed [WIDTH:0] result
);

    alu1 #(.WIDTH(WIDTH)) alu (.*);
    //alu2 #(.WIDTH(WIDTH)) alu (.*);

endmodule
