`ifndef MULTIPLIER_COVERAGE_SV
`define MULTIPLIER_COVERAGE_SV

// ============================================================================
// Multiplier Coverage Collector
// 收集功能覆盖率
// ============================================================================
class multiplier_coverage extends uvm_subscriber #(multiplier_transaction);
  
  `uvm_component_utils(multiplier_coverage)
  
  // 覆盖的事务
  multiplier_transaction tr;
  
  // 覆盖组
  covergroup multiplier_cg;
    
    // 输入 in1 覆盖 (16-bit)
    cp_in1: coverpoint tr.in1 {
      bins zero       = {0};
      bins max        = {16'hFFFF};
      bins low        = {[1:16'h3FFF]};
      bins mid        = {[16'h4000:16'h7FFF]};
      bins high       = {[16'h8000:16'hFFFE]};
    }
    
    // 输入 in2 覆盖 (16-bit)
    cp_in2: coverpoint tr.in2 {
      bins zero       = {0};
      bins max        = {16'hFFFF};
      bins low        = {[1:16'h3FFF]};
      bins mid        = {[16'h4000:16'h7FFF]};
      bins high       = {[16'h8000:16'hFFFE]};
    }
    
    // 输出 out 覆盖 (32-bit)
    cp_out: coverpoint tr.out {
      bins zero       = {0};
      bins max        = {32'hFFFFFFFF};
      bins low        = {[1:32'h0000FFFF]};
      bins mid        = {[32'h00010000:32'h7FFFFFFF]};
      bins high       = {[32'h80000000:32'hFFFFFFFE]};
    }
    
    // 交叉覆盖 - in1 和 in2 的组合
    cross_in1_in2: cross cp_in1, cp_in2;
    
  endgroup : multiplier_cg
  
  // 构造函数
  function new(string name = "multiplier_coverage", uvm_component parent = null);
    super.new(name, parent);
    multiplier_cg = new();
  endfunction : new
  
  // Write 函数 - 接收事务并采样覆盖
  virtual function void write(multiplier_transaction t);
    tr = t;
    multiplier_cg.sample();
    `uvm_info(get_type_name(), $sformatf("Coverage sampled: %s", t.convert2string()), UVM_HIGH)
  endfunction : write
  
  // Report Phase - 打印覆盖率
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
    `uvm_info(get_type_name(), "        COVERAGE SUMMARY                ", UVM_LOW)
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Functional Coverage: %.2f%%", multiplier_cg.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
  endfunction : report_phase

endclass : multiplier_coverage

`endif
