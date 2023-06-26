

module top(
    input clk_in,
    input rst_in,
    input analog_cmp_p,
    input analog_cmp_n,
    output [5:0] c,
    output c_gnd,
    output sample_switch,
    output [4:0] n
);



IBUFDS #(
    .DIFF_TERM("FALSE"),    // Differential Termination set to FALSE (we want High-Z)
    .IBUF_LOW_PWR("TRUE"),  // Low power="TRUE", Highest performance="FALSE" 
    .IOSTANDARD("DEFAULT")  // Specify the input I/O standard
) IBUFDS_COMP (
    .O(analog_cmp),         // Buffer output
    .I(analog_cmp_p),       // Diff_p buffer input (connect directly to top-level port)
    .IB(analog_cmp_n)       // Diff_n buffer input (connect directly to top-level port)
);


wire clk;
wire rst;

wire[5:0] wCap;
wire wSample;
wire wCapGnd;
wire[4:0] wResult;


//input assignment
assign clk = clk_in;
assign rst = rst_in;


//module instantiation
adc ADC(
    .rstb(rst),
    .clk(clk),
    .comp(analog_cmp),
    .cap(wCap),
    .gndA(wCapGnd),
    .num(wResult),
    .sample(wSample)
);


//outputs assignment
assign c = wCap;

assign c_gnd = wCapGnd;
assign sample_switch = wSample;

assign n = wResult;


endmodule