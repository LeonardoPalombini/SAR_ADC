//========= CHARGE REDISTRIBUTION SAR-ADC =========
//
//This module takes as input the timing signals
//and the analog comparator, and outputs the controls
//for the analog circuit and the ADC result



`timescale 1ns/1ps

module adc (
    input rstb,
    input clk,

    input comp,             //comparator result

    output reg[5:0] cap,    //capacitors S_i
    output reg gndA,            //common capacitors gnd
    output reg[4:0] num,    //digital output
    output reg sample,           //analog signal sampling
    output wire mon          //only for simulation
);


reg[2:0] state = 3'b111;    //current state: default 111 = "restart cycle"
reg bit = 1'b0;             //latch for comparator result
reg[4:0] rNum = 5'b00000;   //latch for cycle result

assign mon = bit;

always @(posedge clk) begin     //latch comparator result
    bit <= comp;
end


always @(posedge clk) begin
    if(rstb == 1'b0) begin  //reset action
        state <= 3'b111;
        cap <= 6'b000000;
        gndA <= 1'b0;
        rNum <= 5'b00000;
    end else begin
        if(state == 3'b111) begin
            sample <= 1'b1;     //common cap In to analog signal
            gndA <= 1'b0;       //all cap to common gnd
            state <= 3'b000;    //next state
            cap <= 6'bzzzzzz;   //single cap ends to high Z
        end else begin
            sample <= 1'b0;     //stop sampling, isolate common In
            gndA <= 1'bz;       //isolate common gnd, now "floating" caps
            case(state)
                3'b000: begin               //set redistr 0
                    cap <= 6'b100000;
                    state <= state +1;
                end
                3'b001: begin               //set redistr 1
                    rNum[4] <= bit;      //bit value comes from the previous state's setting
                    if(bit == 1'b1)begin
                        cap[4] <= 1'b1;
                    end else begin
                        cap[5] <= 1'b0;
                        cap[4] <= 1'b1;
                    end

                    state <= state +1;
                end
                3'b010: begin               //set redistr 2
                    rNum[3] <= bit;

                    if(bit == 1'b1)begin
                        cap[3] <= 1'b1;
                    end else begin
                        cap[4] <= 1'b0;
                        cap[3] <= 1'b1;
                    end

                    state <= state + 1;
                end
                3'b011: begin               //set redistr 3
                    rNum[2] <= bit;

                    if(bit == 1'b1)begin
                        cap[2] <= 1'b1;
                    end else begin
                        cap[3] <= 1'b0;
                        cap[2] <= 1'b1;
                    end

                    state <= state + 1;
                end
                3'b100: begin               //set redistr 4
                    rNum[1] <= bit;

                    if(bit == 1'b1)begin
                        cap[1] <= 1'b1;
                    end else begin
                        cap[2] <= 1'b0;
                        cap[1] <= 1'b1;
                    end

                    state <= state + 1;
                end
                3'b101: begin               //set redistr 5
                    rNum[0] <= bit;
                    state <= state + 1;
                end
                3'b110: begin               //out the final number, set restart
                    num <= rNum;
                    state <= 3'b111;
                end
            endcase
        end
    end
end



endmodule