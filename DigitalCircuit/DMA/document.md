# 直接内存存取(DMA)开发文档

## 数字电路期末实验-小组作业

小组成员: 王华强 刘蕴哲 蔡昕

***

## 整体概述

整个项目由五个模块组成. 其中DMA本身采用了模块化设计, 由两个FIFO模块和外部控制逻辑组成. 各个模块的简要说明和接口设置如下所示:

### DMA模块
```verilog
module DMA(

input clk,
input resetn,
input mode,              //模式选择:控制DMA的工作方式:内存->CPU 或 CPU->内存

input dma_to_mem_enable, //MEM是否准备好接收数据。
input mem_to_dma_valid, //MEM中传入的数据是否有效。
input dma_to_cpu_enable, //CPU是否准备好接收数据。
input cpu_to_dma_valid, //CPU传入的数据是否有效。

input [3:0] mem_data_out, //内存信号输出
input [7:0] cpu_data_out,  //中央处理器信号输出

output dma_to_mem_valid, //向MEM传出的数据是否有效
output mem_to_dma_enable, //DMA准备好自MEM接收数据
output cpu_to_dma_enable, //DMA准备好自CPU接收数据
output dma_to_cpu_valid, //向CPU传出的数据是否有效

output [3:0] mem_data_in, //内存信号输入
output [7:0] cpu_data_in  //中央处理器信号输入
);
```
### FIFO模块
```verilog
module FIFO(
    input clk,
    input resetn,
    input workmode,
    input input_valid, output_enable,
    input [7:0] fifo_in,
    output reg[7:0] fifo_out,
    output reg output_valid,
    output reg input_enable,
    output empty,
    output full
);
```

### TESTBENCH

### 模拟CPU模块

### 模拟MEM模块


## 设计特色

* 地址访问
* 模块化设计
* 使用状态机
* 完善的自动测试模块

## DMA模块

## FIFO模块

## TESTBENCH

### 整体设计

### 模拟CPU模块

### 模拟MEM模块


## 关于地址访问


Copyright (c) 2017 Augustus Wang.