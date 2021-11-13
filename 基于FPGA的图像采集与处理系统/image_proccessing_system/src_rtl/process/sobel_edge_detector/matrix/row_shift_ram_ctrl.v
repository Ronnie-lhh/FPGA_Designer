// ********************************************************************************* 
// 文件名: row_shift_ram_ctrl.v
// 创建人: 梁辉鸿
// 创建日期: 2021.3.25
// 联系方式: 17hhliang3@stu.edu.cn
// --------------------------------------------------------------------------------- 
// 模块名: row_shift_ram_ctrl
// 发布版本号: V0.0
// --------------------------------------------------------------------------------- 
// 功能说明: 1)实现行移位存储的双端口RAM控制模块
//            2)例化2个双端口RAM(512 x 8)
//             3)RAM0存储前一行图像的数据, RAM1存储前前一行图像的数据
//              4)2个RAM间实现行的移位存储, 时序关系较复杂
// --------------------------------------------------------------------------------- 
// 变更描述:
//    
// ---------------------------------------------------------------------------------
// 发布记录:
//  			  
// ---------------------------------------------------------------------------------
// *********************************************************************************


// ---------------------------------------------------------------------------------
// 引用文件 Include File
// --------------------------------------------------------------------------------- 

// ---------------------------------------------------------------------------------
// 仿真时间 Simulation Timescale
// ---------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------
// 常量参数 Constant Parameters
// ---------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------
// 模块定义 Module Define
// --------------------------------------------------------------------------------- 
module row_shift_ram_ctrl
(
    // clock & reset
    input 			    clk,	                //时钟信号
    input               rst_n,                  //复位信号, 低电平有效

    // input signal
    input               ycbcr_hs,               //hsync信号
    input               ycbcr_de,               //data enable信号
    input      [ 7 : 0] ycbcr_y,                //当前行的灰度数据
    
    // output signal
    output     [ 7 : 0] pre_row0,               //RAM0存储的, 前一行数据
    output     [ 7 : 0] pre_row1                //RAM1存储的, 前前一行数据
);

// ---------------------------------------------------------------------------------
// 局部常量 Local Constant Parameters
// ---------------------------------------------------------------------------------
    localparam  CMOS_H_PIXEL = 9'd480;          //一帧图像每行像素个数
   
// ---------------------------------------------------------------------------------
// 模块内变量定义 Module_Variables
// --------------------------------------------------------------------------------- 
    reg        [ 2 : 0] ycbcr_de_d;             //数据有效使能信号的三级寄存
    reg        [ 8 : 0] ram_rd_addr;            //RAM读地址
    reg        [ 8 : 0] ram_rd_addr_d0;         //RAM读地址的一级寄存
    reg        [ 8 : 0] ram_rd_addr_d1;         //RAN读地址的二级寄存
    reg        [ 7 : 0] ycbcr_y_d0;             //当前行数据的一级寄存
    reg        [ 7 : 0] ycbcr_y_d1;             //当前行数据的二级寄存
    reg        [ 7 : 0] ycbcr_y_d2;             //当前行数据的三级寄存
    reg        [ 7 : 0] pre_row0_d0;            //前一行数据的一级寄存
    
// ---------------------------------------------------------------------------------
// 数据流描述 Continuous Assignments
// ---------------------------------------------------------------------------------    


// ---------------------------------------------------------------------------------
// 行为描述 Clocked Assignments
// ---------------------------------------------------------------------------------
    // 数据到来时, RAM读地址累加
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            ram_rd_addr <= 9'd0;
        end
        else if(ycbcr_hs)
        begin
            if(ycbcr_de)
            begin
                if(ram_rd_addr < CMOS_H_PIXEL - 9'd1)
                begin
                    ram_rd_addr <= ram_rd_addr + 9'd1;
                end
                else 
                begin
                    ram_rd_addr <= 9'd0;
                end
            end
            else
            begin
                ram_rd_addr <= ram_rd_addr;
            end
        end
        else
        begin
            ram_rd_addr <= 9'd0;
        end
    end
    
    // 数据有效使能信号延迟3拍, 以同步前一行数据
    // 数据有效使能信号延迟2拍, 以同步前前一行数据
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            ycbcr_de_d <= 3'd0;
        end
        else
        begin
            ycbcr_de_d <= {ycbcr_de_d[1 : 0], ycbcr_de};
        end
    end
    
    // RAM读地址延迟2拍, 用作RAM0写入当前行数据的写地址
    // RAM读地址延迟1拍, 用作RAM1写入前一行数据的写地址
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            ram_rd_addr_d0 <= 9'd0;
            ram_rd_addr_d1 <= 9'd0;
        end
        else
        begin
            ram_rd_addr_d0 <= ram_rd_addr;
            ram_rd_addr_d1 <= ram_rd_addr_d0;
        end
    end
    
    // 当前行数据延迟3拍
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            ycbcr_y_d0 <= 8'd0;
            ycbcr_y_d1 <= 8'd0;
            ycbcr_y_d2 <= 8'd0;
        end
        else
        begin
            ycbcr_y_d0 <= ycbcr_y;
            ycbcr_y_d1 <= ycbcr_y_d0;
            ycbcr_y_d2 <= ycbcr_y_d1;
        end
    end
    
    // 将从RAM0中读出的前一行数据延迟1拍
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            pre_row0_d0 <= 8'd0;
        end
        else
        begin
            pre_row0_d0 <= pre_row0;
        end
    end

// ---------------------------------------------------------------------------------
// 结构化描述 Moudle Instantiate
// ---------------------------------------------------------------------------------
    // RAM0例化--存储前一行数据
    ram_512x8_0     U_ram_512x8_0
    (
        .clka                   (clk),
        .wea                    (ycbcr_de_d[2]), 
        .addra                  (ram_rd_addr_d1),
        .dina                   (ycbcr_y_d2),       //延迟3个时钟周期, 将当前行的数据写入RAM0
        .clkb                   (clk),
        .addrb                  (ram_rd_addr),
        .doutb                  (pre_row0)          //延迟1个时钟周期, 读出RAM0中的前一行数据
    );
    
    // RAM1例化--存储前前一行数据
    ram_512x8_1     U_ram_512x8_1
    (
        .clka                   (clk),
        .wea                    (ycbcr_de_d[1]),
        .addra                  (ram_rd_addr_d0),
        .dina                   (pre_row0_d0),      //延迟2个时钟周期, 将前一行数据写入RAM1
        .clkb                   (clk),
        .addrb                  (ram_rd_addr),
        .doutb                  (pre_row1)          //延迟1个时钟周期, 读出RAM1中的前前一行数据
    );
    
// ---------------------------------------------------------------------------------
// 任务定义 Called Tasks
// ---------------------------------------------------------------------------------

	
// ---------------------------------------------------------------------------------
// 函数定义 Called Functions
// ---------------------------------------------------------------------------------

    
endmodule