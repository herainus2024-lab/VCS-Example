`ifndef MULTIPLIER_PKG_SV
`define MULTIPLIER_PKG_SV

// ============================================================================
// Multiplier Package
// 包含所有 UVM 验证组件的 package
// ============================================================================
package multiplier_pkg;
  
  // 导入 UVM 库
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  // 包含所有验证组件（按依赖顺序）
  `include "multiplier_transaction.sv"
  `include "multiplier_sequence.sv"
  `include "multiplier_sequencer.sv"
  `include "multiplier_driver.sv"
  `include "multiplier_monitor.sv"
  `include "multiplier_scoreboard.sv"
  `include "multiplier_coverage.sv"
  `include "multiplier_agent.sv"
  `include "multiplier_env.sv"
  `include "multiplier_test.sv"

endpackage : multiplier_pkg

`endif
