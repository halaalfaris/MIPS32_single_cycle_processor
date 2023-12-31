module write_reg_MUX (
    input wire select1,     // Select signal
    input wire [31:0] data,// 32-bit input data
    output wire [4:0] outputdata 
);

assign outputdata = (select1) ? data[15:11] : data[20:16];

endmodule