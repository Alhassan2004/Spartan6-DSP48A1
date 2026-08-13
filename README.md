# Spartan-6 DSP48A1 RTL Design & Verification

## Overview

This project implements a **Spartan-6 DSP48A1 slice** using **Verilog HDL**. The design models the internal datapath of the DSP48A1, including input registers, pre-adder/subtractor, multiplier, post-adder/subtractor, cascade paths, carry logic, and configurable pipeline stages.

The design was verified using a **self-checking testbench in QuestaSim** and taken through the **Vivado FPGA design flow**, including elaboration, synthesis, implementation, timing analysis, and linting.

---

## Project Structure

```text
DSP48A1/
│
├── RTL/
│   ├── Reg_Mux.v
│   └── DSP.v
│
├── Testbench/
│   └── DSP_TB.v
│
├── Simulation/
│   └── DSP.do
│
├── Constraints/
│   └── DSP.xdc
│
└── README.md
```

### RTL Files

**`Reg_Mux.v`**

Parameterized register/multiplexer used to implement the configurable pipeline registers.

**`DSP.v`**

Top-level DSP48A1 implementation containing the complete datapath and control logic.

**`DSP_TB.v`**

Self-checking testbench used to verify reset operation and multiple DSP datapaths.

**`DSP.do`**

QuestaSim DO file used to compile, simulate, add waveform groups, and run the simulation.

---

## Configuration Parameters

The DSP48A1 module provides configurable parameters for pipeline stages and input selection:

| Parameter     | Description                |     Default |
| ------------- | -------------------------- | ----------: |
| `A0REG`       | First A pipeline register  |         `0` |
| `A1REG`       | Second A pipeline register |         `1` |
| `B0REG`       | First B pipeline register  |         `0` |
| `B1REG`       | Second B pipeline register |         `1` |
| `CREG`        | C input register           |         `1` |
| `DREG`        | D input register           |         `1` |
| `MREG`        | Multiplier output register |         `1` |
| `PREG`        | P output register          |         `1` |
| `CARRYINREG`  | Carry-in register          |         `1` |
| `CARRYOUTREG` | Carry-out register         |         `1` |
| `OPMODEREG`   | OPMODE register            |         `1` |
| `CARRYINSEL`  | Carry-in source            | `"OPMODE5"` |
| `B_INPUT`     | B input source             |  `"DIRECT"` |
| `RSTTYPE`     | Reset type                 |    `"SYNC"` |

These parameters control the number of pipeline stages and configurable datapath selections.

---

## Verification

The design was verified using a **self-checking Verilog testbench** in QuestaSim.

The testbench verifies:

### 1. Reset Operation

All reset inputs are asserted and the testbench checks that the main outputs are cleared to zero.

### 2. DSP Path 1

```text
A = 20
B = 10
D = 25
C = 350
OPMODE = 11011101
```

Expected results include:

```text
P      = 0x32
M      = 0x12C
BCOUT  = 0xF
PCOUT  = 0x32
CARRYOUT = 0
```

### 3. DSP Path 2

```text
OPMODE = 00010000
```

Expected:

```text
P      = 0
M      = 0x2BC
BCOUT  = 0x23
PCOUT  = 0
CARRYOUT = 0
```

### 4. DSP Path 3

```text
OPMODE = 00001010
```

The testbench checks the P/PCOUT relationship, multiplier output, B cascade output, and carry outputs.

### 5. DSP Path 4

```text
A = 5
B = 6
D = 25
C = 350
PCIN = 3000
OPMODE = 10100111
```

The expected outputs and carry behavior are checked automatically.

The testbench terminates with:

```text
All Tests Passed
```

confirming that all directed verification cases passed successfully.

---

## QuestaSim Simulation

The project includes a QuestaSim DO file that:

1. Creates the simulation library
2. Compiles the Verilog source files
3. Starts the testbench
4. Adds input/output signals to the waveform
5. Runs the simulation
6. Automatically zooms the waveform

The simulation verified the reset operation and four directed DSP datapaths without logical errors.

---

## Vivado Design Flow

The design was taken through the following FPGA design flow:

```text
Verilog RTL
    │
    ▼
Elaboration
    │
    ▼
Synthesis
    │
    ▼
Implementation
    │
    ▼
Timing / Utilization Analysis
```

The project includes:

* Elaboration schematic
* Synthesis schematic
* Implementation results
* Utilization report
* Timing report
* Messages showing no critical errors
* Linting results

The project uses a **100 MHz clock constraint** on the Basys 3 clock pin `W5`. 

---

## Clock Constraint

The XDC file defines a 100 MHz clock:

## Linting

The RTL was linted using the default methodology and goals.

**Result:** No linting errors were reported.

---

## Tools Used

* **Verilog HDL** — RTL design
* **QuestaSim** — Functional simulation and verification
* **Vivado** — Elaboration, synthesis, implementation, timing and utilization analysis
* **QuestaLint** — RTL design checks
* **XDC** — Timing and FPGA constraints

---
