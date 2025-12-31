`ifndef ADDER_PKG_SV
`define ADDER_PKG_SV

// ============================================================================
// Adder Package
// 包含所有 UVM 验证组件的 package
// ============================================================================
package adder_pkg;
  
  // 导入 UVM 库
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  // 包含所有验证组件（按依赖顺序）
  `include "adder_transaction.sv"
  `include "adder_sequence.sv"
  `include "adder_sequencer.sv"
  `include "adder_driver.sv"
  `include "adder_monitor.sv"
  `include "adder_scoreboard.sv"
  `include "adder_coverage.sv"
  `include "adder_agent.sv"
  `include "adder_env.sv"
  `include "adder_test.sv"

endpackage : adder_pkg

`endif


