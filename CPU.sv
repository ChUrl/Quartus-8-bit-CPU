`default_nettype none

module CPU(
  input var logic enable,
  input var logic clock,
  input var logic reset,

  // TODO: Replace with Input/Output module
  input var logic[7:0] cpuin,
  output var logic[7:0] cpuout,

  // Debug Outputs
  output var logic dbg_fetch,
  output var logic dbg_decode,
  output var logic dbg_execute,
  output var logic dbg_writeback,
  output var logic[7:0] dbg_pcout,
  output var logic[7:0] dbg_romout,
  output var logic[7:0] dbg_savebus,
  output var logic[7:0] dbg_loadbus,
  output var logic[7:0] dbg_jumptarget,
  output var logic[7:0] dbg_aluopA,
  output var logic[7:0] dbg_aluopB,
  output var logic[7:0] dbg_aluresult
);

// Decoder
var logic fetch, decode, execute, writeback, clk;
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
var logic[7:0] pc_in, pc_out;
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
var logic ctrl_regsset, ctrl_pcset;
var logic[1:0] ctrl_opcode;
var logic[2:0] ctrl_arg0, ctrl_arg1, ctrl_regssavesel, ctrl_regsloadsel, ctrl_aluopc, ctrl_condopc;
var logic[5:0] ctrl_arg;
Controller ctrl(
  .clock(decode), // WARNING: Phase 2 - Decode
  .reset(reset),
  .databus(rom_data),
  .opcode(ctrl_opcode),
  .arg(ctrl_arg),
  .arg0(ctrl_arg0),
  .arg1(ctrl_arg1),
  .regs_set(ctrl_regsset),
  .regs_savesel(ctrl_regssavesel),
  .regs_loadsel(ctrl_regsloadsel),
  .alu_opc(ctrl_aluopc),
  .cond_opc(ctrl_condopc),
  .pc_set(ctrl_pcset)
);

// Register Bank
var logic regs_set;
var logic[7:0] regs_savebus, regs_loadbus, regs_jumptarget, regs_aluopA, regs_aluopB, regs_aluresult;
RegisterFile regs(
  .clock(writeback), // WARNING: Phase 4 - Writeback
  .reset(reset),
  .save(regs_set),
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
  // .clock(execute), // WARNING: Phase 3 - Execute // TODO
  .opcode(ctrl_aluopc),
  .operandA(regs_aluopA),
  .operandB(regs_aluopB),
  .result(alu_result)
);

// Conditional Unit
var logic cond_result;
ConditionalUnit cond(
  // .clock(execute), // WARNING: Phase 3 - Execute // TODO
  .opcode(ctrl_condopc),
  .operand(regs_aluresult),
  .result(cond_result)
);

// Missing CPU Inter-Component Connections
assign pc_set = cond_result && ctrl_pcset;
assign pc_in = regs_jumptarget;
assign regs_set = ctrl_regsset && (ctrl_arg0 != 3'b110);

// FIXME: ALU writeback doesn't work:
//        - Execute clocks the ALU
//        - Execute connects alu_result to regs_savebus.
//          This has to happen after the ALU was clocked.
//          Remove the ALU/Cond clock entirely (for now)?
// TODO: Should add this to the Controller probably?
//       Or a new module, like "BusController"? Or just "Bus"?
always @(execute) case (ctrl_opcode) // WARNING: Phase 3 - Execute ("Execute" currently means "BusControl")
  2'b00: begin
    // Load constant
    cpuout = 8'b00000000;
    regs_savebus = ctrl_arg;
  end
  2'b01: begin
    // Save ALU result
    cpuout = 8'b00000000;
    regs_savebus = alu_result;
  end
  2'b10: if (ctrl_arg0 == 3'b110) begin
    // Write to output
    cpuout = regs_loadbus;
    regs_savebus = 8'b00000000;
  end else if (ctrl_arg1 == 3'b110) begin
    // Load from input
    cpuout = 8'b00000000;
    regs_savebus = cpuin;
  end else begin
    // Copy from reg to reg
    cpuout = 8'b00000000;
    regs_savebus = regs_loadbus;
  end
  default: begin
    // Conditional jump
    cpuout = 8'b00000000;
    regs_savebus = 8'b00000000;
  end
endcase

// Debug outputs
assign dbg_fetch = fetch;
assign dbg_decode = decode;
assign dbg_execute = execute;
assign dbg_writeback = writeback;
assign dbg_pcout = pc_out;
assign dbg_romout = rom_data;
assign dbg_savebus = regs_savebus;
assign dbg_loadbus = regs_loadbus;
assign dbg_jumptarget = regs_jumptarget;
assign dbg_aluopA = regs_aluopA;
assign dbg_aluopB = regs_aluopB;
assign dbg_aluresult = regs_aluresult;

endmodule
