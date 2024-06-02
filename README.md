# LoPROC
The LoPROC is a single cycle 32-bit micro-processor with very low power consumption.
The processor is optimized from the instruction encoding stage to reduce the size and increase the performance of the instruction decoder.

## Instruction Encoding
There are 2 types of instructions:
1. N-Type - Normal Type: These are instructions performed on register/ memory values.
2. I-Type - Immediate Type: These instructions are performed on immediate values.

The values for the instructions are chosen such that the decoding logic is not complex.
### N-Type
![image](https://github.com/sanchithvm/LoPROC/assets/75156759/1bc5743b-72bc-49bf-8460-724fbda3b72a)
SRC2-sel will be 0 for N-type Instructions

### I-Type
![image](https://github.com/sanchithvm/LoPROC/assets/75156759/2d3bc616-7025-46f3-a216-712313bd126d)
SRC2-sel will be 1 for I-type instructions

<b>MODE:</b>
1. 00 - Memory operations/ Jump/ Function calls
2. 01 - Shift/ Rotate Operations
3. 10 - Multiplication
4. 11 - ALU Operations

## ALU
The ALU is based on the HACK ALU developed by Noam Nisan and Shimon Schocken.

### PSW
![image](https://github.com/sanchithvm/LoPROC/assets/75156759/d2575d9b-e107-4d2a-aa47-404aee4d6b79)
1. INT: Sets when Interrupt occurs
2. SE: Sets when stack is empty
3. SF: Sets when stack is full
4. DBZ: Sets when there is a division by zero
5. Z: Zero - Sets when ALU output is zero
6. N: Negative - Sets when ALU output is negative
7. ODD: Sets when ALU output is odd
8. P: Parity flag – sets when ALU output has odd number of 1s
9. OV: Overflow – sets when overflow occurs
10. C: Carry – sets when there is a carry
11. User: User flag – can be defined by user
12. IE: Interrupt Enable – Needs to be set to enable interrupt
13. RS1, RS0: Register Bank Select – Selects one out of the four register banks
14. 2 flags are reserved


## Multiplier
The multiplier runs on optimized add-shift algorithm. The add-shift algorithm checks all the bits and shifts when the bit is 1. This algorithm used encoder-decoder duo to check which bits are 1, and performs the shifts.

## Shifter
The shifter is a fully combinational universal logic. It can perform all the rotation, shifting operations.
