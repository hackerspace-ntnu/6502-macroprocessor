`timescale 1ns / 1ps
module program_counter_low_select(
	input pcl_pcl,
	input adl_pcl,
	
	input [7:0] pcl_bus,
	input [7:0] adl_bus,
	output [7:0] pcl_sel_to_pcl_inc);

	reg [7:0] state;

	assign state              = (pcl_pcl ? pcl_bus : {8{1'bz}}) | (adl_pcl ? adl_bus : {8{1'bz}});
	assign pcl_sel_to_pcl_inc = state;
endmodule

`timescale 1ns / 1ps
module program_counter_low_increment(
	input i_pc,
	output pclc,

	input [7:0] pcl_to_pcl_inc,
	output [7:0] pcl_sel_inc_to_pcl);

	wire [6:0] carry_bridge;

	xor(pcl_sel_inc_to_pcl[0], pcl_to_pcl_inc[0], i_pc);
	and(carry_bridge[0], pcl_to_pcl_inc[0], i_pc);

	xor(pcl_sel_inc_to_pcl[1], pcl_to_pcl_inc[1], carry_bridge[0]);
	and(carry_bridge[1], pcl_to_pcl_inc[1], carry_bridge[0]);

	xor(pcl_sel_inc_to_pcl[2], pcl_to_pcl_inc[2], carry_bridge[1]);
	and(carry_bridge[2], pcl_to_pcl_inc[2], carry_bridge[1]);

	xor(pcl_sel_inc_to_pcl[3], pcl_to_pcl_inc[3], carry_bridge[2]);
	and(carry_bridge[3], pcl_to_pcl_inc[3], carry_bridge[2]);

	xor(pcl_sel_inc_to_pcl[4], pcl_to_pcl_inc[4], carry_bridge[3]);
	and(carry_bridge[4], pcl_to_pcl_inc[4], carry_bridge[3]);

	xor(pcl_sel_inc_to_pcl[5], pcl_to_pcl_inc[5], carry_bridge[4]);
	and(carry_bridge[5], pcl_to_pcl_inc[5], carry_bridge[4]);

	xor(pcl_sel_inc_to_pcl[6], pcl_to_pcl_inc[6], carry_bridge[5]);
	and(carry_bridge[6], pcl_to_pcl_inc[6], carry_bridge[5]);

	xor(pcl_sel_inc_to_pcl[7], pcl_to_pcl_inc[7], carry_bridge[6]);
	and(pclc, pcl_to_pcl_inc[7], carry_bridge[6]);

endmodule

`timescale 1ns / 1ps
module program_counter_low_register(
	input phi_2,
	input pcl_db,
	input pcl_adl,

	input [7:0] pcl_inc_to_pcl,
	output [7:0] pcl_bus,
	output [7:0] db_bus,
	output [7:0] adl_bus);

	reg [7:0] state;

	assign pcl_bus = state;
	assign db_bus  = (pcl_db  ? state : {8{1'bz}});
	assign adl_bus = (pcl_adl ? state : {8{1'bz}});

	always @ (negedge phi_2)
	begin
		state <= pcl_inc_to_pcl;
	end

endmodule

`timescale 1ns / 1ps
module program_counter_high_select(
	input pch_pch,
	input adh_pch,

	input [7:0] pch_bus,
	input [7:0] adh_bus,
	output [7:0] pchs);

	reg [7:0] state;

	assign state = (pch_pch ? pch_bus : {8{1'bz}}) | (adh_pch  ? pch_bus : {8{1'bz}});
	assign pchs  = state;

endmodule

`timescale 1ns / 1ps
module program_counter_high_increment(
	input pclc,
	output pchc,

	input [7:0] pchs,
	output [7:0] pch_sel_inc_to_pch);

	wire [5:0] carry_bridge;

	xor(pch_sel_inc_to_pch[0], pchs[0], pclc);
	and(carry_bridge[0], pchs[0], pclc);

	xor(pch_sel_inc_to_pch[1], pchs[1], carry_bridge[0]);
	and(carry_bridge[1], pchs[1], carry_bridge[0]);

	xor(pch_sel_inc_to_pch[2], pchs[2], carry_bridge[1]);
	and(carry_bridge[2], pchs[2], carry_bridge[1]);

	xor(pch_sel_inc_to_pch[3], pchs[3], carry_bridge[2]);
	and(pchc, pchs[3], carry_bridge[2]);

	xor(pch_sel_inc_to_pch[4], pchs[4], pchc);
	and(carry_bridge[3], pchs[4], pchc);

	xor(pch_sel_inc_to_pch[5], pchs[5], carry_bridge[3]);
	and(carry_bridge[4], pchs[5], carry_bridge[3]);

	xor(pch_sel_inc_to_pch[6], pchs[6], carry_bridge[4]);
	and(carry_bridge[5], pchs[6], carry_bridge[4]);

	xor(pch_sel_inc_to_pch[7], pchs[7], carry_bridge[5]);

endmodule

`timescale 1ns / 1ps
module program_counter_high_register(
	input phi_2,
	input pch_db,
	input pch_adh,
	
	input [7:0] pch_sel_inc_to_pch,
	output [7:0] pch_bus,
	output [7:0] db_bus,
	output [7:0] adl_bus);

	reg [7:0] state;

	assign pch_bus = state;
	assign db_bus  = (pch_db  ? state : {8{1'bz}});
	assign adl_bus = (pch_adh ? state : {8{1'bz}});

	always @ (negedge phi_2)
	begin
		state <= pch_sel_inc_to_pch;
	end

endmodule
