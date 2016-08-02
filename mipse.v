`include "def.h"
module mipse(
input clk, rst_n,
input [`DATA_W-1:0] instr,
input [`DATA_W-1:0] readdata,
output reg [`DATA_W-1:0] pc,
output [`DATA_W-1:0] aluout,
output [`DATA_W-1:0] writedata,
output memwrite);


/*  Instruction Fetch Stage */
reg [`DATA_W-1:0] pcplus4D ;
wire [`DATA_W-1:0] pcplus4F ;
wire [`DATA_W-1:0] pcbranchD ;
reg [`DATA_W-1:0] instrD ;
wire stall;
wire btakenD;

assign pcplus4F = pc + 4;

always @(posedge clk or negedge rst_n) 
begin 
   if(!rst_n) instrD <= 0;
   else if(!stall) instrD <= instr;
end

always @(posedge clk or negedge rst_n) 
begin 
   if(!rst_n) pcplus4D <= 0;
   else if(!stall) pcplus4D <= pcplus4F;
end

always @(posedge clk or negedge rst_n) 
begin 
   if(!rst_n) pc <= 0;
   else if(!stall & btakenD)
     pc <= pcbranchD;
   else if(!stall)
     pc <= pcplus4F;
end

/*  Instruction Decode Stage */

wire [`REG_W-1:0] rsD, rdD, rtD, cadrW;
wire [`OPCODE_W-1:0] opcodeD;
wire [`SHAMT_W-1:0] shamtD;
wire [`OPCODE_W-1:0] funcD;
wire sw_opD, addi_opD, lw_opD, alu_opD;
wire lui_opD, ori_opD, beq_opD, bne_opD, branchD;
wire grade_opD;
wire regwriteD, memtoregD;
wire [`OPCODE_W-1:0] alucomD;
wire [`IMM_W-1:0] immD;
reg [`REG_W-1:0] writeregW;
wire [`DATA_W-1:0] rd1D, rd2D, rd1fD, rd2fD;
wire memwriteD;
wire slti_opD;
reg [`REG_W-1:0] rsE, rtE, rdE;
wire [`DATA_W-1:0] signimmD;
reg [`DATA_W-1:0] signimmE, rd1E, rd2E;
wire [`DATA_W-1:0] resultW;
reg [`OPCODE_W-1:0] alucomE;
reg regwriteE, memtoregE, alusrcE, regdstE;
reg memtoregM;
reg memwriteE;
reg regwriteW;
reg [`REG_W-1:0] writeregM;
reg regwriteM;
reg [`DATA_W-1:0] aluoutM;
wire mult_opD;
reg mult_opE;
wire [`DATA_W-1:0] multoutE;
reg grade_opE;
wire [2:0] gradeoutE;
reg slti_opE;
wire [`REG_W-1:0] writeregE;
wire lwstall, branchstall;

assign {opcodeD, rsD, rtD, rdD, shamtD, funcD} = instrD;
assign immD = instrD[`IMM_W-1:0];

assign sw_opD = (opcodeD == `OP_SW);
assign lw_opD = (opcodeD == `OP_LW);
assign alu_opD = (opcodeD == `OP_REG) & (
		(funcD[5:3] == 3'b100)|(funcD == `FUNC_MULT) );
