/* -------------------------------------------------------------- /
/   Module Name:    ks_adder                                      /
/   Description:    Kogge-Stone Adder (KSA)                       /
/   Author:         Nagel Mejía Segura                            /
/   Create Date:    05.09.2024                                    /
/ -------------------------------------------------------------- */

module ks_adder #(parameter SIZE = 3)(
    input logic [SIZE - 1:0]    a,          //  First Operand
    input logic [SIZE - 1:0]    b,          //  Second Operand
    input logic                 c_in,       // Input carry

    output logic [SIZE -1 :0]   result,      //  Result
    output logic                c_out       // Output carry
);

localparam LEVELS = $clog2(SIZE);

logic [SIZE - 1:0] prop_i [LEVELS:0];
logic [SIZE - 1:0] gen_i [LEVELS:0];

logic [SIZE - 1 : 0] carry_int;

assign prop_i[0] = a ^ b;   //
assign gen_i[0] = a & b;    // 


genvar i,j;
generate
    for (j = 1; j <= LEVELS; j++)begin:stage_
        for (i = 0; i < SIZE; i++)begin:op_
            if(i < (2**((j-1)))) begin
                assign prop_i[j][i] = prop_i[j-1][i];
                assign gen_i[j][i] = gen_i[j-1][i];
            end else begin
                assign prop_i[j][i] = prop_i[j-1][i] & prop_i[j-1][i-(2**(j-1))];
                assign gen_i[j][i] = (prop_i[j-1][i] & gen_i[j-1][i-(2**(j-1))]) | gen_i[j-1][i];
            end
        end
    end
endgenerate


generate
    for (i = 0; i < SIZE; i++) begin
        assign carry_int[i] = gen_i[LEVELS][i] | (prop_i[LEVELS][i] & c_in);
    end
endgenerate

assign c_out = carry_int[SIZE - 1];

assign result[0] = c_in ^ prop_i[0][0];


generate
    for (i = 1; i < SIZE; i++) begin
        assign result[i] = (prop_i[0][i]  ^  carry_int[i-1]);
    end
endgenerate


endmodule

module prop_gen(
    input logic prop_i,
    input logic prop_prev_i,
    input logic gen_i,
    input logic gen_prev_i,
    
    output logic prop_o,
    output logic gen_o
);

assign prop_o = prop_i & prop_prev_i;
assign gen_o = (prop_i & gen_prev_i) | gen_i;

endmodule


