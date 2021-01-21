`timescale 1ns / 1ps
module tb_alu;

	integer SUMS = 5'b00001;
	integer ANDS = 5'b00010;
	integer ORS  = 5'b00100;
	integer EORS = 5'b01000;
	integer SRS  = 5'b10000;

	reg[7:0] a, b;
	reg[4:0] control_signal;

	reg i_addc;
	reg daa;
	reg dsa;

	wire [7:0] sb;
	wire [7:0] sb_ac;
	wire acr;
	wire hc;
	wire avr;

	alu alu_test_unit (a, b, i_addc, daa, control_signal[0], control_signal[1], control_signal[2], control_signal[3], control_signal[4], sb, acr, hc, avr);
	decimal_adjust_adder decimal_adjust_adder_test_unit (dsa, daa, hc, acr, sb, sb_ac);

	integer i, j, k;
	integer eax, ebx, ecx, edx;

	integer should_test_binary = 0;
	integer failed_binary      = 0;
	integer failed_decimal     = 0;

	task TestDecimal(
		input should_add, // Is this ADC or SBC?
		input [7:0] a_val,
		input [7:0] b_val,
		input carry_in,
		input [7:0] expected_result,
		input expected_overflow,
		input expected_carry);
	begin
		a <= a_val;

		if (should_add)
		begin
			daa <= 1'b1;
			dsa <= 1'b0;
			b   <= b_val;
		end

		else
		begin
			daa <= 1'b0;
			dsa <= 1'b1;
			b   <= (~b_val) & 8'hFF;
		end

		control_signal <= SUMS;
		i_addc         <= carry_in;
	 

		#1

		if (sb_ac == expected_result /*&& avr == expected_overflow*/ &&
				acr == expected_carry)
		begin
			/*$display("Passed %0d %s %0d with a = %0d, b = %0d and i_addc = %0d",
								a_val, (should_add ? "+" : "-"), b_val, a, b, i_addc);*/
		end

		else
		begin
			$display("Failed %0d %s %0d with i_addc = %0d", a_val, (should_add ? "+" : "-"), b_val, i_addc);
			$display("Expected\n sb_ac = %b,\n avr = %b,\n acr = %b", expected_result, expected_overflow, expected_carry);
			$display("Got\n sb = %b\n sb_ac = %b,\n avr = %b,\n acr = %b,\n hc = %b", sb, sb_ac, avr, acr, hc);
			failed_decimal = 1;
		end
	end
	endtask

	initial begin
		if (should_test_binary && !failed_binary)
		begin
			for (i = 0; i <= 8'hFF; i = i + 1)
			begin
				for (j = 0; j <= 8'hFF; j = j + 1)
				begin
					for (k = 0; k <= 1; k = k + 1)
					begin
						// ADD (binary)
						a <= i;
						b <= j;

						control_signal <= SUMS;
						i_addc         <= k;
						daa            <= 1'b0;
						dsa            <= 1'b0;

						#1

						eax = (i + j + k) & 8'hFF;                                  // Expected result
						ebx = ((i + j + k) & 9'h100) >> 8;                          // Expected carry
						ecx = ~(i[7] ^ j[7]) && ((i + j + k) & 8'h80) >> 7 != i[7]; // Expected avr
						edx = (((i & 4'hF) + (j & 4'hF) + k) & 5'h10) >> 4;         // Expected half carry

						if (sb_ac != eax || acr != ebx || avr != ecx || hc != edx)
						begin
							$display("ADD (binary) FAILED\nIn\n  a          = %b\n  b          = %b\n  carry      = %0d,\n  dec_enable = %0d,\n", a, b, i_addc, daa);
							$display("Result\n out        = %0b\n carry      = %0d\n avr   = %0d, hc = %0d\n", sb_ac, acr, avr, hc);
							$display("Expected\n out        = %0b\n carry      = %0d\n avr   = %0d, hc = %0d\n", eax & 8'hFF, ebx, ecx, edx);
							failed_binary = 1;
						end

						#1

						// AND
						a <= i;
						b <= j;

						control_signal <= ANDS;
						i_addc         <= k;
						daa            <= 1'b0;
						dsa            <= 1'b0;

						#1

						eax = i & j; // Expected result
						if (sb_ac != eax)
						begin
							$display("AND FAILED\nIn\n  a          = %b\n  b          = %b", a, b);
							$display("Result\n out        = %0b", sb_ac);
							$display("Expected\n out        = %0b", eax & 8'hFF);
							failed_binary = 1;
						end

						#1

						// OR
						a <= i;
						b <= j;

						control_signal <= ORS;
						i_addc         <= k;
						daa            <= 1'b0;
						dsa            <= 1'b0;

						#1

						eax = i | j; // Expected result
						if (sb_ac != eax)
						begin
							$display("OR FAILED\nIn\n  a          = %b\n  b          = %b", a, b);
							$display("Result\n out        = %0b", sb_ac);
							$display("Expected\n out        = %0b", eax & 8'hFF);
							failed_binary = 1;
						end

						#1

						// EOR
						a <= i;
						b <= j;

						control_signal <= EORS;
						i_addc         <= k;
						daa            <= 1'b0;
						dsa            <= 1'b0;

						#1

						eax = i ^ j; // Expected result
						if (sb_ac != eax)
						begin
							$display("EOR FAILED\nIn\n  a          = %b\n  b          = %b", a, b);
							$display("Result\n out        = %0b", sb_ac);
							$display("Expected\n out        = %0b", eax & 8'hFF);
							failed_binary = 1;
						end

						#1

						// SR
						a <= i;
						b <= j;

						control_signal <= SRS;
						i_addc         <= k;
						daa            <= 1'b0;
						dsa            <= 1'b0;

						#1

						eax = (i >> 1) | (k << 7); // Expected result
						ebx = i[0]; // Expected carry
						if (sb_ac != eax || acr != ebx)
						begin
							$display("SR FAILED\nIn\n  a          = %b\n  b          = %b\n  carry      = %0d", a, b, i_addc);
							$display("Result\n out        = %0b\n carry      = %0d", sb_ac, acr);
							$display("Expected\n out        = %0b\n carry      = %0d", eax & 8'hFF, ebx);
							failed_binary = 1;
						end
					end
				end
			end
		end

		if (!failed_binary) $display(" === Passed all binary tests");

		TestDecimal(1'b1, 8'h00, 8'h00, 1'b0, 8'h00, 1'b0, 1'b0);
		TestDecimal(1'b1, 8'h79, 8'h00, 1'b1, 8'h80, 1'b1, 1'b0);
		TestDecimal(1'b1, 8'h24, 8'h56, 1'b0, 8'h80, 1'b1, 1'b0);
		TestDecimal(1'b1, 8'h93, 8'h82, 1'b0, 8'h75, 1'b1, 1'b1);
		TestDecimal(1'b1, 8'h89, 8'h76, 1'b0, 8'h65, 1'b0, 1'b1);
		TestDecimal(1'b1, 8'h89, 8'h76, 1'b1, 8'h66, 1'b0, 1'b1);
		TestDecimal(1'b1, 8'h80, 8'hf0, 1'b0, 8'hd0, 1'b1, 1'b1);
		TestDecimal(1'b1, 8'h80, 8'hfa, 1'b0, 8'he0, 1'b0, 1'b1);
		TestDecimal(1'b1, 8'h2f, 8'h4f, 1'b0, 8'h74, 1'b0, 1'b0);
		TestDecimal(1'b1, 8'h6f, 8'h00, 1'b1, 8'h76, 1'b0, 1'b0); 
		
		TestDecimal(1'b0, 8'h00, 8'h00, 1'b0, 8'h99, 1'b0, 1'b0);
		TestDecimal(1'b0, 8'h00, 8'h00, 1'b1, 8'h00, 1'b0, 1'b1);
		TestDecimal(1'b0, 8'h00, 8'h01, 1'b1, 8'h99, 1'b0, 1'b0);
		TestDecimal(1'b0, 8'h0a, 8'h00, 1'b1, 8'h0a, 1'b0, 1'b1);
		TestDecimal(1'b0, 8'h0b, 8'h00, 1'b0, 8'h0a, 1'b0, 1'b1);
		TestDecimal(1'b0, 8'h9a, 8'h00, 1'b1, 8'h9a, 1'b0, 1'b1);
		TestDecimal(1'b0, 8'h9b, 8'h00, 1'b0, 8'h9a, 1'b0, 1'b1); 

		if (!failed_decimal) $display(" === Passed all decimal tests");

	end
endmodule
