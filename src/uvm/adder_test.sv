`ifndef ADDER_TEST_SV
`define ADDER_TEST_SV

// ============================================================================
// Base Test
// 基础测试类，所有测试用例的父类
// ============================================================================
class adder_base_test extends uvm_test;
  
  `uvm_component_utils(adder_base_test)
  
  // 验证环境
  adder_env env;
  
  // 虚拟接口
  virtual adder_if vif;
  
  // 构造函数
  function new(string name = "adder_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  // Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // 获取顶层接口
    if (!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found!")
    end
    
    // 将接口传递给 driver 和 monitor
    uvm_config_db#(virtual adder_if.driver_mp)::set(this, "env.agent.drv", "vif", vif.driver_mp);
    uvm_config_db#(virtual adder_if.monitor_mp)::set(this, "env.agent.mon", "vif", vif.monitor_mp);
    
    // 创建环境
    env = adder_env::type_id::create("env", this);
    
    `uvm_info(get_type_name(), "Base test build complete", UVM_LOW)
  endfunction : build_phase
  
  // End of Elaboration Phase - 打印拓扑
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), "Printing UVM topology:", UVM_LOW)
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase
  
  // Report Phase
  virtual function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
    
    svr = uvm_report_server::get_server();
    
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
    `uvm_info(get_type_name(), "        FINAL TEST REPORT               ", UVM_LOW)
    `uvm_info(get_type_name(), "========================================", UVM_LOW)
    
    if (svr.get_severity_count(UVM_ERROR) > 0 || svr.get_severity_count(UVM_FATAL) > 0) begin
      `uvm_info(get_type_name(), "********** TEST FAILED **********", UVM_NONE)
    end else begin
      `uvm_info(get_type_name(), "********** TEST PASSED **********", UVM_NONE)
    end
  endfunction : report_phase

endclass : adder_base_test


// ============================================================================
// Random Test
// 随机测试用例
// ============================================================================
class adder_random_test extends adder_base_test;
  
  `uvm_component_utils(adder_random_test)
  
  function new(string name = "adder_random_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  // Run Phase - 执行测试序列
  virtual task run_phase(uvm_phase phase);
    adder_random_sequence seq;
    
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting random test...", UVM_LOW)
    
    seq = adder_random_sequence::type_id::create("seq");
    seq.num_transactions = 100;
    seq.start(env.agent.sqr);
    
    // 等待一些时钟周期让最后的事务完成
    #100;
    
    `uvm_info(get_type_name(), "Random test complete", UVM_LOW)
    phase.drop_objection(this);
  endtask : run_phase

endclass : adder_random_test


// ============================================================================
// Directed Test
// 定向测试用例
// ============================================================================
class adder_directed_test extends adder_base_test;
  
  `uvm_component_utils(adder_directed_test)
  
  function new(string name = "adder_directed_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  virtual task run_phase(uvm_phase phase);
    adder_directed_sequence seq;
    
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting directed test...", UVM_LOW)
    
    seq = adder_directed_sequence::type_id::create("seq");
    seq.start(env.agent.sqr);
    
    #100;
    
    `uvm_info(get_type_name(), "Directed test complete", UVM_LOW)
    phase.drop_objection(this);
  endtask : run_phase

endclass : adder_directed_test


// ============================================================================
// Corner Case Test
// 边界测试用例
// ============================================================================
class adder_corner_test extends adder_base_test;
  
  `uvm_component_utils(adder_corner_test)
  
  function new(string name = "adder_corner_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  virtual task run_phase(uvm_phase phase);
    adder_corner_sequence seq;
    
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting corner case test...", UVM_LOW)
    
    seq = adder_corner_sequence::type_id::create("seq");
    seq.start(env.agent.sqr);
    
    #100;
    
    `uvm_info(get_type_name(), "Corner case test complete", UVM_LOW)
    phase.drop_objection(this);
  endtask : run_phase

endclass : adder_corner_test


// ============================================================================
// Full Test
// 完整测试 - 组合所有序列
// ============================================================================
class adder_full_test extends adder_base_test;
  
  `uvm_component_utils(adder_full_test)
  
  function new(string name = "adder_full_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  virtual task run_phase(uvm_phase phase);
    adder_corner_sequence   corner_seq;
    adder_directed_sequence directed_seq;
    adder_random_sequence   random_seq;
    
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting full test...", UVM_LOW)
    
    // 1. 边界测试
    `uvm_info(get_type_name(), "Phase 1: Corner case tests", UVM_LOW)
    corner_seq = adder_corner_sequence::type_id::create("corner_seq");
    corner_seq.start(env.agent.sqr);
    
    // 2. 定向测试
    `uvm_info(get_type_name(), "Phase 2: Directed tests", UVM_LOW)
    directed_seq = adder_directed_sequence::type_id::create("directed_seq");
    directed_seq.start(env.agent.sqr);
    
    // 3. 随机测试
    `uvm_info(get_type_name(), "Phase 3: Random tests", UVM_LOW)
    random_seq = adder_random_sequence::type_id::create("random_seq");
    random_seq.num_transactions = 200;
    random_seq.start(env.agent.sqr);
    
    #100;
    
    `uvm_info(get_type_name(), "Full test complete", UVM_LOW)
    phase.drop_objection(this);
  endtask : run_phase

endclass : adder_full_test

`endif


