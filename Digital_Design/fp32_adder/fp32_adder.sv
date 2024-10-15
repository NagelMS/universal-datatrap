/* -------------------------------------------------------------- /
/   Module Name:    fp32_adder                                    /
/   Description:    Single Precision Floating Point (FP32) Adder  /
/   Author:         Nagel Mejía Segura                            /
/   Create Date:    03.09.2024                                    /
/ -------------------------------------------------------------- */

module fp32_adder{
    input logic [31:0]      a,          //  First Operand
    input logic [31:0]      b,          //  Second Operand

    output logic [31:0]     result      //  Result 
}

// Prefixes Used: s -> sign, m -> mantissa, e -> exponent

logic s_a;
logic s_b;

logic [22:0]    m_a;
logic [22:0]    m_b;

logic [7:0]     e_a;
logic [7:0]     e_b;

assign s_a = a[31];
assign s_b = b[31];

assign e_a = a[30:23];
assign e_b = b[30:23];

assign m_a = a[22:0];
assign m_b = b[22:0];