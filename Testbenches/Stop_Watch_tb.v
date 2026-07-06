`timescale 1ms/1us
module Stop_Watch_tb;

reg         M_r, S_r;
reg         CLK, RST;
reg   [1:0] Enable;

wire  [2:0] m_1;
wire  [3:0] m_0;
wire  [3:0] s_1;
wire  [3:0] s_0;

wire        Stop_watch_end;

// DUT
Stop_Watch dut (
    .M_r(M_r),
    .S_r(S_r),
    .CLK(CLK),
    .RST(RST),
    .Enable(Enable),
    .m_1(m_1),
    .m_0(m_0),
    .s_1(s_1),
    .s_0(s_0),
    .Stop_watch_end(Stop_watch_end)
);

// Clock = 1ms
always #0.5 CLK = ~CLK;

initial begin
    initialize();

    // ===============================
    // Clear state (default)
    // ===============================
    $display("---- CLEAR STATE ----");
    repeat(10) @(negedge CLK);

    // ===============================
    // Go to ON (start counting)
    // ===============================
    $display("---- ON STATE ----");
    pulse_S();   // Clear -> ON
    repeat(185) @(negedge CLK); // count some time

    // ===============================
    // STOP (pause counting)
    // ===============================
    $display("---- STOP STATE ----");
    pulse_S();   // ON -> STOP
    repeat(30) @(negedge CLK);

    // ===============================
    // Resume ON
    // ===============================
    $display("---- RESUME ON ----");
    pulse_S();   // STOP -> ON
    repeat(100) @(negedge CLK);

    // ===============================
    // SPLIT ON (freeze display, counter continues)
    // ===============================
    $display("---- SPLIT ON ----");
    pulse_M();   // ON -> Split_ON
    repeat(50) @(negedge CLK);

    // ===============================
    // SPLIT STOP (freeze display + counter stopped)
    // ===============================
    $display("---- SPLIT STOP ----");
    pulse_S();   // Split_ON -> Split_STOP
    repeat(50) @(negedge CLK);

    // ===============================
    // Back to STOP
    // ===============================
    $display("---- BACK TO STOP ----");
    pulse_M();   // Split_STOP -> STOP
    repeat(30) @(negedge CLK);

    // ===============================
    // Clear again
    // ===============================
    $display("---- CLEAR AGAIN ----");
    pulse_M();   // STOP -> Clear
    repeat(30) @(negedge CLK);

    $stop;
end

// Monitor
initial begin
    $monitor("T=%0t  -- > S_r=%b M_r=%b | I_Time_counter = %0d:%0d | Split_time= %0d:%0d |MUX_Out =%0b -->  O_Time= %0d%0d:%0d%0d " ,
              $time, S_r, M_r, dut.mm_I, dut.ss_I , dut.mm_split, dut.ss_split, dut.Mux_out, m_1, m_0, s_1, s_0);
end

// ===============================
// Tasks
// ===============================
task initialize;
begin
    CLK       = 0;
    RST       = 0;
    S_r       = 0;
    M_r       = 0;
    Enable    = 2'b10;   // always enabled

    repeat(2) @(negedge CLK);
    RST = 1;
end
endtask

task pulse_S;
begin
    S_r = 1;
    @(negedge CLK);
    S_r = 0;
end
endtask

task pulse_M;
begin
    M_r = 1;
    @(negedge CLK);
    M_r = 0;
end
endtask

endmodule
