// This is a modified binary full adder
//
// Normal full adder:
//// output    = (A ^ B) ^ carry_in
//// carry_out = (A & B) | (A ^ B) & carry_in
//
// The modified version expands (A ^ B) to (A | B) & ~(A & B)
// This is done to integrate (A | B) into the circuit, such that
// every alu operation, except right shift, is implemented in
// the full adder.
//
// Modified full adder:
//// output    = ((A | B) & ~(A & B)) ^ carry_in
//// carry_out = (A & B) | ((A | B) & ~(A & B)) & carry_in

`timescale 1ns / 1ps
module alu_full_adder(
	input a,
	input b,
	input carry_in,
	output and_w,
	output or_w,
	output xor_w,
	output out,
	output carry_out);

	wire not_and_bridge;
	wire and_or_bridge;

	// and_w, or_w: A & B, A | B
	and(and_w, a, b);
	or(or_w, a, b);

	// xor_w: (A | B) & ~(A & B)
	not(not_and_bridge, and_w);
	and(xor_w, not_and_bridge, or_w);

	// out: (A ^ B) ^ C
	xor(out, xor_w, carry_in);

	// carry_out: (A & B) | (A ^ B) & c
	and(and_or_bridge, xor_w, carry_in);
	or(carry_out, and_w, and_or_bridge);

endmodule

`timescale 1ns / 1ps
module wide_or(
	output [7:0] out,
	input [7:0] a,
	input [7:0] b);

	or(out[0], a[0], b[0]);
	or(out[1], a[1], b[1]);
	or(out[2], a[2], b[2]);
	or(out[3], a[3], b[3]);
	or(out[4], a[4], b[4]);
	or(out[5], a[5], b[5]);
	or(out[6], a[6], b[6]);
	or(out[7], a[7], b[7]);

endmodule

`timescale 1ns / 1ps
module wide_and(
	output [7:0] out,
	input [7:0] a,
	input [7:0] b);

	and(out[0], a[0], b[0]);
	and(out[1], a[1], b[1]);
	and(out[2], a[2], b[2]);
	and(out[3], a[3], b[3]);
	and(out[4], a[4], b[4]);
	and(out[5], a[5], b[5]);
	and(out[6], a[6], b[6]);
	and(out[7], a[7], b[7]);

endmodule

module carry_adjust(
	output adjusted_carry,
	input carry,
	input daa,
	input [3:0] nibble);

	wire [2:0] bridge;

	or(bridge[0], nibble[1], nibble[2]);   // Bit 1 || 2
	and(bridge[1], nibble[3], bridge[0]);  // Bit 3 && (1 || 2) => nibble >= 0xA
	and(bridge[2], daa, bridge[1]);        // nibble >= 0xA && daa

	or(adjusted_carry, carry, bridge[2]);  // carry || nibble >= A && daa

endmodule

`timescale 1ns / 1ps
module alu(
	input [7:0] a,
	input [7:0] b,
	input i_addc,
	input daa,
	input sums,
	input ands,
	input ors,
	input eors,
	input srs,
	output [7:0] out,
	output acr,
	output hc,
	output avr);

	wire [7:0] sum_w;
	wire [7:0] and_w;
	wire [7:0] or_w;
	wire [7:0] xor_w;
	wire [7:0] sr_w;
	wire [7:0] carry_bridge;

	wire [7:0] output_select_0;
	wire [7:0] output_select_1;
	wire [7:0] output_select_2;
	wire [7:0] output_select_3;
	wire [7:0] output_select_4;
	wire [7:0] output_select_01;
	wire [7:0] output_select_23;
	wire [7:0] output_select_0123;
	wire sums_carry_adjusted, carry_select_and_or_bridge_sums, carry_select_and_or_bridge_srs;
	wire avr_not_and_bridge, avr_xor_and_bridge;

	// Lower 4-bit full adder
	alu_full_adder full_adder_0 (a[0], b[0], i_addc,          and_w[0], or_w[0], xor_w[0], sum_w[0], carry_bridge[0]);
	alu_full_adder full_adder_1 (a[1], b[1], carry_bridge[0], and_w[1], or_w[1], xor_w[1], sum_w[1], carry_bridge[1]);
	alu_full_adder full_adder_2 (a[2], b[2], carry_bridge[1], and_w[2], or_w[2], xor_w[2], sum_w[2], carry_bridge[2]);
	alu_full_adder full_adder_3 (a[3], b[3], carry_bridge[2], and_w[3], or_w[3], xor_w[3], sum_w[3], carry_bridge[3]);

	// Half carry
	// This line is raised if there was a carry between the lower and higher
	// 4 bits in the full adder, or if daa is high and the lower nibble is
  // greater than 9
	carry_adjust hc_adjust (hc, carry_bridge[3], daa, sum_w[3:0]);

	// Higher 4-bit full adder
	alu_full_adder full_adder_4 (a[4], b[4], hc,              and_w[4], or_w[4], xor_w[4], sum_w[4], carry_bridge[4]);
	alu_full_adder full_adder_5 (a[5], b[5], carry_bridge[4], and_w[5], or_w[5], xor_w[5], sum_w[5], carry_bridge[5]);
	alu_full_adder full_adder_6 (a[6], b[6], carry_bridge[5], and_w[6], or_w[6], xor_w[6], sum_w[6], carry_bridge[6]);
	alu_full_adder full_adder_7 (a[7], b[7], carry_bridge[6], and_w[7], or_w[7], xor_w[7], sum_w[7], carry_bridge[7]);

	// Shift right
	assign sr_w[7] = i_addc;
	assign sr_w[6] = a[7];
	assign sr_w[5] = a[6];
	assign sr_w[4] = a[5];
	assign sr_w[3] = a[4];
	assign sr_w[2] = a[3];
	assign sr_w[1] = a[2];
	assign sr_w[0] = a[1];

	// Carry
	// This line is raised if there was a carry from the 7th bit or if daa is high and the lower nibble is
  // greater than 9
	carry_adjust sums_adjust (sums_carry_adjusted, carry_bridge[7], daa, sum_w[7:4]);
	and(carry_select_and_or_bridge_sums, sums_carry_adjusted, sums);
	and(carry_select_and_or_bridge_srs, a[0], srs);
	or(acr, carry_select_and_or_bridge_sums, carry_select_and_or_bridge_srs);

	// Output select
	wide_and out_select_0 (output_select_0, sum_w, {8{sums}});
	wide_and out_select_1 (output_select_1, and_w, {8{ands}});
	wide_and out_select_2 (output_select_2, or_w,  {8{ors}});
	wide_and out_select_3 (output_select_3, xor_w, {8{eors}});
	wide_and out_select_4 (output_select_4, sr_w,  {8{srs}});

	wide_or out_select_01   (output_select_01,   output_select_0,    output_select_1);
	wide_or out_select_23   (output_select_23,   output_select_2,    output_select_3);
	wide_or out_select_0123 (output_select_0123, output_select_01,   output_select_23);
	wide_or out_select      (out,                output_select_0123, output_select_4);

	// Overflow
	// This line is raised if the sign of A and B, most significant bit, are
	// equal, and different from the sign of the output
	// avr = ~(A[7] ^ B[7]) & (A[7] ^ sum_w[7])
	not(avr_not_and_bridge, xor_w[7]);
	xor(avr_xor_and_bridge, a[7], sum_w[7]);
	and(avr, avr_not_and_bridge, avr_xor_and_bridge);

