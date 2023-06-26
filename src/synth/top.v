

module top(
    clk_in,
    rst_in,
    analog_cmp_p,
    analog_cmp_n,
    c[0],
    c[1],
    c[2],
    c[3],
    c[4],
    c[5],
    c_gnd,
    sample_switch
);

//inputs
input clk_in;
input rst_in;
input analog_cmp_p;
input analog_cmp_n;

//outputs
output c[0];
output c[1];
output c[2];
output c[3];
output c[4];
output c[5];
output c_gnd;
output sample_switch;


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
assign c[0] = wCap[0];
assign c[1] = wCap[1];
assign c[2] = wCap[2];
assign c[3] = wCap[3];
assign c[4] = wCap[4];
assign c[5] = wCap[5];

assign c_gnd = wCapGnd;
assign sample_switch = wSample;


endmodule