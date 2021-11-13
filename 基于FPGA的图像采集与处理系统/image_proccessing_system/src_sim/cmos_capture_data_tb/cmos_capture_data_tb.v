// *********************************************************************************
// 文件名: cmos_capture_data_tb.v
// 创建人: 梁辉鸿
// 创建日期: 2021.4.3
// 联系方式: 17hhliang3@stu.edu.cn
// --------------------------------------------------------------------------------- 
// 模块名: cmos_capture_data_tb
// 发布版本号: V0.0
// --------------------------------------------------------------------------------- 
// 功能说明: 1)Testbench for 图像数据采集模块
//
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
`timescale  1ns/1ns

// ---------------------------------------------------------------------------------
// 常量参数 Constant Parameters
// ---------------------------------------------------------------------------------


// ---------------------------------------------------------------------------------
// 模块定义 Module Define
// --------------------------------------------------------------------------------- 
    module cmos_capture_data_tb;

// ---------------------------------------------------------------------------------
// 局部常量 Local Constant Parameters
// ---------------------------------------------------------------------------------
    localparam   T = 40;                             //系统时钟周期, 24MHz

// ---------------------------------------------------------------------------------
// 模块内变量定义 Module_Variables
// --------------------------------------------------------------------------------- 
    // output signal
    reg             sys_rst_n;
    reg             sys_init_done;
    reg             cam_pclk;
    reg             cam_vsync;
    reg             cam_href;
    reg    [ 7 : 0] cam_data;
    
    
    // input signal
    wire            cmos_frame_vsync;
    wire            cmos_frame_href;
    wire            cmos_frame_valid;
    wire   [15 : 0] cmos_frame_data;   
    
// ---------------------------------------------------------------------------------
// 数据流描述 Continuous Assignments
// --------------------------------------------------------------------------------- 


// ---------------------------------------------------------------------------------
// 结构化描述 Moudle Instantiate
// ---------------------------------------------------------------------------------
    // CMOS图像数据采集模块
    cmos_capture_data       U_cmos_capture_data
    (
        // clock & reset
        .rst_n  		        (sys_rst_n & sys_init_done),    //系统初始化完成后再开始采集数据

        // 摄像头接口
        .cam_pclk               (cam_pclk),
        .cam_vsync              (cam_vsync),
        .cam_href               (cam_href),
        .cam_data               (cam_data),

        // 用户接口
        .cmos_frame_vsync       (cmos_frame_vsync),
        .cmos_frame_href        (cmos_frame_href),
        .cmos_frame_valid       (cmos_frame_valid),
        .cmos_frame_data        (cmos_frame_data)
    );

// ---------------------------------------------------------------------------------
// 行为描述 Clocked Assignments
// ---------------------------------------------------------------------------------
    initial
    begin
        // Initialize Inputs
                sys_rst_n     = 1'b0;
                sys_init_done = 1'b1;
                cam_pclk      = 1'b0;
                cam_vsync     = 1'b0;
                cam_href      = 1'b0;
                cam_data      = 8'h00;
        
        // Wait for global reset to finish
        #(T*5)  sys_rst_n   = 1'b1;
                
        // Add stimulus here
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        #(T*100) cam_vsync  = 1'b1;
        #(T*500) cam_vsync  = 1'b0;
        
        #(T*1000) cam_href  = 1'b1;
        #(T*1)    cam_data   = 8'h12; 
        #(T*1)    cam_data   = 8'h34;
        #(T*1)    cam_data   = 8'h56;
        #(T*1)    cam_data   = 8'h78;
        #(T*1)    cam_data   = 8'h90;
        #(T*1)    cam_data   = 8'hab;
        #(T*1)    cam_data   = 8'hcd;
        #(T*1)    cam_data   = 8'h00;
        
        #(T*1000) cam_href   = 1'b0;
        // Finish
        //#(T*10000) $stop;
    end
    
    // Generate global clk
    always #(T/2) cam_pclk = ~cam_pclk;
    
// ---------------------------------------------------------------------------------
// 任务定义 Called Tasks
// ---------------------------------------------------------------------------------
    
	
// ---------------------------------------------------------------------------------
// 函数定义 Called Functions
// ---------------------------------------------------------------------------------

    
endmodule 