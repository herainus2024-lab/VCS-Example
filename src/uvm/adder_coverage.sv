`ifndef ADDER_COVERAGE_SV
`define ADDER_COVERAGE_SV

// ============================================================================
// Adder Coverage Collector
// 收集功能覆盖率
// ============================================================================
class adder_coverage extends uvm_subscriber #(adder_transaction);
  
  `uvm_component_utils(adder_coverage)
  
  // 覆盖的事务
  adder_transaction tr;
  
  // 覆盖组
  covergroup adder_cg;
    
    // 输入 in1 覆盖
    cp_in1: coverpoint tr.in1 {
      bins zero       = {0};
      bins max        = {32'hFFFFFFFF};
      bins low        = {[1:32'h0000FFFF]};
      bins mid        = {[32'h00010000:32'h7FFFFFFF]};
      bins high       = {[32'h80000000:32'hFFFFFFFE]};
    }
    
    // 输入 in2 覆盖
    cp_in2: coverpoint tr.in2 {
      bins zero       = {0};
      bins max        = {32'hFFFFFFFF};
      bins low        = {[1:32'h0000FFFF]};
      bins mid        = {[32'h00010000:32'h7FFFFFFF]};
      bins high       = {[32'h80000000:32'hFFFFFFFE]};
    }
    
    // 输出 out 覆盖
    cp_out: coverpoint tr.out {
      bins zero       = {0};
      bins max        = {32'hFFFFFFFF};
      bins low        = {[1:32'h0000FFFF]};
      bins mid        = {[32'h00010000:32'h7FFFFFFF]};
      bins high       = {[32'h80000000:32'hFFFFFFFE]};
    }
    
    // 交叉覆盖 - in1 和 in2 的组合
    cross_in1_in2: cross cp_in1, cp_in2;
    
  endgroup : adder_cg
  
  // 构造函数
  function new(string name = "adder_coverage", uvm_component parent = null);
    super.new(name, parent);
    adder_cg = new();
  endfunction : new
  
  // Write 函数 - 接收事务并采样覆盖
  virtual function void write(adder_transaction t);
    tr = t;
    adder_cg.sample();
    `uvm_info(get_type_name(), $sformatf("Coverage sampled: %s", t.convert2string()), UVM_HIGH)
  endfunction : write
  
  // Report Phase - 打印覆盖率
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
    `uvm_info(get_type_name(), "        COVERAGE SUMMARY                ", UVM_LOW)
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Functional Coverage: %.2f%%", adder_cg.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
  endfunction : report_phase

endclass : adder_coverage

`endif

