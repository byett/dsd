module ball (
    input  logic        v_sync,
    input  logic [10:0] pixel_row,
    input  logic [10:0] pixel_col,
    output logic        red,
    output logic        green,
    output logic        blue
);

    localparam int SIZE = 8;

    logic ball_on;  // indicates whether ball is over current pixel position

    // current ball position - initialized to center of screen
    logic [10:0] ball_x = 11'd400;
    logic [10:0] ball_y = 11'd300;

    // current ball motion - initialized to +4 pixels/frame
    logic signed [10:0] ball_y_motion = 11'sd4;

    // color setup for red ball on white background
    assign red   = 1'b1;
    assign green = ~ball_on;
    assign blue  = ~ball_on;

    //------------------------------------------------------------------
    // process to draw ball current pixel address is covered by ball
    // position
    //------------------------------------------------------------------
    always_comb begin
        if ((pixel_col >= (ball_x - SIZE)) &&
            (pixel_col <= (ball_x + SIZE)) &&
            (pixel_row >= (ball_y - SIZE)) &&
            (pixel_row <= (ball_y + SIZE)))
        begin
            ball_on = 1'b1;
        end
        else begin
            ball_on = 1'b0;
        end
    end

    //------------------------------------------------------------------
    // process to move ball once every frame
    // (i.e. once every vsync pulse)
    //------------------------------------------------------------------
    always_ff @(posedge v_sync) begin

        // allow for bounce off top or bottom of screen
        if ((ball_y + SIZE) >= 11'd600) begin
            ball_y_motion <= -11'sd4;  // -4 pixels
        end
        else if (ball_y <= SIZE) begin
            ball_y_motion <= 11'sd4;   // +4 pixels
        end

        // compute next ball position
        ball_y <= ball_y + ball_y_motion;
    end

endmodule