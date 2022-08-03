module top(
    input clk_100MHz,
    input reset,        // btnC
    input up,           // btnU
    input down,         // btnD
    input left,         // btnL
    input right,        // btnR
    output hsync,      
    output vsync,
    output [11:0] rgb
);

    // Module connection signals
    wire w_reset, w_up, w_down, w_left, w_right;
    wire w_video_on, w_p_tick;
    wire [9:0] w_x, w_y;
    //RGB buffer signals
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;

    // Instantiate Inner Modules
    vga_controller vga(
        .clk_100MHz(clk_100MHz),
        .reset(w_reset),
        .video_on(w_video_on),
        .p_tick(w_p_tick),
        .hsync(hsync),
        .vsync(vsync),
        .x(w_x),
        .y(w_y)
    );

    debounce dReset(
        .clk(clk_100MHz),
        .btn_in(reset),
        .btn_out(w_reset)
    );

    debounce dUp(
        .clk(clk_100MHz),
        .btn_in(up),
        .btn_out(w_up)
    );

    debounce dDown(
        .clk(clk_100MHz),
        .btn_in(down),
        .btn_out(w_down)
    );

    debounce dLeft(
        .clk(clk_100MHz),
        .btn_in(left),
        .btn_out(w_left)
    );

    debounce dRight(
        .clk(clk_100MHz),
        .btn_in(right),
        .btn_out(w_right)
    );

    pixel_gen pg(
        .clk(clk_100MHz),
        .reset(w_reset),
        .up(w_up),
        .down(w_down),
        .left(w_left),
        .right(w_right),
        .video_on(w_video_on),
        .p_tick(w_p_tick),
        .x(w_x),
        .y(w_y),
        .rgb(rgb_next)
    );


    // rgb buffer
    always @(posedge clk_100MHz)
        if (w_p_tick)
            rgb_reg <= rgb_next;
        
    assign rgb = rgb_reg;

endmodule