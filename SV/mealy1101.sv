module mealy1101 (
    input  logic clk,
    input  logic rst,
    input  logic X,
    output logic Z
);

    typedef enum logic [1:0] {
        A,
        B,
        C,
        D
    } state_t;
    state_t present_state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) present_state <= A;
        else present_state <= next_state;
    end
//From state A, a 1 outputs a 0 and goes to state B
//From state A, a 0 outputs a 0 and goes to state A
//B: 1/0 -> C
//B: 0/0 -> A
//C: 1/0 -> C
//C: 0/0 -> D
//D: 0/0 -> A
//D: 1/1 -> B 
    always_comb begin
        case (present_state)
            A: begin
                // As a reminder, in a Mealy FSM, outputs are a function of the state and the
                // current input, which makes them associated with transitions.
                // Therefore, all outputs appear within if statements that
                // correspond to transitions between states.
                if (X) begin
                    Z       = 1'b0;
                    next_state = B;
                end else begin
                    Z       = 1'b0;
                    next_state = A;
                end
            end

            B: begin
                if (X) begin
                    Z       = 1'b0;
                    next_state = C;
                end else begin
                    Z       = 1'b0;
                    next_state = A;
                end
            end

            C: begin
                if (X) begin
                    Z       = 1'b0;
                    next_state = C;
                end else begin
                    Z       = 1'b0;
                    next_state = D;
                end
            end

            D: begin
                if (X) begin
                    Z       = 1'b1;
                    next_state = B;
                end else begin
                    Z       = 1'b0;
                    next_state = A;
                end
            end
        endcase
    end
endmodule 