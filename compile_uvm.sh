#!/bin/bash

# ============================================================================
# UVM 编译脚本
# 用于编译 UVM 验证环境
# ============================================================================

# 编译选项说明：
# -full64         : 使用 64 位 VCS
# -sverilog       : 支持 SystemVerilog 语法
# -ntb_opts uvm   : 启用 UVM 支持（VCS 内置 UVM 库）
# -timescale      : 时间精度
# -fsdb           : 支持 FSDB 波形输出
# -kdb            : 生成 Verdi 数据库
# +incdir+        : include 文件搜索路径
# -o              : 输出可执行文件路径
# +define+VCS     : 定义 VCS 宏

echo "============================================"
echo "  Compiling UVM Testbench for Adder"
echo "============================================"

vcs -full64 \
    -sverilog \
    -ntb_opts uvm-1.2 \
    -timescale=1ns/1ps \
    -fsdb \
    -kdb \
    +incdir+src/uvm \
    +define+VCS \
    -debug_access+all \
    -l sim/compile.log \
    src/adder.v \
    src/uvm/adder_if.sv \
    src/uvm/adder_pkg.sv \
    src/uvm/tb_top.sv \
    -o sim/simv_uvm

if [ $? -eq 0 ]; then
    echo "============================================"
    echo "  Compilation successful!"
    echo "  Output: sim/simv_uvm"
    echo "============================================"
else
    echo "============================================"
    echo "  Compilation FAILED!"
    echo "  Check sim/compile.log for details"
    echo "============================================"
    exit 1
fi

