
`timescale 1ns/1ps

module register_file (
    input wire [31:0] data_in,
    input wire [3:0] write_addr,
    input wire write_enable,

    input wire [3:0] read_addr_a,
    input wire [3:0] read_addr_b,

    output wire [31:0] data_out_a,
    output wire [31:0] data_out_b
);

    // Banco de 16 registros de 32 bits
    reg [31:0] registers [0:15];

    // Generacion de 16 LATCHs de 32 bits
    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin : REGISTERS

            always @(*) begin
                if (write_enable && (write_addr == i)) begin
                    registers[i] = data_in;
                end
            end

        end
    endgenerate

    // Puerto de lectura A
    assign data_out_a = registers[read_addr_a];

    // Puerto de lectura B
    assign data_out_b = registers[read_addr_b];

endmodule
