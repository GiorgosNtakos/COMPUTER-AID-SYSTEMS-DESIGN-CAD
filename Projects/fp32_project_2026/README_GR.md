# Αθροιστής Κινητής Υποδιαστολής IEEE-754 FP32 σε VHDL

Υλοποίηση αθροιστή κινητής υποδιαστολής μονής ακρίβειας IEEE-754 (FP32) (μόνο για κανονικοποιημένους αριθμούς) σε FPGA χρησιμοποιώντας VHDL και την αναπτυξιακή πλακέτα Digilent Basys3 (Artix-7).

Το project περιλαμβάνει:
- Single-cycle FP32 adder
- Δύο-stage pipelined αρχιτεκτονική
- Testbenches και verification
- Timing analysis και synthesis optimization
- Διασύνδεση MAX7219 8-digit seven-segment display
- Υλοποίηση σε FPGA

---

# Χαρακτηριστικά

## Floating-Point Arithmetic
- Υποστήριξη IEEE-754 FP32
- Εξαγωγή sign, exponent και mantissa
- Mantissa alignment
- Arithmetic σε two’s complement
- Normalization
- Zero detection

## Pipeline Architecture
- Single-cycle αρχιτεκτονική (Γ1)
- Two-stage pipeline αρχιτεκτονική (Γ2)
- Timing optimization για λειτουργία στα 100 MHz

## FPGA Hardware Support
- Basys3 Artix-7 FPGA
- MAX7219 SPI display interface
- Debounce λογική για push-buttons
- Vector ROM

---

# Δομή Φακέλων

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
```

---

# Βασικά Components
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
- Debounce κύκλωμα
- Address counter
- Vector ROM
## MAX7219 Components
- SPI sender FSM
- MAX7219 controller
- Hex-to-seven-segment decoder
- Clock divider

---

# Simulation
Τα testbenches βρίσκονται στους φακέλους:
```text
tbs/g1
tbs/g2
```

Τα simulation vectors βρίσκονται στο:
```text
vectors/vectors_clear.txt
```

Κάθε γραμμή περιέχει:
```text
OperandA OperandB ExpectedResult
```

Παράδειγμα:
```text
3f800000 40000000 40400000
```

που αντιστοιχεί σε:
```text
1.0 + 2.0 = 3.0
```

---

# FPGA Hardware Υλοποίηση
## Πλακέτα
- Digilent Basys3
- Xilinx Artix-7 FPGA
## Display
- MAX7219 8-digit seven-segment module
## Επικοινωνία
- SPI-like serial protocol
- Σήματα:
  - DIN
  -  CLK
  - CS/LOAD

---

# Timing και Synthesis

Πραγματοποιήθηκε timing analysis μέσω Vivado.

Η αρχική single-cycle αρχιτεκτονική δεν ικανοποιούσε τις timing απαιτήσεις για λειτουργία στα 100 MHz. Για το λόγο αυτό η σχεδίαση μετατράπηκε σε two-stage pipelined αρχιτεκτονική ώστε να μειωθεί το critical path delay.

---

# Εργαλεία
- VHDL
- Xilinx Vivado
- Basys3 FPGA
- MAX7219 Display Module
- ModelSim / Vivado Simulator

---

# Συντάκτες
Γιώργος Ντάκος

---

# Άδεια Χρήσης

Το project αναπτύχθηκε για ακαδημαϊκούς και εκπαιδευτικούς σκοπούς.
