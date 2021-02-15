module testbench;
  
  reg PHI0, BRK6E, Z_ADL0, SO, RDY, BRFW, ACRL2, _C_OUT, _D_OUT, _ready, T0, T1, T5, T6;
  reg [129:0] decoder;
  
  wire BRK5, BR2, _ADL_PCL, PC_DB, 
    ADH_ABH, ADL_ABL, Y_SB, X_SB, SB_Y, SB_X, S_SB, S_ADL, SB_S, S_S, 
    NDB_ADD, DB_ADD, Z_ADD, SB_ADD, ADL_ADD, ANDS, EORS, ORS, _ADDC, SRS, SUMS, _DAA, ADD_SB7, ADD_SB06, ADD_ADL, _DSA,
    Z_ADH0, SB_DB, SB_AC, SB_ADH, Z_ADH17, AC_SB, AC_DB, 
    ADH_PCH, PCH_PCH, PCH_DB, PCL_DB, PCH_ADH, PCL_PCL, PCL_ADL, ADL_PCL, DL_ADL, DL_ADH, DL_DB,
    P_DB, ACR_C, AVR_V, DBZ_Z, DB_N, DB_P, DB_C, DB_V, IR5_C, IR5_I, IR5_D, ZERO_V, ONE_V;
  
  RandomLogic random(
    .BRK5(BRK5),
    .BR2(BR2), 
    ._ADL_PCL(_ADL_PCL), 
    .PC_DB(PC_DB), 
    .ADH_ABH(ADH_ABH), 
    .ADL_ABL(ADL_ABL), 
    .Y_SB(Y_SB),
    .X_SB(X_SB), 
    .SB_Y(SB_Y), 
    .SB_X(SB_X), 
    .S_SB(S_SB), 
    .S_ADL(S_ADL), 
    .SB_S(SB_S), 
    .S_S(S_S), 
    .NDB_ADD(NDB_ADD), 
    .DB_ADD(DB_ADD), 
    .Z_ADD(Z_ADD), 
    .SB_ADD(SB_ADD), 
    .ADL_ADD(ADL_ADD), 
    .ANDS(ANDS), 
    .EORS(EORS), 
    .ORS(ORS), 
    ._ADDC(_ADDC), 
    .SRS(SRS), 
    .SUMS(SUMS), 
    ._DAA(_DAA), 
    .ADD_SB7(ADD_SB7), 
    .ADD_SB06(ADD_SB06), 
    .ADD_ADL(ADD_ADL), 
    ._DSA(_DSA),
    .Z_ADH0(Z_ADH0), 
    .SB_DB(SB_DB), 
    .SB_AC(SB_AC), 
    .SB_ADH(SB_ADH), 
    .Z_ADH17(Z_ADH17), 
    .AC_SB(AC_SB), 
    .AC_DB(AC_DB), 
    .ADH_PCH(ADH_PCH),
    .PCH_PCH(PCH_PCH), 
    .PCH_DB(PCH_DB), 
    .PCL_DB(PCL_DB), 
    .PCH_ADH(PCH_ADH), 
    .PCL_PCL(PCL_PCL), 
    .PCL_ADL(PCL_ADL), 
    .ADL_PCL(ADL_PCL), 
    .DL_ADL(DL_ADL), 
    .DL_ADH(DL_ADH), 
    .DL_DB(DL_DB),
    .P_DB(P_DB), 
    .ACR_C(ACR_C), 
    .AVR_V(AVR_V), 
    .DBZ_Z(DBZ_Z), 
    .DB_N(DB_N), 
    .DB_P(DB_P), 
    .DB_C(DB_C), 
    .DB_V(DB_V), 
    .IR5_C(IR5_C), 
    .IR5_I(IR5_I),
    .IR5_D(IR5_D), 
    .ZERO_V(ZERO_V), 
    .ONE_V(ONE_V),
    .PHI0(PHI0),
    .BRK6E(BRK6E), 
    .Z_ADL0(Z_ADL0), 
    .SO(SO), 
    .RDY(RDY), 
    .BRFW(BRFW), 
    .ACRL2(ACRL2),
    ._C_OUT(_C_OUT), 
    ._D_OUT(_D_OUT), 
    ._ready(_ready), 
    .T0(T0), 
    .T1(T1),
    .T5(T5), 
    .T6(T6),
    .decoder(decoder)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, testbench);
    
    PHI0 = 0'b0;
    #5;
    
    decoder = 0;
    
    BRK6E = 1;
    Z_ADL0 = 1;
    SO = 1;
    RDY = 1;
    BRFW = 1;
    ACRL2 = 1;
    _C_OUT = 1;
    _D_OUT = 1;
    _ready = 1;
    T0 = 1;
    T1 = 1;
    T5 = 1;
    T6 = 1;
    
    #5;

    $finish;
  end
  
  always #1 PHI0 = ~PHI0;
  
endmodule