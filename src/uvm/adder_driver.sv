`ifndef ADDER_DRIVER_SV
`define ADDER_DRIVER_SV

// ============================================================================
// Adder Driver
// 从 sequencer 获取事务，驱动到 DUT 接口
// ============================================================================
class adder_driver extends uvm_driver #(adder_transaction);
  
  `uvm_component_utils(adder_driver)
  
  // 虚拟接口句柄
  virtual adder_if.driver_mp vif;
  
  // 构造函数
  function new(string name = "adder_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  // Build Phase - 获取虚拟接口
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(virtual adder_if.driver_mp)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface not found in config_db!")
    end
  endfunction : build_phase
  
  // Run Phase - 主要驱动逻辑
  virtual task run_phase(uvm_phase phase);
    adder_transaction tr;
    
    // 初始化接口
    reset_interface();
    
    forever begin
      // 从 sequencer 获取下一个事务
      seq_item_port.get_next_item(tr);
      
      // 驱动事务到接口
      drive_transaction(tr);
      
      // 通知 sequencer 事务完成
      seq_item_port.item_done();
    end
  endtask : run_phase
  
  // 复位接口信号
  virtual task reset_interface();
    @(vif.driver_cb);
    vif.driver_cb.in1 <= 32'h0;
    vif.driver_cb.in2 <= 32'h0;
  endtask : reset_interface
  
  // 驱动单个事务
  virtual task drive_transaction(adder_transaction tr);
    @(vif.driver_cb);
    vif.driver_cb.in1 <= tr.in1;
    vif.driver_cb.in2 <= tr.in2;
    
    `uvm_info(get_type_name(), $sformatf("Driving: in1=0x%08h, in2=0x%08h", tr.in1, tr.in2), UVM_HIGH)
  endtask : drive_transaction

endclass : adder_driver

`endif

