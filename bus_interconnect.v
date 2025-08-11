module bus_interconnect (
    // sinais vindos do processador
    input   wire proc_rd_en_i,
    input   wire proc_wr_en_i,
    output  wire [31:0] proc_data_o,
    input   wire [31:0] proc_addr_i,
    input   wire [31:0] proc_data_i,

    //sinais para a memória
    output  wire mem_rd_en_o,
    output  wire mem_wr_en_o,
    input   wire [31:0] mem_data_i,
    output  wire [31:0] mem_addr_o,
    output  wire [31:0] mem_data_o,

    //sinais para o periférico
    output  wire periph_rd_en_o,
    output  wire periph_wr_en_o,
    input   wire [31:0] periph_data_i,
    output  wire [31:0] periph_addr_o,
    output  wire [31:0] periph_data_o
);

    wire is_peripheral = (proc_addr_i[31:28] == 4'h8);

    // Roteia os sinais
    assign mem_rd_en_o      = proc_rd_en_i  && !is_peripheral;
    assign mem_wr_en_o      = proc_wr_en_i  && !is_peripheral;
    assign mem_addr_o       = proc_addr_i;
    assign mem_data_o       = proc_data_i;

    assign periph_rd_en_o   = proc_rd_en_i  && is_peripheral;
    assign periph_wr_en_o   = proc_wr_en_i  && is_peripheral;
    assign periph_addr_o    = proc_addr_i;
    assign periph_data_o    = proc_data_i;

    // Multiplexador para ler dados da fonte correta
    assign proc_data_o = is_peripheral ? periph_data_i : mem_data_i;
endmodule
