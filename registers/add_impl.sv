`timescale 1ns / 1ps
module adder_hold_register(
	input phi_2,
	input add_adl,
	input add_sb_60,
	input add_sb_7,

	input [7:0] alu_to_add,
	output [7:0] adl_bus,
	output [7:0] sb_bus);

	reg [7:0] state;

	assign adl_bus     = (add_adl   ? state      : {8{1'bz}});
	assign sb_bus[7]   = (add_sb_7  ? state[7]   : 1'bz);
	assign sb_bus[6:0] = (add_sb_60 ? state[6:0] : {7{1'bz}});

	always @ (negedge phi_2)
	begin
		state <= alu_to_add;
	end

endmodule
