`timescale 1 ns / 1 ns

module top(
    input clk_in,
    input rst_in,
    input analog_cmp_p,
    input analog_cmp_n,
    output [5:0] c,
    output c_gnd,
    output sample_switch,
    output [4:0] n,
    output clock_test
);

parameter dim=6;
reg[dim:0] countClk = 'b0;
reg secClock = 'b0;

wire cStop;

assign clock_test = secClock;
assign cStop = countClk[dim];
assign ledR = rst_in;

always @(posedge clk_in) begin
    if(rst_in == 1'b1) begin
        countClk <= { dim+1 {1'b0} };
        secClock <= 1'b0;
    end else if(rst_in == 1'b0 && cStop == 1'b1) begin
        countClk <= { dim+1 {1'b0} };
        secClock <= !secClock;
    end else if(rst_in == 1'b0 && cStop == 1'b0) begin
        countClk <= countClk +1;
    end
end






IBUFDS #(
    .DIFF_TERM("FALSE"),    // Differential Termination set to FALSE (we want High-Z)
    .IBUF_LOW_PWR("TRUE"),  // Low power="TRUE", Highest performance="FALSE" 
    .IOSTANDARD("DEFAULT")  // Specify the input I/O standard
) IBUFDS_COMP (
    .O(analog_cmp),         // Buffer output
    .I(analog_cmp_p),       // Diff_p buffer input (connect directly to top-level port)
    .IB(analog_cmp_n)       // Diff_n buffer input (connect directly to top-level port)
);


//wire clk;
//wire rst;

//wire[5:0] wCap;
//wire wSample;
//wire wCapGnd;
//wire[4:0] wResult;
//wire monitor;

//input assignment
//assign clk = clk_in;
//assign rst = rst_in;


//module instantiation
adc ADC(
    .rstb(rst_in),
    .clk(clk_in),
    .sec_clk(secClock),
    .comp(analog_cmp),
    .cap(c),
    .gndA(c_gnd),
    .num(n),
    .sample(sample_switch),
    .mon(monitor)
);


//outputs assignment
//assign c = wCap;

//assign c_gnd = wCapGnd;
//assign sample_switch = wSample;

//assign n = wResult;
//assign ledC = secClock;

endmodule