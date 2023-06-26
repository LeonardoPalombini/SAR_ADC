//nothing up to now

`timescale 1ns/1ns

module adc_tb();

parameter CLK_FREQ = 1000000;
parameter C_CLK_JTR = 500;               // Main clock jitter [ps].
localparam real C_CLK_PERIOD = 1E9 / CLK_FREQ;


//static int seed = $urandom + 0;

reg rSysRstb;
reg rSysClk;
reg rComp;

wire[5:0] rCap;
wire[4:0] rNum;
wire rGndA;
wire rSample;
wire rMonitor;


adc ADC(
    .rstb(rSysRstb),
    .clk(rSysClk),
    .comp(rComp),
    .cap(rCap),
    .gndA(rGndA),
    .num(rNum),
    .sample(rSample),
    .mon(rMonitor)
);

initial begin
    rSysRstb <= 1'b0;
    rSysClk <= 1'b0;
    rComp <= 1'b0;

    #2000 rSysRstb <= 1'b1;
end

always begin
    #(0.001 * $dist_normal(1, 1000.0 * C_CLK_PERIOD / 2, C_CLK_JTR));
    rSysClk = ! rSysClk;

    if($random > 0) begin
        rComp = 1'b0;
    end else begin
        rComp = 1'b1;
    end
end


endmodule