`default_nettype none

module CPU(
  input var logic enable,
  input var logic clock,
  input var logic reset
);

// Decoder
var logic fetch, decode, execute, writeback;
var logic clk;
assign clk = enable && clock; // Only clock the CPU when enabled
Decoder dec(
  .clock(clk),
  .reset(reset),
  .fetch(fetch),
  .decode(decode),
  .execute(execute),
  .writeback(writeback)
);

// Program Counter
var logic pc_set;
var logic[7:0] pc_in;
var logic[7:0] pc_out;
Counter pc(
  .clock(fetch), // WARNING: Phase 1 - Fetch
  .reset(reset),
  .decrement(0),
  .setvalue(pc_set),
  .valuein(pc_in),
  .valueout(pc_out)
);

// ROM (Instruction Memory)
var logic[7:0] rom_data;
ROM rom(
  .address(pc_out),
  .dataout(rom_data)
);

// Controller
var logic[1:0] ctrl_opcode;
var logic ctrl_regsset, ctrl_pcset;
var logic[2:0] ctrl_regssavesel, ctrl_regsloadsel, ctrl_aluopc, ctrl_condopc;
Controller ctrl(
  .clock(decode), // WARNING: Phase 2 - Decode
  .reset(reset),
  .databus(rom_data),
  .opcode(ctrl_opcode),
  .regs_set(ctrl_regsset),
  .regs_savesel(ctrl_regssavesel),
  .regs_loadsel(ctrl_regsloadsel),
  .alu_opc(ctrl_aluopc),
  .cond_opc(ctrl_condopc),
  .pc_set(ctrl_pcset)
);

// Register Bank
var logic[7:0] regs_savebus;
var logic[7:0] regs_loadbus;
var logic[7:0] regs_jumptarget;
var logic[7:0] regs_aluopA;
var logic[7:0] regs_aluopB;
var logic[7:0] regs_aluresult;
RegisterFile regs(
  .clock(writeback), // WARNING: Phase 4 - Writeback
  .reset(reset),
  .save(ctrl_regsset),
  .saveselector(ctrl_regssavesel),
  .savebus(regs_savebus),
  .loadselector(ctrl_regsloadsel),
  .loadbus(regs_loadbus),
  .jumptarget(regs_jumptarget),
  .aluoperandA(regs_aluopA),
  .aluoperandB(regs_aluopB),
  .aluresult(regs_aluresult)
);

// Arithmetic and Logical Unit
var logic[7:0] alu_result;
ALU alu(
  .clock(execute), // WARNING: Phase 3 - Execute
  .opcode(ctrl_aluopc),
  .operandA(regs_aluopA),
  .operandB(regs_aluopB),
  .result(alu_result)
);

// Conditional Unit
var logic cond_result;
ConditionalUnit cond(
  .clock(execute), // WARNING: Phase 3 - Execute
  .opcode(ctrl_condopc),
  .operand(regs_aluresult),
  .result(cond_result)
);

// CPU Inter-Component Connections
assign pc_set = cond_result && ctrl_pcset;
assign pc_in = regs_jumptarget;

always @(execute) case (ctrl_opcode)
  2'b01: regs_savebus = alu_result;
  2'b11: regs_savebus = regs_loadbus;
  default: regs_savebus = 8'b00000000;
endcase

endmodule
