`ifndef MULTIPLIER_SEQUENCER_SV
`define MULTIPLIER_SEQUENCER_SV

// ============================================================================
// Multiplier Sequencer
// 序列控制器，管理 sequence 和 driver 之间的事务传递
// ============================================================================
class multiplier_sequencer extends uvm_sequencer #(multiplier_transaction);
  
  `uvm_component_utils(multiplier_sequencer)
  
  // 构造函数
  function new(string name = "multiplier_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass : multiplier_sequencer

`endif
