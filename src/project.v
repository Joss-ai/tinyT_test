
`default_nettype none

module tt_um_register_file (

    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,

    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,

    input  wire ena,
    input  wire clk,
    input  wire rst_n

);

    // Comandos
    wire [3:0] reg_addr;
    wire [1:0] command;
    wire [1:0] byte_sel;

    assign reg_addr = uio_in[7:4];
    assign command  = uio_in[3:2];
    assign byte_sel = uio_in[1:0];

    // Registro temporal de 32 bits
    reg [31:0] write_buffer;

    // Control de escritura
    reg [31:0] write_data;
    reg [3:0] write_addr;
    reg write_enable;

    // Direccion de lectura
    wire [31:0] read_data;

    // Instancia del Register File
    register_file rf (
        .data_in(write_data),
        .write_addr(write_addr),
        .write_enable(write_enable),

        .read_addr_a(reg_addr),
        .read_addr_b(4'b0000),

        .data_out_a(read_data),
        .data_out_b()
    );

    // Secuenciador de entrada
    always @(posedge clk) begin

        if (!rst_n) begin
            write_buffer <= 32'b0;
            write_data   <= 32'b0;
            write_addr   <= 4'b0;
            write_enable <= 1'b0;
        end

        else begin

            // Desactivar escritura por defecto
            write_enable <= 1'b0;

            if (ena && command == 2'b01) begin

                case (byte_sel)

                    2'b00:
                        write_buffer[7:0] <= ui_in;

                    2'b01:
                        write_buffer[15:8] <= ui_in;

                    2'b10:
                        write_buffer[23:16] <= ui_in;

                    2'b11: begin

                        write_data <= {
                            ui_in,
                            write_buffer[23:0]
                        };

                        write_addr <= reg_addr;
                        write_enable <= 1'b1;

                    end

                endcase
            end

        end
    end

    // Lectura de un byte
    reg [7:0] output_byte;

    always @(*) begin

        case (byte_sel)

            2'b00: output_byte = read_data[7:0];
            2'b01: output_byte = read_data[15:8];
            2'b10: output_byte = read_data[23:16];
            2'b11: output_byte = read_data[31:24];

            default: output_byte = 8'b0;

        endcase

    end

    assign uo_out = (ena && command == 2'b10)
                    ? output_byte : 8'b0;

    // No utilizamos los pines bidireccionales
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule

`default_nettype wire
