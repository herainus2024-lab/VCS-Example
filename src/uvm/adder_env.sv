`ifndef ADDER_ENV_SV
`define ADDER_ENV_SV

// ============================================================================
// Adder Environment
// 顶层验证环境，包含所有验证组件
// ============================================================================
class adder_env extends uvm_env;
  
  `uvm_component_utils(adder_env)
  
  // 组件实例
  adder_agent       agent;
  adder_scoreboard  scoreboard;
  adder_coverage    coverage;
  
  // 环境配置
  bit has_scoreboard = 1;
  bit has_coverage   = 1;
  
  // 构造函数
  function new(string name = "adder_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
  // Build Phase - 创建组件
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // 获取配置
    uvm_config_db#(bit)::get(this, "", "has_scoreboard", has_scoreboard);
    uvm_config_db#(bit)::get(this, "", "has_coverage", has_coverage);
    
    // 创建 agent
    agent = adder_agent::type_id::create("agent", this);
    
    // 根据配置创建 scoreboard
    if (has_scoreboard) begin
      scoreboard = adder_scoreboard::type_id::create("scoreboard", this);
    end
    
    // 根据配置创建 coverage
    if (has_coverage) begin
      coverage = adder_coverage::type_id::create("coverage", this);
    end
    
    `uvm_info(get_type_name(), "Environment build complete", UVM_LOW)
  endfunction : build_phase
  
  // Connect Phase - 连接组件
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // 连接 monitor 到 scoreboard
    if (has_scoreboard) begin
      agent.mon.ap.connect(scoreboard.ap_imp);
    end
    
    // 连接 monitor 到 coverage
    if (has_coverage) begin
      agent.mon.ap.connect(coverage.analysis_export);
    end
    
    `uvm_info(get_type_name(), "Environment connect complete", UVM_LOW)
  endfunction : connect_phase

endclass : adder_env

`endif


