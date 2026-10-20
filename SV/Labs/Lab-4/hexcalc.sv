module hexcalc (
    input  logic        clk_50MHz,     // system clock (50 MHz)

    output logic [7:0]  SEG7_anode,    // anodes of eight 7-seg displays
    output logic [6:0]  SEG7_seg,      // common segments of 7-seg displays

    input  logic        bt_clr,        // calculator "clear" button
    input  logic        bt_plus,       // calculator "+" button
    input  logic        bt_eq,         // calculator "=" button

    output logic [4:1]  KB_col,        // keypad column pins
    input  logic [4:1]  KB_row         // keypad row pins
);

    logic [20:0] cnt;                  // counter to generate timing signals

    logic kp_clk;
    logic kp_hit;
    logic sm_clk;

    logic [3:0] kp_value;

    logic [15:0] nx_acc, acc;          // accumulated sum
    logic [15:0] nx_operand, operand;  // operand
    logic [15:0] display;              // value to be displayed

    logic [2:0] led_mpx;               // 7-seg multiplexing clock

    typedef enum logic [2:0] {
        ENTER_ACC,
        ACC_RELEASE,
        START_OP,
        OP_RELEASE,
        ENTER_OP,
        SHOW_RESULT
    } state_t;                         // state machine states

    state_t pr_state, nx_state;        // present and next states

    //------------------------------------------------------------------
    // Counter / timing generation
    //------------------------------------------------------------------

    always_ff @(posedge clk_50MHz) begin
        // on rising edge of clock
        cnt <= cnt + 21'd1;            // increment counter
    end

    assign kp_clk  = cnt[15];          // keypad interrogation clock
    assign sm_clk  = cnt[20];          // state machine clock
    assign led_mpx = cnt[19:17];       // 7-seg multiplexing clock

    //------------------------------------------------------------------
    // Keypad interface
    //------------------------------------------------------------------

    keypad kp1 (
        .samp_ck (kp_clk),
        .col     (KB_col),
        .row     (KB_row),
        .value   (kp_value),
        .hit     (kp_hit)
    );

    //------------------------------------------------------------------
    // 7-segment display driver
    //------------------------------------------------------------------

    leddec16 led1 (
        .dig   (led_mpx),
        .data  (display),
        .anode (SEG7_anode),
        .seg   (SEG7_seg)
    );

    //------------------------------------------------------------------
    // State machine clock process
    //------------------------------------------------------------------

    always_ff @(posedge sm_clk or posedge bt_clr) begin
        if (bt_clr) begin
            // reset to known state
            acc      <= 16'h0000;
            operand  <= 16'h0000;
            pr_state <= ENTER_ACC;
        end
        else begin
            // on rising clock edge
            pr_state <= nx_state;      // update present state
            acc      <= nx_acc;        // update accumulator
            operand  <= nx_operand;    // update operand
        end
    end

    //------------------------------------------------------------------
    // State machine combinatorial process
    // determines output of state machine and next state
    //------------------------------------------------------------------

    always_comb begin

        nx_acc     = acc;              // default values of nx_acc,
        nx_operand = operand;          // nx_operand & display
        display    = acc;

        case (pr_state)                // depending on present state...

            ENTER_ACC: begin
                // waiting for next digit in 1st operand entry
                if (kp_hit) begin
                    nx_acc   = {acc[11:0], kp_value};
                    nx_state = ACC_RELEASE;
                end
                else if (bt_plus) begin
                    nx_state = START_OP;
                end
                else nx_state = ENTER_ACC;
            end

            ACC_RELEASE: begin
                // waiting for button to be released
                if (!kp_hit) begin
                    nx_state = ENTER_ACC;
                end
                else nx_state = ACC_RELEASE;
            end

            START_OP: begin
                // ready to start entering 2nd operand
                if (kp_hit) begin
                    nx_operand = {12'h000, kp_value};
                    nx_state   = OP_RELEASE;
                    display    = operand;
                end
                else nx_state = START_OP;
            end

            OP_RELEASE: begin
                // waiting for button to be released
                display = operand;

                if (!kp_hit) begin
                    nx_state = ENTER_OP;
                end
                else nx_state = OP_RELEASE;
            end

            ENTER_OP: begin
                // waiting for next digit in 2nd operand
                display = operand;

                if (bt_eq) begin
                    nx_acc   = acc + operand;
                    nx_state = SHOW_RESULT;
                end
                else if (kp_hit) begin
                    nx_operand = {operand[11:0], kp_value};
                    nx_state   = OP_RELEASE;
                end
                else nx_state = ENTER_OP;
            end

            SHOW_RESULT: begin
                // display result of addition
                if (kp_hit) begin
                    nx_acc   = {12'h000, kp_value};
                    nx_state = ACC_RELEASE;
                end
                else nx_state = SHOW_RESULT;
            end

            default: begin
                nx_state = ENTER_ACC;
            end

        endcase
    end

endmodule