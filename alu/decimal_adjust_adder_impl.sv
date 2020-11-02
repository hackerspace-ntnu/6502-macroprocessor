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
