`ifndef ADDER_TRANSACTION_SV
`define ADDER_TRANSACTION_SV

// ============================================================================
// Adder Transaction (Sequence Item)
// 定义验证中传递的事务数据结构
// ============================================================================
class adder_transaction extends uvm_sequence_item;
  
  // 随机化输入
  rand bit [31:0] in1;
  rand bit [31:0] in2;
  
  // 输出结果（非随机）
  bit [31:0] out;
  
  // 约束：限制随机值范围（可选）
  constraint c_in1 { in1 inside {[0:32'hFFFF_FFFF]}; }
  constraint c_in2 { in2 inside {[0:32'hFFFF_FFFF]}; }
  
  // 边界值约束（可选，用于边界测试）
  constraint c_corner_cases {
    soft in1 dist {
      0           := 5,
      32'hFFFFFFFF := 5,
      [1:32'hFFFFFFFE] := 90
    };
    soft in2 dist {
      0           := 5,
      32'hFFFFFFFF := 5,
      [1:32'hFFFFFFFE] := 90
    };
  }
  
  // UVM 宏：注册到工厂，支持 field automation
  `uvm_object_utils_begin(adder_transaction)
    `uvm_field_int(in1, UVM_ALL_ON)
    `uvm_field_int(in2, UVM_ALL_ON)
    `uvm_field_int(out, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // 构造函数
  function new(string name = "adder_transaction");
    super.new(name);
  endfunction : new
  
  // 转换为字符串（用于调试）
  virtual function string convert2string();
    return $sformatf("in1=0x%08h, in2=0x%08h, out=0x%08h", in1, in2, out);
  endfunction : convert2string

endclass : adder_transaction

`endif

