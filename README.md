**--P1 Basic State Machine Design--**

A password set lock operation using a Mealy state machine connected with a 7-segment LED display on the DE1-SoC using a combinational logic block. 

**--P2 Basic ARM Assembly--**

Implements a binary search algorithm in ARM assembly to locate a key within an array, making use of stack operations and ARM instructions.

**--P3 RISC Datapath--**

Implements a datapath for a simple RISC (Reduced Instruction Set Computer) machine, integrating register file, ALU, and shifter modules to execute basic arithmetic and logical operations, with a status register to record special outcomes like zero results.

**--P4 RISC FSM Controller--**

Extends the datapath from P3 by integrating an FSM (Finite State Machine) controller and an instruction register, allowing for automatic execution of instructions. The FSM manages control signals and state transitions, enabling the CPU to get, decode, and execute a series of instructions stored in the instruction register.

**--P5 RISC Memory and I/O--**

Extends the simple RISC machine by adding instruction memory and a program counter to fetch and execute instructions automatically, replacing manual input through switches. It introduces LDR (load register) and STR (store register) instructions to enable reading from and writing to data memory. Additionally, the CPU is integrated with memory-mapped I/O, connecting switches and LEDs on the DE1-SoC for external device interaction.

**--P6 RISC Support Branches--**

Extends the simple RISC machine by adding conditional branch instructions, enabling constructs like loops and conditional statements with BLT (branch if less than) and BEQ (branch if equal) for dynamic control flow. It introduces function calls with the BL (branch and link) instruction and returns via the BX (branch and exchange) instruction to support modular programming.
