`default_nettype none

module top (
    // CLK
    // input CLK100,
    input HWCLK,

    // R data
    output VGARED0,
    output VGARED1,
    output VGARED2,
    output VGARED3,
    // G data
    output VGAGREEN0,
    output VGAGREEN1,
    output VGAGREEN2,
    output VGAGREEN3,
    // B data
    output VGABLUE0,
    output VGABLUE1,
    output VGABLUE2,
    output VGABLUE3,

    // SYNC SIGNAL
    output VGA_HSYNC,
    output VGA_VSYNC
    );

    // PLL
    wire clk_25; // 25 MHz
    pll pll_25MHz(
        .clock_in(HWCLK),
        .clock_out(clk_25),
        .locked()
    );

    // VGA Controller
    wire [9:0] horizontal_num;
    wire video_on;
    vga_controller VGA_CNT (
        .clk_25(clk_25),
        .hsync(VGA_HSYNC),
        .vsync(VGA_VSYNC),
        .horizontal_num(horizontal_num),
        .video_on(video_on)
    );

    // Print on Monitor
    four_color MONITOR (
        .clk_25(clk_25),
        .video_on(video_on),
        .horizontal_num(horizontal_num),
        .red({VGARED3, VGARED2, VGARED1, VGARED0}),
        .green({VGAGREEN3, VGAGREEN2, VGAGREEN1, VGAGREEN0}),
        .blue({VGABLUE3, VGABLUE2, VGABLUE1, VGABLUE0})
    );
    
endmodule