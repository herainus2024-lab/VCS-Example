`ifndef MULTIPLIER_MONITOR_SV
`define MULTIPLIER_MONITOR_SV

// ============================================================================
// Multiplier Monitor
// 监控 DUT 接口信号，创建事务并发送到 scoreboard
// ============================================================================
class multiplier_monitor extends uvm_monitor;
  
  `uvm_component_utils(multiplier_monitor)
  
  // 虚拟接口句柄
  virtual multiplier_if.monitor_mp vif;
  
  // Analysis Port - 用于发送采样到的事务
  uvm_analysis_port #(multiplier_transaction) ap;
  
  // 构造函数
  function new(string name = "multiplier_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  // Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // 创建 analysis port
    ap = new("ap", this);
    
    // 获取虚拟接口
    if (!uvm_config_db#(virtual multiplier_if.monitor_mp)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found in config_db!")
    end
  endfunction : build_phase
  
  // Run Phase - 主要监控逻辑
  virtual task run_phase(uvm_phase phase);
    multiplier_transaction tr;
    
    forever begin
      // 采样事务
      tr = multiplier_transaction::type_id::create("tr");
      sample_transaction(tr);
      
      // 通过 analysis port 发送事务
      ap.write(tr);
    end
  endtask : run_phase
  
  // 采样单个事务
  virtual task sample_transaction(multiplier_transaction tr);
    // 等待时钟沿
    @(vif.monitor_cb);
    
    // 采样输入 (16-bit)
    tr.in1 = vif.monitor_cb.in1;
    tr.in2 = vif.monitor_cb.in2;
    
    // 等待一个时钟周期采样输出（因为 DUT 有一个周期延迟）
    @(vif.monitor_cb);
    tr.out = vif.monitor_cb.out;
    
    `uvm_info(get_type_name(), $sformatf("Sampled: %s", tr.convert2string()), UVM_HIGH)
  endtask : sample_transaction

endclass : multiplier_monitor

`endif
