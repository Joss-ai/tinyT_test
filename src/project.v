
`default_nettype none

module tt_um_register_file (
    input wire clk,

    input wire [7:0] data_in,
    input wire [2:0] write_addr,
    input wire write_enable,

    input wire [2:0] read_addr,
    output wire [7:0] data_out,

);

    reg [7:0] registers [0:7];

    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : REGISTERS

            always @(posedge clk) begin

                if (write_enable && (write_addr == i)) begin

                    registers[i] = data_in;

                end

            end

        end
    endgenerate

    assign data_out = registers[read_addr];

endmodule

`default_nettype wire
