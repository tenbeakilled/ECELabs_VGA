module vga_controller #(
    parameter HVID = 640,     // horizontal active video width pix clocks
    parameter HFP = 16,      // horizontal front porch pix clocks
    parameter HS = 96,      // horizontal hsync pulse width pix clocks
    parameter HBP = 48,      // horizontal back porch pix clocks
    parameter VVID = 480,     // vertical active video lines
    parameter VFP = 10,      // vertical front porch video lines
    parameter VS = 2,       // vertical vsync pulse width video lines
    parameter VBP = 29       // vertical back porch video lines
) (
    input clk_25,
    output reg hsync,
    output reg vsync,
    output wire [9:0] horizontal_num
);

localparam HC_MAX = HVID + HFP+HS+HBP;   // one more than the max horizontal count value
localparam VC_MAX = VVID + VFP+VS+VBP;   // one more than the max vertical count value

localparam HSYNC_BEGIN = HVID + HFP;         // first pix clock hsync should go on
localparam HSYNC_END = HSYNC_BEGIN+HS;   // first pix clock that hsync should go off

localparam VSYNC_BEGIN = VVID+VFP;
localparam VSYNC_END = VSYNC_BEGIN+VS;

reg next_hsync;
reg next_vsync;

reg [9:0] pixel_x;
reg [9:0] pixel_y;
reg [9:0] next_pixel_x;
reg [9:0] next_pixel_y;

initial begin
    pixel_x = 0;
    pixel_y = 0;
    vsync = 0;
    hsync = 0;
end
// assign horizontal_num = pixel_x;
assign horizontal_num = (pixel_x < HVID && pixel_y < VVID) ? pixel_x : 10'd0;

always @(posedge clk_25) begin
    pixel_x <= next_pixel_x;
    pixel_y <= next_pixel_y;
    vsync <= next_vsync;
    hsync <= next_hsync;
end

always @(*) begin
    
    if(pixel_x >= HC_MAX - 1) next_pixel_x = 0;
    else next_pixel_x = pixel_x + 1;

    if (!next_pixel_x) next_pixel_y = (pixel_y >= VC_MAX-1) ? 0 : pixel_y + 1;
    else next_pixel_y = pixel_y;

    next_hsync = (next_pixel_x >= HSYNC_BEGIN && next_pixel_x < HSYNC_END) ? 1 : 0;
    next_vsync = (next_pixel_y >= VSYNC_BEGIN && next_pixel_y < VSYNC_END) ? 1 : 0;
end

endmodule