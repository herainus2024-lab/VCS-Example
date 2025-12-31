#!/bin/bash

# ============================================================================
# UVM 运行脚本
# 用于运行 UVM 测试
# ============================================================================

# 默认测试名称
TEST_NAME=${1:-adder_random_test}

echo "============================================"
echo "  Running UVM Test: $TEST_NAME"
echo "============================================"

cd sim

./simv_uvm \
    +UVM_TESTNAME=$TEST_NAME \
    +UVM_VERBOSITY=UVM_MEDIUM \
    -l run_$TEST_NAME.log

if [ $? -eq 0 ]; then
    echo "============================================"
    echo "  Simulation complete!"
    echo "  Log: sim/run_$TEST_NAME.log"
    echo "============================================"
else
    echo "============================================"
    echo "  Simulation FAILED!"
    echo "============================================"
fi

cd ..

# ============================================================================
# 使用示例：
# ./run_uvm.sh                       # 运行默认随机测试
# ./run_uvm.sh adder_random_test     # 运行随机测试
# ./run_uvm.sh adder_directed_test   # 运行定向测试
# ./run_uvm.sh adder_corner_test     # 运行边界测试
# ./run_uvm.sh adder_full_test       # 运行完整测试
# ============================================================================


