**P1 Combinational Logic and State Machine Design**

p1_top.v

*p1_top_tb.v*

A password set lock operation using a Mealy state machine connected with a 7-segment LED display on the DE1-SoC using a combinational logic block. 

**P2 ARM Assembly Programming**

p2_top.s

Implements a binary search algorithm in ARM assembly to locate a key within an array, making use of stack operations and ARM instructions.

**P3 Datapath for the Simple RISC Machine**

p3_datapath.v, p3_alu.v, p3_regfile.v, p3_shifter.v

*p3_datapath_tb.v, p3_alu_tb.v, p3_regfile_tb.v, p3_shifter_tb.v*

Implements a datapath for a simple RISC (Reduced Instruction Set Computer) machine, integrating register file, ALU, and shifter modules to execute basic arithmetic and logical operations, with a status register to record special outcomes like zero results.

**P4 Finite State Machine Controller for the Simple RISC Machine**

p4_cpu.v, p4_datapath.v, p4_alu.v, p4_regfile.v, p4_shifter.v

*p4_cpu_tb.v*

Extends the datapath from P3 by integrating an FSM (Finite State Machine) controller and an instruction register, allowing for automatic execution of instructions. The FSM manages control signals and state transitions, enabling the CPU to get, decode, and execute a series of instructions stored in the instruction register.

**P5 Adding Memory and IO to the Simple RISC Machine**

**P6 Supporting Branches in the Simple RISC Machine**