endmodule

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

`timescale 1ns / 1ps
module decimal_adjust_adder(
	input dsa,
	input daa,
	input hc,
	input acr,
	input [7:0] sb,
	output [7:0] sb_ac);

	wire hc_bar, acr_bar;
	wire daa_and_hc, daa_and_acr;
	wire dsa_and_hc_bar, dsa_and_acr_bar;
	wire bit_2_adjust, bit_5_adjust;
	wire [5:0] carry_bridge;
	wire [1:0] bridge;
	
	// daa & hc, daa & acr
	and(daa_and_hc, daa, hc);
	and(daa_and_acr, daa, acr);

	// dsa & ~hc, dsa & ~acr
	not(hc_bar, hc);
	not(acr_bar, acr);
	and(dsa_and_hc_bar, dsa, hc_bar);
	and(dsa_and_acr_bar, dsa, acr_bar);

	or(bit_2_adjust, daa_and_hc, dsa_and_hc_bar);
	or(bit_5_adjust, daa_and_acr, dsa_and_acr_bar);

	// 4 bit full adder
	// add (dsa & ~hc) << 3 | (daa & hc) << 2 | (dsa & ~hc | daa & hc) << 1 | 0
	assign sb_ac[0] = sb[0];
	xor(sb_ac[1], sb[1], bit_2_adjust);
	and(carry_bridge[0], sb[1], bit_2_adjust);
	full_adder adder_0 (sb[2], daa_and_hc, carry_bridge[0], carry_bridge[1], sb_ac[2]);
	xor(bridge[0], sb[3], dsa_and_hc_bar);
	xor(sb_ac[3], bridge[0], carry_bridge[1]);

	// 4 bit full adder
	// add (dsa & ~acr) << 3 | (daa & acr) << 2 | (dsa & ~acr | daa & acr) << 1 | 0
	assign sb_ac[4] = sb[4];
	xor(sb_ac[5], sb[5], bit_5_adjust);
	and(carry_bridge[2], sb[5], bit_5_adjust);
	full_adder adder_1 (sb[6], daa_and_acr, carry_bridge[2], carry_bridge[3], sb_ac[6]);
	xor(bridge[1], sb[7], dsa_and_hc_bar);
	xor(sb_ac[7], bridge[1], carry_bridge[3]);

endmodule
