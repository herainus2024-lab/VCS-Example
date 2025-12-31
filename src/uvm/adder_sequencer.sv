`ifndef ADDER_SEQUENCER_SV
`define ADDER_SEQUENCER_SV

// ============================================================================
// Adder Sequencer
// 序列控制器，管理 sequence 和 driver 之间的事务传递
// ============================================================================
class adder_sequencer extends uvm_sequencer #(adder_transaction);
  
  `uvm_component_utils(adder_sequencer)
  
  // 构造函数
  function new(string name = "adder_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass : adder_sequencer

`endif


