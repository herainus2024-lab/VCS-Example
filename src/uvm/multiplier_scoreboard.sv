`ifndef MULTIPLIER_SCOREBOARD_SV
`define MULTIPLIER_SCOREBOARD_SV

// ============================================================================
// Multiplier Scoreboard
// 比较预期结果和实际结果，进行功能验证
// ============================================================================
class multiplier_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(multiplier_scoreboard)
  
  // Analysis Export - 接收来自 monitor 的事务
  uvm_analysis_imp #(multiplier_transaction, multiplier_scoreboard) ap_imp;
  
  // 统计计数器
  int unsigned pass_count;
  int unsigned fail_count;
  int unsigned total_count;
  
  // 构造函数
  function new(string name = "multiplier_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    pass_count = 0;
    fail_count = 0;
    total_count = 0;
  endfunction : new
  
  // Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap_imp = new("ap_imp", this);
  endfunction : build_phase
  
  // Write 函数 - 接收并检查事务
  virtual function void write(multiplier_transaction tr);
    bit [31:0] expected_out;
    
    // 计算预期结果 (16-bit multiplication)
    expected_out = tr.in1 * tr.in2;
    
    total_count++;
    
    // 比较实际结果和预期结果
    if (tr.out === expected_out) begin
      pass_count++;
      `uvm_info(get_type_name(), 
        $sformatf("[PASS] in1=0x%04h * in2=0x%04h = 0x%08h (expected: 0x%08h)", 
                  tr.in1, tr.in2, tr.out, expected_out), UVM_MEDIUM)
    end else begin
      fail_count++;
      `uvm_error(get_type_name(), 
        $sformatf("[FAIL] in1=0x%04h * in2=0x%04h = 0x%08h (expected: 0x%08h)", 
                  tr.in1, tr.in2, tr.out, expected_out))
    end
  endfunction : write
  
  // Report Phase - 打印测试统计
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
    `uvm_info(get_type_name(), "        SCOREBOARD SUMMARY              ", UVM_LOW)
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Total Transactions : %0d", total_count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Passed             : %0d", pass_count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Failed             : %0d", fail_count), UVM_LOW)
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
    
    if (fail_count > 0) begin
      `uvm_error(get_type_name(), "TEST FAILED!")
    end else if (total_count > 0) begin
      `uvm_info(get_type_name(), "TEST PASSED!", UVM_LOW)
    end else begin
      `uvm_warning(get_type_name(), "No transactions were checked!")
    end
  endfunction : report_phase

endclass : multiplier_scoreboard

`endif
