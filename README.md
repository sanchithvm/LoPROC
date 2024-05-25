# LoPROC
The LoPROC is a single cycle 32-bit micro-processor with very low power consumption.
The processor is optimized from the instruction encoding stage to reduce the size and increase the performance of the instruction decoder.

## Instruction Encoding

## ALU
The ALU is based on the HACK ALU developed by Noam Nisan and Shimon Schocken.

## Multiplier
The multiplier runs on optimized add-shift algorithm. The add-shift algorithm checks all the bits and shifts when the bit is 1. This algorithm used encoder-decoder duo to check which bits are 1, and performs the shifts.

## Shifter
The shifter is a fully combinational universal logic. It can perform all the rotation, shifting operations.
