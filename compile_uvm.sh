#!/bin/bash

# ============================================================================
# UVM 编译脚本
# 适用于 VCS 2018 + 新版 GCC 的兼容方案
# 通过禁用 DPI 避免 UVM C 代码编译问题
# ============================================================================

echo "============================================"
echo "  Compiling UVM Testbench for Multiplier"
echo "  (VCS 2018 + New GCC Compatible)"
echo "============================================"

# 创建 sim 目录（如果不存在）
mkdir -p sim

# 清理旧的编译产物（避免缓存问题）
echo "Cleaning previous build artifacts..."
rm -rf sim/simv_uvm sim/simv_uvm.daidir sim/csrc sim/AN.DB
rm -f sim/compile.log sim/ucli.key

# 自动检测 VCS 安装路径中的 UVM 库
VCS_HOME=${VCS_HOME:-/home/binwang/software/vcs2018/vcs/O-2018.09-SP2}
UVM_HOME=${VCS_HOME}/etc/uvm

echo "VCS_HOME: $VCS_HOME"
echo "UVM_HOME: $UVM_HOME"

# 检查 UVM 路径是否存在
if [ ! -d "$UVM_HOME" ]; then
    echo "ERROR: UVM_HOME not found at $UVM_HOME"
    exit 1
fi

# 编译选项：
# +define+UVM_NO_DPI          : 禁用 UVM DPI（避免 C 代码编译问题）
# +define+UVM_HDL_NO_DPI      : 禁用 HDL DPI
# +define+UVM_REGEX_NO_DPI    : 禁用正则表达式 DPI
# +define+UVM_CMDLINE_NO_DPI  : 禁用命令行 DPI
# +define+UVM_NO_DEPRECATED   : 禁用弃用的功能
# 注意：不使用 -ntb_opts uvm，直接编译 uvm_pkg.sv

echo "Starting VCS compilation..."

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
    +define+UVM_CMDLINE_NO_DPI \
    +define+UVM_NO_DEPRECATED \
    -debug_access+all \
    -lca \
    -l sim/compile.log \
    ${UVM_HOME}/src/uvm_pkg.sv \
    src/multiplier.v \
    src/uvm/multiplier_if.sv \
    src/uvm/multiplier_pkg.sv \
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
