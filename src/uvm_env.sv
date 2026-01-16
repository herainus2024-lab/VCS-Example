`ifndef UVM_ENV_SV
`define UVM_ENV_SV

// UVM environment for the adder module
class adder_env extends uvm_env;
  // Components
  adder_vseq seq;
  adder_agent agent;
  adder_scoreboard scoreboard;
  
  // UVM factory registration
  `uvm_component_utils(adder_env)
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agent = adder_agent::type_id::create("agent", this);
    scoreboard = adder_scoreboard::type_id::create("scoreboard", this);
  endfunction
  
  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Connect agent to scoreboard
    agent.monitor.ap.connect(scoreboard.in_port);
  endfunction
  
endclass

`endif // UVM_ENV_SV
