`timescale 1ns/1ns

module top_tb();

parameter CLK_FREQ = 100000000;
parameter C_CLK_JTR = 50;               // Main clock jitter [ps].
localparam real C_CLK_PERIOD = 1E9 / CLK_FREQ;



reg rSysRstb;
reg rSysClk;
reg rCompP;
reg rCompN;

wire[5:0] rCap;
wire[4:0] rNum;
wire rGndA;
wire rSample;
wire rMonitor;
wire rClkTest;

top TOP(
    .clk_in(rSysClk),
    .rst_in(rSysRstb),
    .analog_cmp_p(rCompP),
    .analog_cmp_n(rCompN),
    .c(rCap),
    .c_gnd(rGndA),
    .sample_switch(rSample),
    .n(rNum),
    .clock_test(rClkTest)
);


initial begin
    rSysRstb <= 1'b1;
    rSysClk <= 1'b0;
    rCompP <= 1'b0;
    rCompN <= 1'b1;

    #2000 rSysRstb <= 1'b0;
end

always begin
    #(0.001 * $dist_normal(1, 1000.0 * C_CLK_PERIOD / 2, C_CLK_JTR));
    rSysClk = ! rSysClk;

end



endmodule