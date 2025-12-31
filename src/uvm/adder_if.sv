`ifndef ADDER_IF_SV
`define ADDER_IF_SV

// ============================================================================
// Adder Interface
// 定义 DUT 的接口信号，用于连接 UVM 组件和 DUT
// ============================================================================
interface adder_if(input logic clk);
  
  // 输入信号
  logic [31:0] in1;
  logic [31:0] in2;
  
  // 输出信号
  logic [31:0] out;
  
  // Driver Clocking Block - 用于驱动输入
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output in1;
    output in2;
    input  out;
  endclocking
  
  // Monitor Clocking Block - 用于采样信号
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input in1;
    input in2;
    input out;
  endclocking
  
  // Driver Modport
  modport driver_mp (clocking driver_cb, input clk);
  
  // Monitor Modport  
  modport monitor_mp (clocking monitor_cb, input clk);

endinterface : adder_if

`endif

