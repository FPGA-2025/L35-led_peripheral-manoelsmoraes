module led_peripheral(
    input  wire clk,
    input  wire rst_n,
    input  wire rd_en_i,
    input  wire wr_en_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output reg  [31:0] data_o,
    output reg  [7:0] leds_o
);

    reg [7:0] led_reg;
    wire [3:0] effective_address;

    assign effective_address = addr_i[3:0]; // só usa os últimos 4 bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            led_reg <= 8'b0;
        end else if (wr_en_i && effective_address == 4'h0) begin
            led_reg <= data_i[7:0]; // apenas os 8 bits menos significativos
        end
    end

    always @(*) begin
        if (rd_en_i && effective_address == 4'h4) begin
            data_o = {24'b0, led_reg}; // extensão para 32 bits
        end else begin
            data_o = 32'b0;
        end
    end

    always @(*) begin
        leds_o = led_reg;
    end
endmodule
