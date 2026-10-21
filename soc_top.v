// Top-Level RISC-V SoC Integration
// Integrates PicoRV32 core with MMIO Smart I2C/SPI masters and clock gaters

module soc_top (
    input  wire clk,
    input  wire resetn,
    
    // External SPI Interface
    output wire spi_sck,
    output wire spi_mosi,
    input  wire spi_miso,
    output wire spi_csn,

    // External I2C Interface
    inout  wire i2c_sda,
    inout  wire i2c_scl
);

    // Internal bus signals
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    wire        mem_valid;
    wire        mem_ready;
    wire [31:0] mem_rdata;

    // Interrupt signals
    wire [31:0] irq;
    wire        spi_irq;
    wire        i2c_irq;
    assign irq = {30'b0, spi_irq, i2c_irq};

    // Autonomous Clock Gating logic for power states
    wire clk_gated_spi;
    wire clk_gated_i2c;
    
    // Clock Gater Instantiation
    clock_gater cg_spi (.clk_in(clk), .en(mem_valid && (mem_addr[31:16] == 16'h4000)), .clk_out(clk_gated_spi));
    clock_gater cg_i2c (.clk_in(clk), .en(mem_valid && (mem_addr[31:16] == 16'h5000)), .clk_out(clk_gated_i2c));

    // 32-bit RISC-V Core (PicoRV32)
    picorv32 core (
        .clk(clk),
        .resetn(resetn),
        .mem_valid(mem_valid),
        .mem_ready(mem_ready),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata),
        .irq(irq)
    );

    // MMIO Smart SPI Master (Mapped at 0x4000_0000)
    spi_master_mmio spi_ctrl (
        .clk(clk_gated_spi), .resetn(resetn),
        .bus_valid(mem_valid), .bus_addr(mem_addr), .bus_wdata(mem_wdata), 
        .bus_wstrb(mem_wstrb), .bus_rdata(mem_rdata), .bus_ready(mem_ready),
        .spi_sck(spi_sck), .spi_mosi(spi_mosi), .spi_miso(spi_miso), .spi_csn(spi_csn),
        .irq(spi_irq)
    );

    // MMIO Smart I2C Master (Mapped at 0x5000_0000)
    i2c_master_mmio i2c_ctrl (
        .clk(clk_gated_i2c), .resetn(resetn),
        .bus_valid(mem_valid), .bus_addr(mem_addr), .bus_wdata(mem_wdata), 
        .bus_wstrb(mem_wstrb), .bus_rdata(mem_rdata), .bus_ready(mem_ready),
        .i2c_sda(i2c_sda), .i2c_scl(i2c_scl),
        .irq(i2c_irq)
    );
    
    // Note: TinyML delta-variance predictor module would be instantiated here
    // and mapped to a specific MMIO address range for co-verification.

endmodule
