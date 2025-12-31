`ifndef MULTIPLIER_SEQUENCE_SV
`define MULTIPLIER_SEQUENCE_SV

// ============================================================================
// Base Sequence
// 基础序列类
// ============================================================================
class multiplier_base_sequence extends uvm_sequence #(multiplier_transaction);
  
  `uvm_object_utils(multiplier_base_sequence)
  
  function new(string name = "multiplier_base_sequence");
    super.new(name);
  endfunction : new
  
  // 默认序列：产生随机事务
  virtual task body();
    multiplier_transaction tr;
    
    repeat(10) begin
      tr = multiplier_transaction::type_id::create("tr");
      start_item(tr);
      if (!tr.randomize()) begin
        `uvm_error(get_type_name(), "Randomization failed!")
      end
      `uvm_info(get_type_name(), $sformatf("Generated: %s", tr.convert2string()), UVM_MEDIUM)
      finish_item(tr);
    end
  endtask : body

endclass : multiplier_base_sequence


// ============================================================================
// Random Sequence
// 随机测试序列
// ============================================================================
class multiplier_random_sequence extends uvm_sequence #(multiplier_transaction);
  
  `uvm_object_utils(multiplier_random_sequence)
  
  // 可配置的事务数量
  rand int unsigned num_transactions;
  
  constraint c_num_trans { num_transactions inside {[50:200]}; }
  
  function new(string name = "multiplier_random_sequence");
    super.new(name);
  endfunction : new
  
  virtual task body();
    multiplier_transaction tr;
    
    `uvm_info(get_type_name(), $sformatf("Generating %0d random transactions", num_transactions), UVM_LOW)
    
    repeat(num_transactions) begin
      tr = multiplier_transaction::type_id::create("tr");
      start_item(tr);
      if (!tr.randomize()) begin
        `uvm_error(get_type_name(), "Randomization failed!")
      end
      finish_item(tr);
    end
  endtask : body

endclass : multiplier_random_sequence


// ============================================================================
// Directed Sequence
// 定向测试序列 - 测试特定值
// ============================================================================
class multiplier_directed_sequence extends uvm_sequence #(multiplier_transaction);
  
  `uvm_object_utils(multiplier_directed_sequence)
  
  function new(string name = "multiplier_directed_sequence");
    super.new(name);
  endfunction : new
  
  virtual task body();
    multiplier_transaction tr;
    
    // 测试用例数组 (16-bit for multiplier)
    bit [15:0] test_in1[] = '{0, 16'hFFFF, 16'h1234, 1, 16'h7FFF, 16'h8000};
    bit [15:0] test_in2[] = '{0, 16'hFFFF, 16'h8765, 16'hFFFF, 1, 16'h8000};
    
    `uvm_info(get_type_name(), "Running directed test cases", UVM_LOW)
    
    foreach(test_in1[i]) begin
      tr = multiplier_transaction::type_id::create("tr");
      start_item(tr);
      tr.in1 = test_in1[i];
      tr.in2 = test_in2[i];
      `uvm_info(get_type_name(), $sformatf("Directed test: %s", tr.convert2string()), UVM_MEDIUM)
      finish_item(tr);
    end
  endtask : body

endclass : multiplier_directed_sequence


// ============================================================================
// Corner Case Sequence
// 边界测试序列
// ============================================================================
class multiplier_corner_sequence extends uvm_sequence #(multiplier_transaction);
  
  `uvm_object_utils(multiplier_corner_sequence)
  
  function new(string name = "multiplier_corner_sequence");
    super.new(name);
  endfunction : new
  
  virtual task body();
    multiplier_transaction tr;
    
    `uvm_info(get_type_name(), "Running corner case tests", UVM_LOW)
    
    // 测试边界值 (16-bit)
    // Case 1: 0 * 0
    tr = multiplier_transaction::type_id::create("tr");
    start_item(tr);
    tr.in1 = 0;
    tr.in2 = 0;
    finish_item(tr);
    
    // Case 2: MAX * 0
    tr = multiplier_transaction::type_id::create("tr");
    start_item(tr);
    tr.in1 = 16'hFFFF;
    tr.in2 = 0;
    finish_item(tr);
    
    // Case 3: 0 * MAX
    tr = multiplier_transaction::type_id::create("tr");
    start_item(tr);
    tr.in1 = 0;
    tr.in2 = 16'hFFFF;
    finish_item(tr);
    
    // Case 4: MAX * MAX
    tr = multiplier_transaction::type_id::create("tr");
    start_item(tr);
    tr.in1 = 16'hFFFF;
    tr.in2 = 16'hFFFF;
    finish_item(tr);
    
    // Case 5: MAX * 1
    tr = multiplier_transaction::type_id::create("tr");
    start_item(tr);
    tr.in1 = 16'hFFFF;
    tr.in2 = 1;
    finish_item(tr);
    
    // Case 6: 1 * 1
    tr = multiplier_transaction::type_id::create("tr");
    start_item(tr);
    tr.in1 = 1;
    tr.in2 = 1;
    finish_item(tr);
    
  endtask : body

endclass : multiplier_corner_sequence

`endif
