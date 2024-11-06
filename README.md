# Project Overview: DE1-SoC RISC Machine and ARM Assembly

This project explores fundamental concepts in digital design and computer architecture, implemented on the DE1-SoC board. Each phase builds upon the previous, progressively enhancing a basic RISC architecture and showcasing ARM assembly techniques.

## Project Phases

### P1: Basic State Machine Design

This phase introduces a password-protected lock mechanism using a Mealy state machine, paired with a 7-segment LED display on the DE1-SoC. The design uses combinational logic to validate input sequences and display states.

### P2: ARM Assembly - Binary Search

Implements a binary search algorithm in ARM assembly to locate a specific key within an array. This phase leverages stack operations and ARM instructions, reinforcing low-level understanding of data handling in ARM architecture.

### P3: RISC Datapath

Develops a simplified RISC (Reduced Instruction Set Computer) datapath by integrating a register file, ALU, and shifter modules. This module performs basic arithmetic and logical operations, utilizing a status register to record outcomes, such as zero results.

### P4: RISC FSM Controller

Extends the RISC datapath by adding a Finite State Machine (FSM) controller and an instruction register, allowing for automatic instruction execution. The FSM orchestrates control signals and state transitions, enabling the CPU to fetch, decode, and execute stored instructions autonomously.

### P5: RISC Memory and I/O Integration

Enhances the RISC machine with instruction memory and a program counter, automating instruction fetch and execution. LDR (load register) and STR (store register) instructions enable interaction with data memory, and memory-mapped I/O connects the CPU to DE1-SoC switches and LEDs, facilitating external device interaction.

### P6: Branching and Function Support in RISC

Introduces conditional branching to the RISC machine, supporting loops and conditional logic through BLT (branch if less than) and BEQ (branch if equal) instructions. Adds modular programming capabilities with BL (branch and link) for function calls and BX (branch and exchange) for returns, enabling more dynamic control flow.
