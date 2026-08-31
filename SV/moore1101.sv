module moore1101 (
    input  logic       clk,
    input  logic       rst,
    input  logic       X,
    output logic       Z
);

    typedef enum logic [2:0] {
        A,
        B,
        C,
        D,
        E
    } state_t;

    state_t present_state, next_state;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) present_state <= A;
        else present_state <= next_state;
    end
//States A through D output 0's
//State E outputs 1
//From state A, a 1 goes to state B
//From state A, a 0 goes to state A
//B: 1 -> C
//B: 0 -> A
//C: 1 -> C
//C: 0 -> D
//D: 0 -> A
//D: 1 -> E
//E: 0 -> A
//E: 1 -> C    
    always_comb begin

        case (present_state)
            A: begin
                Z = 1'b0;
                if (X) next_state = B;
                else next_state = A;
            end

            B: begin
                Z = 1'b0;
                if (X) next_state = C;
                else next_state = A;
            end

            C: begin
                Z = 1'b0;
                if (X) next_state = C;
                else next_state = D;
            end

            D: begin
                Z = 1'b0;
                if (X) next_state = E;
                else next_state = A;
            end
            
            E: begin
                Z = 1'b1;
                if (X) next_state = C;
                else next_state = A;
            end
        endcase
    end
endmodule