assign mult_opD = (opcodeD == `OP_REG) & (funcD == `FUNC_MULT);
assign addi_opD = (opcodeD == `OP_ADDI);
assign ori_opD = (opcodeD == `OP_ORI);
assign lui_opD = (opcodeD == `OP_LUI);
assign grade_opD = (opcodeD == `OP_GRADE);
assign slti_opD = (opcodeD == `OP_SLTI);
assign beq_opD = (opcodeD == `OP_BEQ);
assign bne_opD = (opcodeD == `OP_BNE);
assign branchD = beq_opD | bne_opD;

assign memwriteD = sw_opD;

rfile rfile_1(.clk(clk), .rd1(rd1D), .a1(rsD), .rd2(rd2D), .a2(rtD),
    .wd3(resultW), .a3(writeregW), .we3(regwriteW));

assign alucomD = (addi_opD|lw_opD|sw_opD|grade_opD) ?
		`ALU_ADD: ori_opD ? `ALU_OR:
		(lui_opD) ? `ALU_THB: (slti_opD) ? `ALU_SUB: funcD;

assign regwriteD = lw_opD | alu_opD | lui_opD | grade_opD | addi_opD | ori_opD | slti_opD ;
assign memtoregD = lw_opD ;

// Stall
assign lwstall = ( (rsD == rtE) | (rtD == rtE) ) & memtoregE ;
assign branchstall = (branchD & regwriteE & (writeregE == rsD | writeregE == rtD)) |
				(branchD & memtoregM & (writeregM == rsD | writeregM == rtD)) ;
assign stall = lwstall | branchstall;

// Forwarding
assign rd1fD = (rsD !=0) & (rsD == writeregM) & regwriteM  ? aluoutM: rd1D ;
assign rd2fD = (rtD !=0) & (rtD == writeregM) & regwriteM  ? aluoutM: rd2D ;

// Branch
assign btakenD = beq_opD & (rd1fD == rd2fD) | bne_opD & (rd1fD != rd2fD);

assign signimmD = ori_opD ?  {16'b0,immD} : 
				lui_opD ? {immD, 16'b0} : 
				{{16{immD[15]}},immD} ;
assign pcbranchD = pcplus4D + {signimmD[29:0],2'b00};

// Pipeline data register 
always @(posedge clk) begin
  if(!stall) begin
	slti_opE <= slti_opD;
	grade_opE <= grade_opD;
	mult_opE <= mult_opD;
	rd1E <= rd1fD;
	rd2E <= rd2fD;
	signimmE <= signimmD;
	alucomE <= alucomD;
	alusrcE <= ~alu_opD;
	regdstE <= alu_opD;  end
end

// Pipeline control register with reset
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		rsE <= 0;
		rtE <= 0;
		rdE <= 0;
		memtoregE <= 0;
		regwriteE <= 0;
		memwriteE <= 0; end
	else if(stall) begin
		rsE <= 0;
		rtE <= 0;
		rdE <= 0;
		memtoregE <= 0;
		regwriteE <= 0;
		memwriteE <= 0; end
	else begin
		rsE <= rsD;
		rtE <= rtD;
		rdE <= rdD;
		memtoregE <= memtoregD;
		regwriteE <= regwriteD;
		memwriteE <= memwriteD; end
end

/* Execution Stage */

wire [`DATA_W-1:0] srcaE, writedataE, srcbE, aluoutE;
reg [`DATA_W-1:0] writedataM;
reg memwriteM;

// Forwarding 
assign srcaE = regwriteM & rsE!=0 & writeregM == rsE  ? aluoutM :
				regwriteW & rsE!=0 & writeregW == rsE ? resultW : rd1E;

assign writedataE = regwriteM & rtE!=0 & writeregM == rtE ? aluoutM :
				regwriteW & rtE!=0 & writeregW == rtE ? resultW : rd2E;

assign srcbE = alusrcE ? signimmE : writedataE;
assign writeregE = regdstE ? rdE: rtE;

assign multoutE = srcaE * srcbE;
assign gradeoutE =
	(srcaE >= 85) ? 5:
	(srcaE < 85 && srcaE >= 60) ? 4:
	(srcaE < 60 && srcaE >= 40) ? 3:
	(srcaE < 40 && srcaE >= 10) ? 2:
	1;

alu alu_1(.a(srcaE), .b(srcbE), .s(alucomE), .y(aluoutE));

// Pipeline register
always @(posedge clk) begin
	if(slti_opE) aluoutM <= {31'b0,aluoutE[31]};
	else if(mult_opE) aluoutM <= multoutE;
	else if(grade_opE) aluoutM <= {{(`DATA_W-3){1'b0}}, gradeoutE};
	else aluoutM <= aluoutE;
		memtoregM <= memtoregE;
		writedataM <= writedataE;
		writeregM <= writeregE;
end

// Pipeline control register with reset
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		regwriteM <= 0;
		memwriteM <= 0; end
	else begin
		regwriteM <= regwriteE;
		memwriteM <= memwriteE; end
end

/* Memory Stage */

reg [`DATA_W-1:0] readdataW, aluoutW;
reg memtoregW;
assign aluout = aluoutM;
assign writedata = writedataM;
assign memwrite = memwriteM;

always @(posedge clk) begin
	readdataW <= readdata;
	aluoutW <= aluoutM;
	memtoregW <= memtoregM;
	writeregW <= writeregM;
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) 
		regwriteW <= 0;
	else 
		regwriteW <= regwriteM;
end

/* Write Back Stage */
assign resultW = memtoregW ? readdataW: aluoutW;

endmodule
