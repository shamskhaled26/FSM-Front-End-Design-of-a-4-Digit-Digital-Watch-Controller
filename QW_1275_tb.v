`timescale 1ms/1us
module QW_1275_tb();

reg mode,set;
reg CLK,RST;

wire [3:0] Digit_3_tb;
wire [3:0] Digit_2_tb;
wire [3:0] Digit_1_tb;
wire [3:0] Digit_0_tb;

wire [1:0] Alarm_state;
wire       Alarm_Signal;
wire       hourly_signal;

top_module top_dut(
    .mode(mode),
    .set(set),
    .CLK(CLK),
    .RST(RST),

    .Digit_3(Digit_3_tb),
    .Digit_2(Digit_2_tb),
    .Digit_1(Digit_1_tb),
    .Digit_0(Digit_0_tb),

    .Alarm_Signal(Alarm_Signal),
    .hourly_signal(hourly_signal),   // 1-sec pulse every hour if enabled
    .Alarm_state(Alarm_state)
);


always #0.5 CLK = ~CLK;

initial begin 

    ////////////////////////////////////////////////////////////
    // ---------- INITIALIZE & RESET ----------
    ////////////////////////////////////////////////////////////
    $display("\n========== INITIALIZATION START ==========");
    initialize();
    reset();
    repeat(25) @(negedge CLK);

    ////////////////////////////////////////////////////////////
    // ---------- DISPLAY MODE ----------
    ////////////////////////////////////////////////////////////
    $display("\n========== DISPLAY MODE TEST START ==========");
    check_time_display(); // task to check time in display mode
    repeat(50) @(negedge CLK);

    ////////////////////////////////////////////////////////////
    // ---------- ALARM MODE ----------
    ////////////////////////////////////////////////////////////
    $display("\n========== ALARM MODE TEST START ==========");
    press_M(); // move from Timekeeping >> Alarm
    edit_alarm_time();      // task to edit alarm
    toggle_alarm_states();  // task to toggle alarm states
    repeat(10) @(negedge CLK);
    
    ////////////////////////////////////////////////////////////
    // ---------- STOPWATCH MODE ----------
    ////////////////////////////////////////////////////////////
    press_M(); // move from Alarm >> Stopwatch
    $display("\n========== STOPWATCH MODE TEST START ==========");
    repeat(10) @(negedge CLK);
    check_Stop_Watch(); // task to test stopwatch
    repeat(20) @(negedge CLK);

    ////////////////////////////////////////////////////////////
    // ---------- TIME SET MODE ----------
    ////////////////////////////////////////////////////////////
    press_M(); // move from Stopwatch >> Time Set
    $display("\n========== TIME SET MODE TEST START ==========");
    repeat(10) @(negedge CLK);
    check_time_set(); // task to test time set mode
    repeat(10) @(negedge CLK);

    ////////////////////////////////////////////////////////////
    // ---------- EXIT TIME SET ----------
    ////////////////////////////////////////////////////////////
    press_M(); // exit time set mode
    repeat(30) @(negedge CLK);

    ////////////////////////////////////////////////////////////
    // ---------- check_alarm_stop_by_press_s ----------
    ////////////////////////////////////////////////////////////
    wait (Alarm_Signal == 1'b1);
    repeat(30) @(negedge CLK);
    wait (Alarm_Signal == 1'b0);
    repeat(30) @(negedge CLK);

    check_alarm_stop_by_press_s;

    repeat(2000) @(negedge CLK);

    ////////////////////////////////////////////////////////////
    $display("\n========== SIMULATION END ==========");
    $stop;
end


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK) begin
    if (top_dut.fsm.enable == 'b00) begin 
        if (Alarm_Signal) begin
            $display(">>> [DAILY ALARM] at TIME=%0d%0d:%0d%0d",
                        Digit_3_tb, 
                        Digit_2_tb, 
                        Digit_1_tb, 
                        Digit_0_tb);
        end
        // HOURLY ALARM
        if (hourly_signal) begin
            $display(">>> [HOURLY ALARM] at TIME=%0d%0d:%0d%0d",
                    Digit_3_tb, 
                    Digit_2_tb,
                    Digit_1_tb, 
                    Digit_0_tb);
        end
    end
        case (top_dut.fsm.enable)
            2'b00, 2'b11: begin
                $display("time=%0t ,hour=%0d%0d , min=%0d%0d",
                        $time,
                        Digit_3_tb, Digit_2_tb,
                        Digit_1_tb, Digit_0_tb);
            end
            2'b10: begin
                $display(
                "time=%0t -----> Main Time : hour=%0d%0d , min=%0d%0d -----> S_r=%b M_r=%b | I_Time=%0d:%0d | Split=%0d:%0d | MUX=%0b --> %0d%0d:%0d%0d",
                $time,
                top_dut.time_display_set.hh_1,
                top_dut.time_display_set.hh_0,
                top_dut.time_display_set.mm_1,
                top_dut.time_display_set.mm_0,
                top_dut.S_r,
                top_dut.M_r,
                top_dut.Stop_Watch.mm_I,
                top_dut.Stop_Watch.ss_I,
                top_dut.Stop_Watch.mm_split,
                top_dut.Stop_Watch.ss_split,
                top_dut.Stop_Watch.Mux_out,
                Digit_3_tb, Digit_2_tb,
                Digit_1_tb, Digit_0_tb
                );
            end
        endcase
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

task initialize;
    begin
        CLK  ='b0;
        mode ='b0;
        set  ='b0;
    end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task reset;
    begin
        RST=0;
        repeat(20)@(negedge CLK);
        RST=1;
    end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task press_S;
begin
    set = 1;
    repeat(3)@(negedge CLK);
    set = 0;
end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task press_M;
begin
    mode = 1;
    repeat(3)@(negedge CLK);
    mode = 0;
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
endtask
task check_time_display;
    begin       
    mode ='h0;// check display mode running 
    repeat(7000)@(negedge CLK);
    end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task check_time_set;
    begin       
        $display("\n[Time Set Mode] Starting time set operation");

        // ---------- HH Tens ----------
        $display("\n[Time Set] Editing HH tens (hh_1)");
        press_S(); repeat(5)@(negedge CLK); $display("[%0t] HH tens incremented -> hh_1 = %0d", $time, top_dut.time_display_set.hh_1);
        press_S(); repeat(5)@(negedge CLK); $display("[%0t] HH tens incremented -> hh_1 = %0d", $time, top_dut.time_display_set.hh_1);



        // ---------- HH Units ----------
        repeat(5)@(negedge CLK);
        $display("\n[Time Set] Editing HH units (hh_0)");
        press_M();
        repeat(5)@(negedge CLK);
        press_S(); repeat(5)@(negedge CLK); $display("[%0t] hh_0 increment = %0d", $time, top_dut.time_display_set.hh_0);

      

        // ---------- MM Tens ----------
        $display("\n[Time Set] Editing MM tens (mm_1)");
        press_M();
        @(negedge CLK);
        press_S(); repeat(5)@(negedge CLK); $display("[%0t] mm_1 increment = %0d", $time, top_dut.time_display_set.mm_1);

        // ---------- MM Units ----------
        $display("\n[Time Set] Editing MM units (mm_0)");
        press_M();
        @(negedge CLK);
        press_S(); repeat(5)@(negedge CLK); $display("[%0t] mm_0 increment = %0d", $time, top_dut.time_display_set.mm_0);
        press_S(); repeat(10)@(negedge CLK); $display("[%0t] mm_0 increment = %0d", $time, top_dut.time_display_set.mm_0);
        press_S(); repeat(10)@(negedge CLK); $display("[%0t] mm_0 increment = %0d", $time, top_dut.time_display_set.mm_0);
        press_S(); repeat(10)@(negedge CLK); $display("[%0t] mm_0 increment = %0d", $time, top_dut.time_display_set.mm_0);
        press_S(); repeat(10)@(negedge CLK); $display("[%0t] mm_0 increment = %0d", $time, top_dut.time_display_set.mm_0);

        // ---------- FINAL TIME ----------
        $display("\n[Time Set] Final set time: %0d%0d:%0d%0d",
            top_dut.time_display_set.hh_1,
            top_dut.time_display_set.hh_0,
            top_dut.time_display_set.mm_1,
            top_dut.time_display_set.mm_0
        );
    end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task check_Stop_Watch;
    begin       
    // ===============================
    // Clear state (default)
    // ===============================
    $display("---- CLEAR STATE ----");
    repeat(10) @(negedge CLK);

    // ===============================
    // Go to ON (start counting)
    // ===============================
    $display("---- ON STATE ----");
    press_S;    // Clear -> ON
    repeat(30) @(negedge CLK); // count some time

    // ===============================
    // STOP (pause counting)
    // ===============================
    $display("---- STOP STATE ----");
    press_S;    // ON -> STOP
    repeat(10) @(negedge CLK);

    // ===============================
    // Resume ON
    // ===============================
    $display("---- RESUME ON ----");
    press_S;    // STOP -> ON
    repeat(20) @(negedge CLK);

    // ===============================
    // SPLIT ON (freeze display, counter continues)
    // ===============================
    $display("---- SPLIT ON ----");
    press_M;   // ON -> Split_ON
    repeat(20) @(negedge CLK);

    // ===============================
    // SPLIT STOP (freeze display + counter stopped)
    // ===============================
    $display("---- SPLIT STOP ----");
    press_S;    // Split_ON -> Split_STOP
    repeat(20) @(negedge CLK);

    // ===============================
    // Back to STOP
    // ===============================
    $display("---- BACK TO STOP ----");
    press_M;   // Split_STOP -> STOP
    repeat(10) @(negedge CLK);

    // ===============================
    // Clear again
    // ===============================
    $display("---- CLEAR AGAIN ----");
    press_M;   // STOP -> Clear
    repeat(15) @(negedge CLK);

    end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task edit_alarm_time;
begin
        // ==================================================
        // HH TENS
        // ==================================================
        $display("\n[EDIT] HH TENS");
        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] HH TENS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] HH TENS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        // ==================================================
        // HH UNITS
        // ==================================================
        $display("\n[EDIT] HH UNITS");
        press_M;
        repeat(3) @(negedge CLK);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] HH UNITS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] HH UNITS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] HH UNITS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        
        // ==================================================
        // MM TENS
        // ==================================================
        $display("\n[EDIT] MM TENS");
        press_M;
        repeat(3) @(negedge CLK);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] MM TENS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] MM TENS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] MM TENS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        // ==================================================
        // MM UNITS
        // ==================================================
        $display("\n[EDIT] MM UNITS");
        press_M;
        repeat(3) @(negedge CLK);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] MM UNITS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] MM UNITS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

        press_S; 
        repeat(3) @(negedge CLK);
        $display("[%0t] MM UNITS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);


        @(negedge CLK);
        $display("Daily Alarm at %0d%0d:%0d%0d",
                Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);    
end
endtask

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task toggle_alarm_states;
begin
    // ==================================================
    // STATE TOGGLE
    // ==================================================
    press_M;
    repeat(3) @(negedge CLK);

    $display("\n[STATE TOGGLE]");
    press_S; repeat(3) @(negedge CLK);
    $display("state=%b (Both OFF)",Alarm_state);
    press_S; repeat(3) @(negedge CLK);
    $display("state=%b (Daily ON)",Alarm_state);
    press_S; repeat(3) @(negedge CLK);
    $display("state=%b (Hourly ON)",Alarm_state);
    press_S; repeat(3) @(negedge CLK);
    $display("state=%b (Both ON)",Alarm_state);
end
endtask



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
task check_alarm_stop_by_press_s;
begin
    $display("\n========== ALARM STOP BY PRESS_S TEST ==========\n");
    repeat(5) @(negedge CLK);

    // ==================================================
    // 1) Ensure we are in Alarm Mode
    // ==================================================
    press_M; // Timekeeping -> Alarm
    $display("press_M : Timekeeping -> Alarm\n ");
    repeat(5) @(negedge CLK);

    // ==================================================
    // 2) Set Alarm = 00:10
    // Digits: HH:MM
    // ==================================================
    $display("Current Alarm is at -->  %0d%0d:%0d%0d\n",
        Digit_3_tb, Digit_2_tb, Digit_1_tb, Digit_0_tb);  // 23:33 --> 00:03 

    $display("Setting alarm once again : ");

    // HH tens = 0
    $display("[%0t] HH TENS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

    // HH units = 0
    press_M; repeat(2) @(negedge CLK);
   
    $display("[%0t] HH UNITS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

    // MM tens = 0
    press_M; repeat(2) @(negedge CLK);
    $display("[%0t] MM TENS -> %0d%0d:%0d%0d",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);
    
    // MM units = 3
    press_M; repeat(2) @(negedge CLK);
    press_S; repeat(2) @(negedge CLK);
    press_S; repeat(2) @(negedge CLK);
    press_S; repeat(2) @(negedge CLK);
    press_S; repeat(2) @(negedge CLK);
    press_S; repeat(2) @(negedge CLK);
    $display("[%0t] MM UNITS -> %0d%0d:%0d%0d\n",$time,
            Digit_3_tb,Digit_2_tb,Digit_1_tb,Digit_0_tb);

    $display("[ALARM SET] Alarm = %0d%0d:%0d%0d\n",
        Digit_3_tb, Digit_2_tb, Digit_1_tb, Digit_0_tb);

    // ==================================================
    // 3) Enable Daily Alarm only
    // ==================================================
    press_M; // go to alarm state toggle
    repeat(3) @(negedge CLK);

    $display("[STATE] Alarm_state = %b (Both ON)\n", Alarm_state);

    // ==================================================
    // 4) Back to Timekeeping
    // ==================================================
    $display("press_M : Alarm -> Stopwatch\n");
    press_M; // Alarm -> Stopwatch
    repeat(3) @(negedge CLK);

    $display("press_M : Stopwatch -> Time Set\n");
    press_M; // Stopwatch -> Time Set
    repeat(3) @(negedge CLK);


    // Time Set -> Timekeeping 
    $display("press_M (4 times) : Time Set -> Timekeeping\n");
    press_M; repeat(3) @(negedge CLK);
    press_M; repeat(3) @(negedge CLK);
    press_M; repeat(3) @(negedge CLK);
    press_M; repeat(3) @(negedge CLK);

    if (top_dut.fsm.current_state == 2'b00) $display("[MODE] Back to Timekeeping, waiting for alarm...\n");

    // ==================================================
    // 5) Wait for alarm to ring
    // ==================================================
    wait (Alarm_Signal == 1'b1);
    $display("[%0t] >>> ALARM STARTED <<<", $time);

    // ==================================================
    // 6) Let it ring 
    // ==================================================
    repeat(10) @(negedge CLK); 

    // ==================================================
    // 7) Stop alarm by press_S
    // ==================================================
    set = 1;
    @(negedge CLK);
    set = 0;
    @(negedge CLK);

    $display("Stop alarm by press_S...");
    
    if (Alarm_Signal == 1'b0)
        $display("[%0t] >>> ALARM STOPPED SUCCESSFULLY <<<", $time);
    else
        $display("[%0t] !!! ERROR: ALARM STILL RINGING !!!", $time);

end
endtask
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


endmodule