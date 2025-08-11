module core_top #(
    parameter MEMORY_FILE = "programa.txt",
    parameter MEMORY_SIZE = 4096
)(
    input  wire        clk,
    input  wire        rst_n,
    output wire [7:0]  leds
);

    // Sinais de interconexão
    wire        rd_en;
    wire        wr_en;
    wire [31:0] addr;
    wire [31:0] write_data;
    wire [31:0] read_data;

    // Memória
    wire        mem_rd_en;
    wire        mem_wr_en;
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;
    wire [31:0] mem_read_data;

    // Periférico
    wire        periph_rd_en;
    wire        periph_wr_en;
    wire [31:0] periph_addr;
    wire [31:0] periph_write_data;
    wire [31:0] periph_read_data;

    // Instanciação do núcleo
    core core (
        .clk(clk),
        .rst_n(rst_n),
        .rd_en_o(rd_en),
        .wr_en_o(wr_en),
        .addr_o(addr),
        .data_o(write_data),
        .data_i(read_data)
    );

    // Barramento
    bus_interconnect bus (
        .proc_rd_en_i(rd_en),
        .proc_wr_en_i(wr_en),
        .proc_addr_i(addr),
        .proc_data_i(write_data),
        .proc_data_o(read_data),

        .mem_rd_en_o(mem_rd_en),
        .mem_wr_en_o(mem_wr_en),
        .mem_addr_o(mem_addr),
        .mem_data_o(mem_write_data),
        .mem_data_i(mem_read_data),

        .periph_rd_en_o(periph_rd_en),
        .periph_wr_en_o(periph_wr_en),
        .periph_addr_o(periph_addr),
        .periph_data_o(periph_write_data),
        .periph_data_i(periph_read_data)
    );

    // Memória (deve ser chamada de `mem`)
    Memory #(
        .MEMORY_FILE(MEMORY_FILE),
        .MEMORY_SIZE(MEMORY_SIZE)
    ) mem (
        .clk(clk),
        .rd_en_i(mem_rd_en),
        .wr_en_i(mem_wr_en),
        .addr_i(mem_addr),
        .data_i(mem_write_data),
        .data_o(mem_read_data)
    );

    // Periférico de LEDs
    led_peripheral leds_periph (
        .clk(clk),
        .rst_n(rst_n),
        .rd_en_i(periph_rd_en),
        .wr_en_i(periph_wr_en),
        .addr_i(periph_addr),
        .data_i(periph_write_data),
        .data_o(periph_read_data),
        .leds_o(leds)
    );
endmodule
