module vga_sync (
    input  logic        pixel_clk,
    input  logic        red_in,
    input  logic        green_in,
    input  logic        blue_in,

    output logic        red_out,
    output logic        green_out,
    output logic        blue_out,
    output logic        hsync,
    output logic        vsync,

    output logic [10:0] pixel_row,
    output logic [10:0] pixel_col
);

    logic [10:0] h_cnt = '0;
    logic [10:0] v_cnt = '0;

    localparam int H      = 800;
    localparam int V      = 600;
    localparam int H_FP   = 40;
    localparam int H_BP   = 88;
    localparam int H_SYNC = 128;
    localparam int V_FP   = 1;
    localparam int V_BP   = 23;
    localparam int V_SYNC = 4;

    localparam int FREQ   = 60;

    logic video_on;

    always_ff @(posedge pixel_clk) begin

        // Generate Horizontal Timing Signals for Video Signal
        // total horizontal line width = H + H_FP + H_SYNC + H_BP
        // Reset h_cnt when at end of line
        if (h_cnt >= (H + H_FP + H_SYNC + H_BP - 1)) begin
            h_cnt <= '0;
        end
        else begin
            h_cnt <= h_cnt + 11'd1;
        end

        // Pull down hsync after front porch
        if ((h_cnt >= (H + H_FP)) &&
            (h_cnt <= (H + H_FP + H_SYNC))) begin
            hsync <= 1'b0;
        end
        else begin
            hsync <= 1'b1;
        end

        if ((v_cnt >= (V + V_FP + V_SYNC + V_BP - 1)) &&
            (h_cnt == (H + FREQ - 1))) begin
            v_cnt <= '0;
        end
        else if (h_cnt == (H + FREQ - 1)) begin
            v_cnt <= v_cnt + 11'd1;
        end

        if ((v_cnt >= (V + V_FP)) &&
            (v_cnt <= (V + V_FP + V_SYNC))) begin
            vsync <= 1'b0;
        end
        else begin
            vsync <= 1'b1;
        end

        // Generate Video Signals and Pixel Address
        if ((h_cnt < H) && (v_cnt < V)) begin
            video_on = 1'b1;
        end
        else begin
            video_on = 1'b0;
        end

        pixel_col <= h_cnt;
        pixel_row <= v_cnt;

        // Register video to clock edge and suppress video
        // during blanking and sync periods
        red_out   <= red_in   & video_on;
        green_out <= green_in & video_on;
        blue_out  <= blue_in  & video_on;

    end

endmodule