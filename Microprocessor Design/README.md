# Microprocessor Design

This is an implementation of a 32-bit single cycle processor that takes in one instruction per clock cycle and has the ability to perform 9 MIPS instruction (add, sub, addi, sw, lw, beq, j, and, or). 

Code_mem generates data in the form of an instruction (32 bits), the bits of the instructions are processed by various components of the processor. The instruction bits are carried into the ALU and the appropriate register. The result is then sent to Data Memory and is written into an appropriate register. 

# Components

### Register8mod: 
  an 8-bit register designed from the component bit storage, which takes one bit of data at a time and use it to output 8-bit from the register. 
  
### Register32mod: 
  by the same logic the 8-bit register was designed, this is an implementation of a 32-bit register composed of four 8-bit registers. 
  
### Shift Register:
  the shift register takes three bits of data as an input (one for direction and two for shift amount) and shifts it by up to 3 bits. 

### Control:  
  the control used the registers and multiplexers to decide which helps steer the ALU to certain operations instructed by part of the code to do output the correct   output. 
  
### Code_mem:
  generates instructions to be processed by the microprocessor. 
  
### ProcRegister: 
  32-bits registers are created in this file, then bits are shifted to the left or right, added, or subtracted.
 
### ProcElements:
  in ProcElements, Control gets the opcode from the instruction as and outputs a value that is used to select muxes or other compoenents depending on the opcode. 
  In order to do specific operations, Registers select the appropriate registers to pass data from to the ALU. The ALU is responsible for operations such as
  addition or subtraction and the ALUControl for choosing what operation to perform based on the instruction and the 2-bit output from Control. 2x1 multiplexers
  assist in choosing the write option for certain operations. Data_mem stores data outputted by the ALU and ADD_ALU 
  performes add operations. 
  
  
# Testing
  Code_mem is our testbench. It contains 16 instructions, which the processor will take one instruction per clock cycle.
  
