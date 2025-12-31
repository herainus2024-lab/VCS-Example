#!/bin/bash

# ============================================================================
# UVM 编译脚本（备用方案）
# 适用于 VCS 2018 或遇到 -ntb_opts 问题时
# 手动指定 UVM 库路径
# ============================================================================

echo "============================================"
echo "  Compiling UVM Testbench for Adder"
echo "  (Alternative method for VCS 2018)"
echo "============================================"

# 创建 sim 目录（如果不存在）
mkdir -p sim

# 自动检测 VCS 安装路径中的 UVM 库
VCS_HOME=${VCS_HOME:-/home/binwang/software/vcs2018/vcs/O-2018.09-SP2}
UVM_HOME=${VCS_HOME}/etc/uvm-1.1

# 如果 uvm-1.1 不存在，尝试其他版本
if [ ! -d "$UVM_HOME" ]; then
    UVM_HOME=${VCS_HOME}/etc/uvm
fi

echo "Using UVM from: $UVM_HOME"

vcs -full64 \
    -sverilog \
    -timescale=1ns/1ps \
    -fsdb \
    -kdb \
    +incdir+${UVM_HOME}/src \
    +incdir+src/uvm \
    +define+VCS \
    +define+UVM_NO_DPI \
    -debug_access+all \
    -l sim/compile.log \
    ${UVM_HOME}/src/uvm_pkg.sv \
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
    echo "  Trying without DPI..."
    echo "============================================"
    
    # 再次尝试，完全禁用 DPI
    vcs -full64 \
        -sverilog \
        -timescale=1ns/1ps \
        -fsdb \
        -kdb \
        +incdir+${UVM_HOME}/src \
        +incdir+src/uvm \
        +define+VCS \
        +define+UVM_NO_DPI \
        +define+UVM_HDL_NO_DPI \
        +define+UVM_REGEX_NO_DPI \
        -debug_access+all \
        -l sim/compile.log \
        ${UVM_HOME}/src/uvm_pkg.sv \
        src/adder.v \
        src/uvm/adder_if.sv \
        src/uvm/adder_pkg.sv \
        src/uvm/tb_top.sv \
        -o sim/simv_uvm
    
    if [ $? -eq 0 ]; then
        echo "============================================"
        echo "  Compilation successful (no DPI)!"
        echo "  Output: sim/simv_uvm"
        echo "============================================"
    else
        echo "============================================"
        echo "  Compilation FAILED!"
        echo "  Check sim/compile.log for details"
        echo "============================================"
        exit 1
    fi
fi

