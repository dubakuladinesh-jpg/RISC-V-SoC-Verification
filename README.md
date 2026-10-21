# Low-Power PicoRV32 RISC-V SoC with Clock-Gated I2C Master

A synthesizable, hardware-deterministic System-on-Chip (SoC) coupling Claire Wolf's **PicoRV32** RISC-V CPU core to a custom **I2C Master Controller** via a dedicated Memory-Mapped I/O (MMIO) interconnect. Designed and targeted for the **AMD/Xilinx Artix-7 (xc7a35tcpg236-1)** architecture.

## Architecture Highlights
- **CPU Core:** 32-bit RISC-V (RV32I base integer instruction set).
- **Embedded Storage:** 1 KB localized dual-port equivalent block memory with pre-flashed machine bytecode. Reduces physical package pin requirements from 107 down to 4 pins (`clk`, `resetn`, `scl`, `sda`).
- **Clock Management:** Implements dynamic hardware clock gating using Xilinx `BUFGCE` primitives to shut down peripheral clock tree oscillation during idle intervals.

## Synthesis & Implementation Metrics (Artix-7 xc7a35tcpg236-1)

| Metric | Non-Clock-Gated Baseline | Clock-Gated Architecture | Delta / Savings |
| :--- | :--- | :--- | :--- |
| **Target Clock** | 50.0 MHz (20.0 ns) | 50.0 MHz (20.0 ns) | Clean closure |
| **Worst Setup Slack (WNS)** | +8.758 ns | +11.747 ns | +2.989 ns margin |
| **Worst Hold Slack (WHS)** | Closed post-route | Closed post-route | No physical violations |
| **BUFG / BUFGCTRL** | 1 | 2 (`BUFG` + `BUFGCE`) | +1 primitive |
| **Total IOB Utilization** | 4 / 106 (3.77%) | 4 / 106 (3.77%) | Zero package overflow |
| **Peripheral Clock Power** | Continuous toggling | Suppressed during IDLE | Measurable dynamic saving |

## MMIO Memory Map
- `0x0000_0000 - 0x0000_03FF`: Internal Firmware Execution Space (1 KB BRAM)
- `0x3000_0000`: I2C Control/Status Register (`[0]` Start, `[1]` Busy, `[2]` Done)
- `0x3000_0004`: I2C 7-bit Slave Address Register (`[6:0]` Target Address)
- `0x3000_0008`: I2C Data Payload Register (`[7:0]` Transmit Byte)

## Simulation & Reproduction
1. Open Vivado 2024.x/2025.x and create a project targeting `xc7a35tcpg236-1`.
2. Add all files in `/rtl` as Design Sources.
3. Add `tb_picorv32_i2c.v` as Simulation Source.
4. Add `constraints.xdc` as Constraints.
5. Run Behavioral Simulation for 25 µs to inspect `i2c_gated_clk` and SDA/SCL transactions.
6. Run Implementation to verify post-route timing closure and power breakdown.
