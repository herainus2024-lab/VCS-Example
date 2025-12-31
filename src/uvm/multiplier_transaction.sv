`ifndef MULTIPLIER_TRANSACTION_SV
`define MULTIPLIER_TRANSACTION_SV

// ============================================================================
// Multiplier Transaction (Sequence Item)
// 定义验证中传递的事务数据结构
// ============================================================================
class multiplier_transaction extends uvm_sequence_item;
  
  // 随机化输入 (16-bit for 16-bit multiplier)
  rand bit [15:0] in1;
  rand bit [15:0] in2;
  
  // 输出结果（非随机，32-bit product）
  bit [31:0] out;
  
  // 约束：限制随机值范围（16-bit范围）
  constraint c_in1 { in1 inside {[0:16'hFFFF]}; }
  constraint c_in2 { in2 inside {[0:16'hFFFF]}; }
  
  // 边界值约束（可选，用于边界测试）
  constraint c_corner_cases {
    soft in1 dist {
      0           := 5,
      16'hFFFF    := 5,
      [1:16'hFFFE] := 90
    };
    soft in2 dist {
      0           := 5,
      16'hFFFF    := 5,
      [1:16'hFFFE] := 90
    };
  }
  
  // UVM 宏：注册到工厂，支持 field automation
  `uvm_object_utils_begin(multiplier_transaction)
    `uvm_field_int(in1, UVM_ALL_ON)
    `uvm_field_int(in2, UVM_ALL_ON)
    `uvm_field_int(out, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // 构造函数
  function new(string name = "multiplier_transaction");
    super.new(name);
  endfunction : new
  
  // 转换为字符串（用于调试）
  virtual function string convert2string();
    return $sformatf("in1=0x%08h, in2=0x%08h, out=0x%08h", in1, in2, out);
  endfunction : convert2string

endclass : multiplier_transaction

`endif
