`timescale 1ns/1ps
`default_nettype none

module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
 reg ena;
 reg rst_n;
 reg [7:0] ui_in;
 reg [7:0] uio_in;

 wire [7:0] uo_out;
 wire [7:0] uio_out;
 wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
  tt_um_register_file dut (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

// Reloj: periodo de 10 ns
    always #5 clk = ~clk;

    integer i;

   initial begin
        // Inicializacion
        clk = 0;
        ena = 1;
        rst_n = 1;
        ui_in = 0;
        uio_in = 0;

        // Escribir los 8 registros
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            ui_in = 8'h10 + i;
            uio_in = 8'b00001000 | i;
            @(posedge clk);
            #1;
        end

        // Leer los 8 registros
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            uio_in = i << 4;
            #1;

            $display("Registro %0d = %h", i, uo_out);

            if (uo_out !== (8'h10 + i))
                $display("ERROR: Registro %0d", i);
            else
                $display("OK: Registro %0d", i);
        end

        $display("Prueba finalizada.");
        $finish;
    end



endmodule
