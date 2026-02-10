# CAD for Digital H/W (E-CAD)

🔗 **GR Ελληνική έκδοση:** [README_GR.md](README_GR.md)

## Laboratory Exercises in Digital System Design

This repository contains the complete set of laboratory exercises for the course  
**Computer-Aided Design for Digital Hardware (E-CAD)**.

The exercises cover the full digital design flow:
from **graphical schematic design and TTL simulation**,  
to **PCB back-end design**,  
and finally **HDL-based design, synthesis, timing analysis, and FPGA implementation**.

---

## 🧪 Structure and Classification of Exercises

The laboratory exercises are divided into two main categories:

### 🔹 A. Graphical Design Exercises (EA1 – EA4)
- Implemented using **OrCAD / OrCAD Express** (Windows XP environment)
- Schematic-based digital design
- Simulation performed inside the CAD tool
- Propagation delay and timing analysis
- **No HDL source code is used**

### 🔹 B. HDL & FPGA-Based Exercises (EA5 – EA8)
- Hardware description using **VHDL**
- Functional simulation with **ModelSim**
- Synthesis & implementation using **Vivado 2019.2 WebPACK**
- Hardware verification on **Basys3 (Artix-7 FPGA)**

---

## 🧪 Detailed Description of Laboratory Exercises

### 🔹 EA1 – Propagation delay analysis of TTL logic gates
- Schematic design of an AND gate (7408)
- Replacement with TTL subfamilies: 74LS08, 74S08, 74ALS08, 74AS08
- Simulation in OrCAD
- Measurement of propagation delays (0→1 and 1→0 transitions)
- Comparison of speed among different TTL technologies

---

### 🔹 EA2 – Top-Down and Bottom-Up digital design methodologies
- 2-bit multiplier implemented using a **Top-Down** approach
- Full Adder design using TTL gates
- 2-bit register implemented using a **Bottom-Up** approach
- Timing simulation and functional verification
- Fully schematic-based design in OrCAD

---

### 🔹 EA3 – PCB back-end design (placement & routing)
- Netlist generation from schematic
- Import into OrCAD Layout
- Automatic component placement
- Automatic routing on:
  - two-layer PCB (2-layer)
  - single-layer PCB (1-layer)
- Analysis of routing limitations due to circuit topology

---

### 🔹 EA4 – Hardware dongle and bidirectional bus control
- Design of a hardware dongle (hasp) for software protection
- Bidirectional data bus using tri-state buffers
- Data encoding using XS129 format (DIN + 129)
- Simulation of high-impedance (Z) bus states
- Complete PCB back-end flow:
  - footprint selection
  - netlist generation
  - 2-layer and 4-layer layouts with power/ground planes

---

### 🔹 EA5 – 4-bit and 8-bit counter in HDL
- Design of a synchronous counter in **VHDL**
- Support for parallel load, enable, and reset
- Construction of an 8-bit counter from two 4-bit blocks
- Functional simulation using **ModelSim**
- Critical path analysis and maximum frequency estimation

---

### 🔹 EA6 – Combinational circuits and 7-segment display
- VHDL implementation of:
  - 4-bit XOR circuit
  - hexadecimal number displayer (0–F)
  - unsigned and signed 2-bit multipliers
- Direct driving of the Basys3 7-segment display
- Timing analysis using Vivado
- Estimation of maximum operating frequency (fmax)

---

### 🔹 EA7 – Clocking, timing, and stopwatch system
- Sequential system implementation on FPGA
- Generation of 1Hz and 10Hz enable pulses from a 100MHz clock
- Seconds and tenths-of-a-second counters
- Multiplexed two-digit 7-segment display
- Stopwatch functionality (display freeze without stopping internal counters)
- LED “thermometer bar” for tenths indication
- Post-implementation timing analysis

---

### 🔹 EA8 – Keyboard protocol (PS/2 interface)
- Implementation of a **PS/2 keyboard protocol**
- Handling of scan codes (make / break)
- Support for numeric input and arithmetic operators (+, −, ×, ÷)
- Execution of arithmetic operations
- Multiplexed result display on 7-segment displays
- Complete design flow:
  HDL → Simulation → Synthesis → Timing → FPGA verification

---

## 🛠️ Tools & Technologies

- **OrCAD / OrCAD Express** – schematic design & simulation
- **VHDL** – hardware description language
- **ModelSim** – functional simulation
- **Vivado 2019.2 WebPACK** – synthesis, place & route, timing analysis
- **FPGA Board:** Digilent Basys3 (Artix-7, 100MHz)

---

## 📁 Repository Structure

```text
labs/
├─ EA1/ # TTL gates – propagation delay (OrCAD)
├─ EA2/ # Top-Down / Bottom-Up design
├─ EA3/ # PCB back-end design
├─ EA4/ # Hardware dongle & tri-state bus
├─ EA5/ # 4-bit / 8-bit counter (VHDL)
├─ EA6/ # Combinational logic & 7-segment display
├─ EA7/ # Clocking, timing & stopwatch
└─ EA8/ # PS/2 keyboard protocol
```

---

Each folder contains:
- schematic files or VHDL source code,
- simulation results,
- timing and utilization reports,
- a dedicated laboratory report.

---

## 📜 License
This repository is intended for **educational use only**.
