`timescale 1ns / 1ps
module full_adder(
	input a,
	input b,
	input carry_in,
	output carry_out,
	output out);

	wire [2:0] bridge;

	// a ^ b
	xor(bridge[0], a, b);

	// out = (a ^ b) ^ carry_in
	xor(out, bridge[0], carry_in);

	// (a ^ b) & c
	and(bridge[1], bridge[0], carry_in);

	// a & b
	and(bridge[2], a, b);

	// carry_out = (a & b) | ((a ^ b) & c)
	or(carry_out, bridge[1], bridge[2]);

endmodule
