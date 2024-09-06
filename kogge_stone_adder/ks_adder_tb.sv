`timescale 1ns/1ps
`include "ks_adder.sv"

module ks_adder_tb;

    // Parameter for the adder input sizes
    parameter SIZE = 64;
    localparam LEVELS = $clog2(SIZE);

    // Defining signals
    logic [SIZE-1:0] a_tb;
    logic [SIZE-1:0] b_tb;
    logic c_in_tb;
    logic [SIZE-1:0] result_tb;
    logic c_out_tb;

    // Instance of Kogge Adder
    ks_adder #(.SIZE(SIZE)) dut (
        .a(a_tb),
        .b(b_tb),
        .c_in(c_in_tb),
        .result(result_tb),
        .c_out(c_out_tb)
    );

    integer k,l;

    // Testbench stimulus
    initial begin
        k = 0;
        l = 0;
        a_tb = 0;
        b_tb = 0;
        c_in_tb = 0;
        #10; 

        repeat(100) begin
            a_tb = $random;
            b_tb = $random;
            c_in_tb = $random;
            #10;



            if ({c_out_tb,result_tb} != (a_tb + b_tb + c_in_tb)) begin
                l++;
                $display("Error: a: %d - b: %d - sum: %d", a_tb, b_tb, {c_out_tb,result_tb});
            end else begin
                k++;
                $display("a: %d - b: %d - sum: %d", a_tb, b_tb, {c_out_tb,result_tb});
            end


            $display("\n");

        end

        $display("Errors: %d",l);
        $display("Correct: %d",k);

        $finish;
    end

endmodule