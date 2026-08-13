module DSP48A1 (A,B,D,C,
            CLK,CARRYIN,
            OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
            CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,
            PCIN,
            BCOUT,PCOUT,P,M,
            CARRYOUT,CARRYOUTF);

parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";


input [17:0] A,B,D,BCIN;
input [47:0] C,PCIN;
input CLK,CARRYIN;
input [7:0] OPMODE;
input RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
input CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;

output [17:0] BCOUT;
output [47:0] PCOUT,P;
output [35:0] M;
output CARRYOUT,CARRYOUTF;

wire Cin_out,Cout;
reg Cin;
wire [17:0] A_out0,A_out1,B_out,D_out,BD_out,BD_mux;
reg [17:0] B_in;
wire [48:0] pre_zx_mux;
wire [47:0] C_out,ZX_mux;
reg [47:0] Z_mux,X_mux;
wire [35:0] Mult,Mult_out;
wire [7:0] OPMODE_out;
wire [47:0] P_mux;

reg_mux #(.WIDTH(18),.REG(A0REG),.RSTTYPE(RSTTYPE)) A0_reg (.in(A),.out(A_out0),.clk(CLK),.en(CEA),.rst(RSTA));
reg_mux #(.WIDTH(18),.REG(A1REG),.RSTTYPE(RSTTYPE)) A1_reg (.in(A_out0),.out(A_out1),.clk(CLK),.en(CEA),.rst(RSTA));
reg_mux #(.WIDTH(18),.REG(B0REG),.RSTTYPE(RSTTYPE)) B0_reg (.in(B_in),.out(B_out),.clk(CLK),.en(CEB),.rst(RSTB));
reg_mux #(.WIDTH(18),.REG(B1REG),.RSTTYPE(RSTTYPE)) B1_reg (.in(BD_out),.out(BD_mux),.clk(CLK),.en(CEB),.rst(RSTB));
reg_mux #(.WIDTH(18),.REG(DREG),.RSTTYPE(RSTTYPE)) D_reg (.in(D),.out(D_out),.clk(CLK),.en(CED),.rst(RSTD));
reg_mux #(.WIDTH(48),.REG(CREG),.RSTTYPE(RSTTYPE)) C_reg (.in(C),.out(C_out),.clk(CLK),.en(CEC),.rst(RSTC));
reg_mux #(.WIDTH(36),.REG(MREG),.RSTTYPE(RSTTYPE)) M_reg (.in(Mult),.out(Mult_out),.clk(CLK),.en(CEM),.rst(RSTM));
reg_mux #(.WIDTH(1),.REG(CARRYINREG),.RSTTYPE(RSTTYPE)) cyi (.in(Cin),.out(Cin_out),.clk(CLK),.en(CECARRYIN),.rst(RSTCARRYIN));
reg_mux #(.WIDTH(1),.REG(CARRYOUTREG),.RSTTYPE(RSTTYPE)) cyo (.in(Cout),.out(CARRYOUT),.clk(CLK),.en(CECARRYIN),.rst(RSTCARRYIN));
reg_mux #(.WIDTH(48),.REG(PREG),.RSTTYPE(RSTTYPE)) P_reg (.in(ZX_mux),.out(P_mux),.clk(CLK),.en(CEP),.rst(RSTP));
reg_mux #(.WIDTH(8),.REG(OPMODEREG),.RSTTYPE(RSTTYPE)) OPMODE_reg (.in(OPMODE),.out(OPMODE_out),.clk(CLK),.en(CEOPMODE),.rst(RSTOPMODE));

wire [17:0] pre_add_sub;

assign pre_add_sub = (OPMODE_out[6])? (D_out - B_out) : (D_out + B_out);
assign BD_out = (OPMODE_out[4])? pre_add_sub : B_out;
assign Mult = BD_mux * A_out1;
assign pre_zx_mux = (OPMODE_out[7])? (Z_mux - (X_mux + Cin_out)): (Z_mux + X_mux + Cin_out);
assign ZX_mux = pre_zx_mux[47:0];
assign Cout = pre_zx_mux[48];

always @(*) begin
    case (OPMODE_out[1:0])
        2'b00: X_mux = 0;
        2'b01: X_mux = {12'b0,Mult_out};
        2'b10: X_mux = P_mux;
        2'b11: X_mux = {D_out[11:0],A_out0[17:0],B_out[17:0]};
    endcase

    case (OPMODE_out[3:2])
        2'b00: Z_mux = 0;
        2'b01: Z_mux = PCIN;
        2'b10: Z_mux = P_mux;
        2'b11: Z_mux = C_out;
    endcase

    case (B_INPUT)
        "DIRECT": B_in = B;
        "CASCADE": B_in = BCIN;
        default: B_in = 0;
    endcase

    case (CARRYINSEL)
        "OPMODE5": Cin = OPMODE_out[5];
        "CARRYIN": Cin = CARRYIN;
        default: Cin = 0;
    endcase

end

assign P = P_mux; 
assign PCOUT = P_mux;
assign BCOUT = BD_mux;
assign CARRYOUTF = CARRYOUT;
assign M = Mult_out;


endmodule