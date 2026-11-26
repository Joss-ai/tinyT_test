
`default_nettype none

module tt_um_register_file (
    //Default signals
    input wire clk,         //clock
    input wire ena,         //always 1
    input wire rst_n,       //reset in low

    //Inputs
    input wire [7:0] ui_in,   //data_in
    //Outputs
    output wire [7:0] uo_out, //data_out

    //Inouts
    input  wire [7:0] uio_in,   // IOs: Input path
    //[2:0] write_addr = [2:0] uio_in
    //write_enable = [3] uio_in
    //read_addr = [6:4] uio_in
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe   // IOs: Enable path (active high: 0=input, 1=output)

);

    reg [7:0] registers [0:7];

    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : REGISTERS

            always @(posedge clk) begin

                if (uio_in[3] && (uio_in[2:0] == i)) begin

                    registers[i] = ui_in;

                end

            end

        end
    endgenerate

    //assign outputs
    assign uo_out = registers[uio_in[6:4]];
    assign uio_out[7] = 1'b0;
    assign uio_out[6] = 1'b0;
    assign uio_out[5] = 1'b0;
    assign uio_out[4] = 1'b0;
    assign uio_out[3] = 1'b0;
    assign uio_out[2] = 1'b0;
    assign uio_out[1] = 1'b0;
    assign uio_out[0] = 1'b0;

    // IO Enable Path
    assign uio_oe[7] = 1'b0;
    assign uio_oe[6] = 1'b0;
    assign uio_oe[5] = 1'b0;
    assign uio_oe[4] = 1'b0;
    assign uio_oe[3] = 1'b0;
    assign uio_oe[2] = 1'b0;
    assign uio_oe[1] = 1'b0;
    assign uio_oe[0] = 1'b0;
    
    wire _unused = {ena, rst_n, 1'b0};
endmodule

`default_nettype wire
