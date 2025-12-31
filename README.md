# VCS 示例工程

本工程由多个脚本、Verilog 源代码文件和 UVM 验证环境构成，用于演示 VCS 和 UVM 验证方法学。

## 项目结构

```
VCS-Example/
├── src/
│   ├── adder.v              # 32位加法器设计 (DUT)
│   ├── tb.v                  # 简单 Verilog Testbench
│   └── uvm/                  # UVM 验证环境
│       ├── adder_if.sv       # 接口定义
│       ├── adder_transaction.sv  # 事务类
│       ├── adder_sequence.sv     # 测试序列
│       ├── adder_sequencer.sv    # 序列器
│       ├── adder_driver.sv       # 驱动器
│       ├── adder_monitor.sv      # 监控器
│       ├── adder_scoreboard.sv   # 记分板
│       ├── adder_coverage.sv     # 覆盖率收集器
│       ├── adder_agent.sv        # Agent
│       ├── adder_env.sv          # 验证环境
│       ├── adder_test.sv         # 测试用例
│       ├── adder_pkg.sv          # Package
│       └── tb_top.sv             # 顶层 Testbench
├── compile.sh                # 简单 TB 编译脚本
├── compile_uvm.sh            # UVM 编译脚本
├── run.sh                    # 简单 TB 运行脚本
├── run_uvm.sh                # UVM 运行脚本
├── verdi.sh                  # Verdi 波形查看
└── clean.sh                  # 清理脚本
```

---

## 简单 Testbench（原有功能）

### 编译
执行 `./compile.sh` 即可编译工程，编译后的可执行文件为 `sim/simv`。

### 运行
执行 `./run.sh`（或进入 sim 文件夹并执行 `./simv`）即可开始仿真，仿真完后自动退出。

---

## UVM 验证环境

### 编译 UVM 测试环境
```bash
./compile_uvm.sh
```
编译成功后生成 `sim/simv_uvm`。

### 运行 UVM 测试
```bash
# 运行默认随机测试
./run_uvm.sh

# 运行特定测试
./run_uvm.sh adder_random_test    # 随机测试 (100 个事务)
./run_uvm.sh adder_directed_test  # 定向测试 (特定值)
./run_uvm.sh adder_corner_test    # 边界测试 (边界值)
./run_uvm.sh adder_full_test      # 完整测试 (所有序列)
```

### UVM 验证架构

```
                    ┌─────────────────────────────────────────┐
                    │              adder_test                 │
                    └─────────────────┬───────────────────────┘
                                      │
                    ┌─────────────────▼───────────────────────┐
                    │              adder_env                  │
                    │  ┌──────────────────────────────────┐   │
                    │  │          adder_agent             │   │
                    │  │  ┌─────────┐  ┌──────────────┐   │   │
                    │  │  │sequencer│──│    driver    │───┼───┼──► DUT
                    │  │  └────┬────┘  └──────────────┘   │   │
                    │  │       │                          │   │
                    │  │  ┌────▼────┐                     │   │
                    │  │  │sequence │                     │   │
                    │  │  └─────────┘  ┌──────────────┐   │   │
                    │  │               │   monitor    │◄──┼───┼─── DUT
                    │  │               └──────┬───────┘   │   │
                    │  └──────────────────────┼───────────┘   │
                    │                         │               │
                    │  ┌──────────────────────▼───────────┐   │
                    │  │          scoreboard              │   │
                    │  └──────────────────────────────────┘   │
                    │  ┌──────────────────────────────────┐   │
                    │  │          coverage                │   │
                    │  └──────────────────────────────────┘   │
                    └─────────────────────────────────────────┘
```

---

## 查看仿真波形
执行 `./verdi.sh` 文件即可启动 Verdi 查看仿真波形。

在 Verdi 中，查看源代码并选择想要查看的信号，按 Ctrl+W 即可将其导入波形查看界面。更多使用方式请看教程网站。

## 清理
运行 `./clean.sh` 即可清除编译出的可执行文件、临时文件和仿真波形。源代码不会被清除。
