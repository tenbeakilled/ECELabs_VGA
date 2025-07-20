module four_color #(
    parameter HVID = 640
) (
    input clk_25,
    input video_on,
    input [9:0] horizontal_num,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
);

always @(*) begin
    if(!video_on) begin
        red = 0;
        green = 0;
        blue = 0;
    end
    else if(horizontal_num < 10'd160) begin // First Block
        red = 4'hF;
        green = 4'h0;
        blue = 4'h0;
    end
    else if(horizontal_num < 10'd320) begin // Second Block
        red = 4'h0;
        green = 4'hF;
        blue = 4'h0;
    end
    else if(horizontal_num < 10'd480) begin // Third Block
        red = 4'h0;
        green = 4'h0;
        blue = 4'hF;
    end
    else begin // Fourth Block
        red = 4'hF;
        green = 4'hF;
        blue = 4'hF;
    end
end
endmodule