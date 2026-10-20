module bat_n_ball (
    input  logic        v_sync,
    input  logic [10:0] pixel_row,
    input  logic [10:0] pixel_col,

    input  logic [10:0] bat_x,      // current bat x position
    input  logic        serve,      // initiates serve

    output logic        red,
    output logic        green,
    output logic        blue
);

    localparam int BSIZE = 8;   // ball size in pixels
    localparam int BAT_W = 20;  // bat width in pixels
    localparam int BAT_H = 3;   // bat height in pixels

    localparam logic [10:0] BALL_SPEED = 11'd6; // distance ball moves each frame

    logic ball_on;              // indicates whether ball is at current pixel position
    logic bat_on;               // indicates whether bat at over current pixel position

    logic game_on = 1'b0;       // indicates whether ball is in play

    // current ball position - initialized to center of screen
    logic [10:0] ball_x = 11'd400;
    logic [10:0] ball_y = 11'd300;

    // bat vertical position
    localparam logic [10:0] BAT_Y = 11'd500;

    // current ball motion - initialized to (+ ball_speed)
    // pixels/frame in both X and Y directions
    logic [10:0] ball_x_motion = BALL_SPEED;
    logic [10:0] ball_y_motion = BALL_SPEED;

    //------------------------------------------------------------------
    // color setup for red ball and cyan bat on white background
    //------------------------------------------------------------------
    assign red   = ~bat_on;
    assign green = ~ball_on;
    assign blue  = ~ball_on;

    //------------------------------------------------------------------
    // process to draw round ball
    // set ball_on if current pixel address is covered by ball position
    //------------------------------------------------------------------
    always_comb begin : balldraw

        logic [10:0] vx; // 9 downto 0
        logic [10:0] vy;

        if (pixel_col <= ball_x) vx = ball_x - pixel_col;  // vx = |ball_x - pixel_col|
        else vx = pixel_col - ball_x;

        if (pixel_row <= ball_y) vy = ball_y - pixel_row;  // vy = |ball_y - pixel_row|
        else vy = pixel_row - ball_y;

        if (((vx * vx) + (vy * vy)) < (BSIZE * BSIZE)) begin
            // test if radial distance < bsize
            ball_on = game_on;
        end
        else ball_on = 1'b0;
    end

    //------------------------------------------------------------------
    // process to draw bat
    // set bat_on if current pixel address is covered by bat position
    //------------------------------------------------------------------
    always_comb begin : batdraw

        if ((((pixel_col >= (bat_x - BAT_W)) || (bat_x <= BAT_W)) &&
              (pixel_col <= (bat_x + BAT_W)) &&
              (pixel_row >= (BAT_Y - BAT_H)) &&
              (pixel_row <= (BAT_Y + BAT_H))))
        begin
            bat_on = 1'b1;
        end
        else begin
            bat_on = 1'b0;
        end
    end

    //------------------------------------------------------------------
    // process to move ball once every frame
    // (i.e., once every vsync pulse)
    //------------------------------------------------------------------
    always_ff @(posedge v_sync) begin : mball

        logic [11:0] temp;

        if (serve && !game_on) begin  // test for new serve
            game_on       <= 1'b1;
            ball_y_motion <= (~BALL_SPEED) + 11'd1; // set vspeed to (- ball_speed) pixels

        end
        else if (ball_y <= BSIZE) begin // bounce off top wall
            ball_y_motion <= BALL_SPEED; // set vspeed to (+ ball_speed) pixels
        end
        else if ((ball_y + BSIZE) >= 600) begin // if ball meets bottom wall
            ball_y_motion <= (~BALL_SPEED) + 11'd1; // set vspeed to (- ball_speed) pixels
            game_on <= 1'b0; // and make ball disappear
        end

        // allow for bounce off left or right of screen
        if ((ball_x + BSIZE) >= 800) begin // bounce off right wall
            ball_x_motion <= (~BALL_SPEED) + 11'd1; // set hspeed to (- ball_speed) pixels
        end
        else if (ball_x <= BSIZE) begin // bounce off left wall
            ball_x_motion <= BALL_SPEED; // set hspeed to (+ ball_speed) pixels
        end

        // allow for bounce off bat
        if (((ball_x + BSIZE/2) >= (bat_x - BAT_W)) &&
            ((ball_x - BSIZE/2) <= (bat_x + BAT_W)) &&
            ((ball_y + BSIZE/2) >= (BAT_Y - BAT_H)) &&
            ((ball_y - BSIZE/2) <= (BAT_Y + BAT_H)))
        begin
            ball_y_motion <= (~BALL_SPEED) + 11'd1; // set vspeed to (- ball_speed) pixels
        end

        // Compute next ball vertical position.
        // Variable temp adds one more bit to calculation to fix unsigned
        // underflow problems when ball_y is close to zero and ball_y_motion is negative.
        temp = {1'b0, ball_y} +
               {ball_y_motion[10], ball_y_motion};

        if (!game_on) ball_y <= 11'd440;
        else if (temp[11]) ball_y <= '0;
        else ball_y <= temp[10:0]; // 9 downto 0

        // Compute next ball horizontal position.
        // Variable temp adds one more bit to calculation to fix unsigned
        // underflow problems when ball_x is close to zero and ball_x_motion is negative
        temp = {1'b0, ball_x} +
               {ball_x_motion[10], ball_x_motion};

        if (temp[11]) ball_x <= '0;
        else ball_x <= temp[10:0];

    end

endmodule