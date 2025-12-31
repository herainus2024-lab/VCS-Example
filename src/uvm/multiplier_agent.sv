`ifndef MULTIPLIER_AGENT_SV
`define MULTIPLIER_AGENT_SV

// ============================================================================
// Multiplier Agent
// 封装 driver, monitor, sequencer，提供统一的验证接口
// ============================================================================
class multiplier_agent extends uvm_agent;
  
  `uvm_component_utils(multiplier_agent)
  
  // 组件实例
  multiplier_driver    drv;
  multiplier_monitor   mon;
  multiplier_sequencer sqr;
  
  // Agent 模式配置
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  // 构造函数
  function new(string name = "multiplier_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  // Build Phase - 创建组件
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // 获取 agent 模式配置
    uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active);
    
    // 始终创建 monitor
    mon = multiplier_monitor::type_id::create("mon", this);
    
    // 只在 active 模式下创建 driver 和 sequencer
    if (is_active == UVM_ACTIVE) begin
      drv = multiplier_driver::type_id::create("drv", this);
      sqr = multiplier_sequencer::type_id::create("sqr", this);
    end
    
    `uvm_info(get_type_name(), $sformatf("Agent created in %s mode", 
              (is_active == UVM_ACTIVE) ? "ACTIVE" : "PASSIVE"), UVM_LOW)
  endfunction : build_phase
  
  // Connect Phase - 连接组件
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // 在 active 模式下连接 driver 和 sequencer
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction : connect_phase

endclass : multiplier_agent

`endif
