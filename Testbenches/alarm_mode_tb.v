`timescale 1ns/1ps
module alarm_mode_tb;

    // =======================
    // TB Signals
    // =======================
    reg clk_tb;
    reg rst_n_tb;
    reg Mode_rising_tb;
    reg Set_rising_tb;
    reg [1:0] en_alarm_mode_tb;

    reg [3:0] in_ah_tens_tb;
    reg [3:0] in_ah_units_tb;
    reg [3:0] in_am_tens_tb;
    reg [3:0] in_am_units_tb;
    reg [5:0] in_ss_tb;

    wire alarm_signal_tb;
    wire hourly_signal_tb;
    wire alarm_finish_tb;

    wire [3:0] out_ah_tens_tb;
    wire [3:0] out_ah_units_tb;
    wire [3:0] out_am_tens_tb;
    wire [3:0] out_am_units_tb;
    wire [1:0] alarm_state_tb;


    always @(posedge clk_tb , negedge rst_n_tb ) begin 
        if (in_ss_tb < 6'd59)
        in_ss_tb <= in_ss_tb + 6'd1;

        else begin
            in_ss_tb <= 6'd0;

            // ===== Minutes =====
            if (in_am_units_tb < 4'd9)
                in_am_units_tb <= in_am_units_tb + 4'd1;

            else if (in_am_tens_tb < 4'd5 && in_am_units_tb == 4'd9) begin
                in_am_tens_tb <= in_am_tens_tb + 4'd1;
                in_am_units_tb <= 4'd0;
            end

            else if (in_am_tens_tb == 4'd5 && in_am_units_tb == 4'd9) begin
                in_am_tens_tb <= 4'd0;
                in_am_units_tb <= 4'd0;

                // ===== Hours (24h format) =====
                if (in_ah_tens_tb == 4'd2 && in_ah_units_tb == 4'd3) begin
                    // 23 -> 00
                    in_ah_tens_tb <= 4'd0;
                    in_ah_units_tb <= 4'd0;
                end

                else if (in_ah_units_tb == 4'd9) begin
                    in_ah_tens_tb <= in_ah_tens_tb + 4'd1;
                    in_ah_units_tb <= 4'd0;
                end

                else begin
                    in_ah_units_tb <= in_ah_units_tb + 4'd1;
                end
            end
        end
    end   


    // =======================
    // DUT
    // =======================
    alarm_mode DUT (
        .clk(clk_tb),
        .rst_n(rst_n_tb),
        
        .Mode_rising(Mode_rising_tb),
        .Set_rising(Set_rising_tb),
        .en_alarm_mode(en_alarm_mode_tb),

        .in_ah_tens(in_ah_tens_tb),
        .in_ah_units(in_ah_units_tb),
        .in_am_tens(in_am_tens_tb),
        .in_am_units(in_am_units_tb),
        .in_ss(in_ss_tb),

        .alarm_signal(alarm_signal_tb),
        .hourly_signal(hourly_signal_tb),
        .alarm_finish(alarm_finish_tb),

        .out_ah_tens(out_ah_tens_tb),
        .out_ah_units(out_ah_units_tb),
        .out_am_tens(out_am_tens_tb),
        .out_am_units(out_am_units_tb),

        .alarm_state(alarm_state_tb)
    );

    // =======================
    // Clock (10 ns)
    // =======================
    always #0.5 clk_tb = ~clk_tb;

    // =======================
    // Button Press Tasks
    // =======================
    task press_Mode;
    begin
        Mode_rising_tb = 1; @(negedge clk_tb);
        Mode_rising_tb = 0; @(negedge clk_tb);
    end
    endtask

    task press_Set;
    begin
        Set_rising_tb = 1; @(negedge clk_tb);
        Set_rising_tb = 0; @(negedge clk_tb);
    end
    endtask

    // =======================
    // Test Sequence
    // =======================
    initial begin
        $display("========== ALARM MODE TEST START ==========");

        // ---------- Init ----------
        clk_tb = 0;
        rst_n_tb = 0;
        Mode_rising_tb = 0;
        Set_rising_tb = 0;
        en_alarm_mode_tb = 2'b00;

        in_ah_tens_tb  = 0;
        in_ah_units_tb = 0;
        in_am_tens_tb  = 0;
        in_am_units_tb = 0;
        in_ss_tb       = 0;

        @(negedge clk_tb);
        rst_n_tb = 1;

        // ==================================================
        // ENTER EDIT MODE
        // ==================================================
        $display("\n[EDIT MODE] Enter alarm edit");
        en_alarm_mode_tb = 2'b01;
        $display("[%0t] | Alarm = %0d%0d:%0d%0d",
            $time,
            out_ah_tens_tb, out_ah_units_tb,
            out_am_tens_tb, out_am_units_tb
        );

        // ==================================================
        // HH TENS
        // ==================================================
        $display("\n[EDIT] HH TENS");
        press_Set; @(negedge clk_tb);
        $display("[%0t] HH TENS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        press_Set; @(negedge clk_tb);
        $display("[%0t] HH TENS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        press_Set; @(negedge clk_tb);
        $display("[%0t] HH TENS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        // ==================================================
        // HH UNITS
        // ==================================================
        $display("\n[EDIT] HH UNITS");
        press_Mode;

        press_Set; @(negedge clk_tb);
        $display("[%0t] HH UNITS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        press_Set; @(negedge clk_tb);
        $display("[%0t] HH UNITS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        press_Set; @(negedge clk_tb);
        $display("[%0t] HH UNITS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        // ==================================================
        // MM TENS
        // ==================================================
        $display("\n[EDIT] MM TENS");
        press_Mode;

        press_Set; @(negedge clk_tb);
        $display("[%0t] MM TENS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        press_Set; @(negedge clk_tb);
        $display("[%0t] MM TENS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        press_Set; @(negedge clk_tb);
        $display("[%0t] MM TENS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        // ==================================================
        // MM UNITS
        // ==================================================
        $display("\n[EDIT] MM UNITS");
        press_Mode;

        press_Set; @(negedge clk_tb);
        $display("[%0t] MM UNITS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        press_Set; @(negedge clk_tb);
        $display("[%0t] MM UNITS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        press_Set; @(negedge clk_tb);
        $display("[%0t] MM UNITS -> %0d%0d:%0d%0d",$time,
            out_ah_tens_tb,out_ah_units_tb,out_am_tens_tb,out_am_units_tb);

        // ==================================================
        // EXIT EDIT
        // ==================================================
        press_Mode;
        @(negedge clk_tb);
        $display("\n[EDIT DONE] Alarm = %0d%0d:%0d%0d",
            out_ah_tens_tb,out_ah_units_tb,
            out_am_tens_tb,out_am_units_tb);

        // ==================================================
        // STATE TOGGLE
        // ==================================================
        $display("\n[STATE TOGGLE]");
        press_Set; $display("state=%b (Both OFF)",alarm_state_tb);
        press_Set; $display("state=%b (Daily ON)",alarm_state_tb);
        press_Set; $display("state=%b (Hourly ON)",alarm_state_tb);
        press_Set; $display("state=%b (Both ON)",alarm_state_tb);

        @(posedge clk_tb);
        @(posedge clk_tb);
        @(posedge clk_tb);
        // ==================================================
        // DAILY ALARM Display
        // ==================================================
        @(negedge clk_tb);
        $display("Daily Alarm at %0d%0d:%0d%0d -- %b",out_ah_tens_tb,
                    out_ah_units_tb,out_am_tens_tb,out_am_units_tb,alarm_signal_tb);

        @(negedge clk_tb);
        press_Mode;  // To exit from alarm 
        en_alarm_mode_tb = 2'b00;
        repeat (10) @(negedge clk_tb);
        // ==================================================
        // HOURLY ALARM (5 seconds)
        // ==================================================
        @(negedge clk_tb);
        $display("\n[HOURLY ALARM - 5 SECOND RING]");

        // Set time to xx:00:00
        in_am_tens_tb  = 'd5;
        in_am_units_tb = 'd9;
        in_ss_tb       = 'd59;

        // Observe hourly alarm for 5 seconds
        repeat (6) begin
            @(negedge clk_tb);
            $display("Time %0d%0d:%0d%0d:%0d | hourly_signal = %b",
                in_ah_tens_tb,
                in_ah_units_tb,
                in_am_tens_tb,
                in_am_units_tb,
                in_ss_tb,
                hourly_signal_tb
            );
        end

        // Check that hourly alarm stopped after 5 seconds
        if (hourly_signal_tb !== 1'b0)
            $display("ERROR: Hourly alarm did not stop after 5 seconds!");
        else
            $display("PASS: Hourly alarm stopped after 5 seconds");



        // ==================================================
        // DAILY ALARM – FULL 20 SECOND RING (NO STOP)
        // ==================================================
        $display("\n[DAILY ALARM] 20-SECOND RING TEST (NO MODE PRESS)");

        @(negedge clk_tb);

        // Match alarm time
        in_ah_tens_tb  = out_ah_tens_tb;
        in_ah_units_tb = out_ah_units_tb;
        in_am_tens_tb  = out_am_tens_tb;
        in_am_units_tb = out_am_units_tb;
        in_ss_tb       = 0;


        // Simulate seconds counting from 0 to 22
        repeat (21) begin
            @(negedge clk_tb);
            $display("Time %0d%0d:%0d%0d | alarm_signal = %b",
                in_ah_tens_tb,
                in_ah_units_tb,
                in_am_tens_tb,
                in_am_units_tb,
                alarm_signal_tb
            );
        end

        // Check final state
        if (alarm_signal_tb !== 1'b0)
            $display("ERROR: Alarm did not stop after 20 seconds!");
        else
            $display("PASS: Alarm stopped after 20 seconds");


        #50 ;

        // ==================================================
        // DAILY ALARM – FULL 20 SECOND RING (STOP With Set push button)
        // ==================================================
        $display("\n[DAILY ALARM] 20-SECOND RING TEST (Stop it by pressing Set)");

        @(negedge clk_tb);

        // Match alarm time
        in_ah_tens_tb  = out_ah_tens_tb;
        in_ah_units_tb = out_ah_units_tb;
        in_am_tens_tb  = out_am_tens_tb;
        in_am_units_tb = out_am_units_tb;
        in_ss_tb       = 0;


        // Simulate seconds counting from 0 to 22
        repeat (11) begin
            @(negedge clk_tb);
            $display("Time %0d%0d:%0d%0d | alarm_signal = %b",
                in_ah_tens_tb,
                in_ah_units_tb,
                in_am_tens_tb,
                in_am_units_tb,
                alarm_signal_tb
            );
        end

        press_Set;

        // Check final state
        if (alarm_signal_tb !== 1'b0)
            $display("ERROR: Alarm didn't stop after pressing Set");
        else
            $display("PASS: Alarm stopped after pressing Set");

        repeat (10) begin
            @(negedge clk_tb);
            $display("Time %0d%0d:%0d%0d | alarm_signal = %b",
                in_ah_tens_tb,
                in_ah_units_tb,
                in_am_tens_tb,
                in_am_units_tb,
                alarm_signal_tb
            );
        end

    

        #50;
        $display("\n========== TEST END ==========");
        $stop;
    end

endmodule

