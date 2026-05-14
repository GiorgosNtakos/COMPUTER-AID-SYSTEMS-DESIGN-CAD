# IEEE-754 FP32 Floating-Point Adder in VHDL

🔗 **GR Ελληνική έκδοση:** [README_GR.md](README_GR.md)

FPGA implementation of an IEEE-754 single-precision floating-point adder(only for normalized numbers) using VHDL on the Digilent Basys3 (Artix-7) FPGA development board.

The project includes:
- Single-cycle FP32 adder
- Two-stage pipelined FP32 adder
- Simulation and verification testbenches
- Timing analysis and synthesis optimization
- MAX7219 8-digit seven-segment display interface
- FPGA hardware implementation

---

# Features

## Floating-Point Arithmetic
- IEEE-754 FP32 support
- Sign, exponent, and mantissa extraction
- Mantissa alignment
- Two’s complement arithmetic
- Normalization and rounding support
- Zero detection

## Pipeline Architecture
- Single-cycle architecture (G1)
- Two-stage pipelined architecture (G2)
- Timing optimization for 100 MHz operation

## FPGA Hardware Support
- Basys3 Artix-7 FPGA
- MAX7219 SPI display interface
- Push-button debounce logic
- Vector ROM support

---

# Project Structure

```text
project_fp32/
│
├── components/
│   │
│   ├── core components/
│   │   ├── g1 add core/
│   │   └── global/
│   │
│   ├── FPGA Control Components/
│   │   ├── g3/
│   │   └── global/
│   │
│   ├── MAX7219 Control Components/
│   │
│   └── Top Wrappers Levels/
│       ├── g1/
│       ├── g2/
│       ├── g3/
│       └── g4/
│
├── tbs/
│   ├── g1/
│   └── g2/
│
├── vectors/
│   ├── vectors.hex
│   └── vectors_clear.txt
│
├── xdc/
│   ├── constraints.xdc
│   └── constraints_max7219.xdc
│
└── fp32_vivado_project/
```
---
# Main Components
## Core FP32 Components
- fp32_unpack.vhd
- fp32_align.vhd
- fp32_signmag_to_tc.vhd
- fp32_tc_add.vhd
- fp32_tc_to_signmag.vhd
- fp32_lod.vhd
- fp32_normalize.vhd
- fp32_pack.vhd
## FPGA Control Components
- Debounce circuit
- Address counter
- Vector ROM
## MAX7219 Components
- SPI sender FSM
- MAX7219 controller
- Hex-to-seven-segment decoder
- Clock divider
  
---

# Simulation

## Testbenches are located inside:

```text
tbs/g1
tbs/g2
```

Simulation vectors are stored in:

```text
vectors/vectors_clear.txt
```

Each vector line contains:

```text
OperandA OperandB ExpectedResult
```

Example:

```text
3f800000 40000000 40400000
```

which corresponds to:

```text
1.0 + 2.0 = 3.0
```

---

# FPGA Hardware Implementation
## Board
- Digilent Basys3
- Xilinx Artix-7 FPGA
## Display
- MAX7219 8-digit seven-segment module
## Communication
- SPI-like serial protocol
- Signals:
  - DIN
  - CLK
  - CS/LOAD

---

# Τiming and Synthesis

Timing analysis was performed using Vivado.

The original single-cycle architecture exceeded the timing requirements for 100 MHz operation. The design was therefore converted into a two-stage pipeline architecture in order to reduce the critical path delay.

---

# Tools Used
- VHDL
- Xilinx Vivado
- Basys3 FPGA
- MAX7219 Display Module
- ModelSim / Vivado Simulator

---

# Authors
Giorgos Ntakos

---

# License
This project was developed for academic and educational purposes.
