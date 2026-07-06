//==============================================================
//  Module: alarm_mode
//  Description:
//    Alarm setting and triggering logic for the digital watch.
//    User can set HH:MM alarm using two buttons only.
//
//    Mode_rising : moves between digits
//    Set_rising  : increments selected digit
//
//    Alarm supports:
//      - Daily alarm
//      - Hourly signal
//      - Both ON / Both OFF
//==============================================================

module alarm_mode (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        Mode_rising,       // Move to next digit/state
    input  wire        Set_rising,        // Increment selected digit
    input  wire [1:0]  en_alarm_mode,     // Alarm mode enable from main FSM

    input  wire [3:0]  in_ah_tens,        // Current hour tens
    input  wire [3:0]  in_ah_units,       // Current hour units
    input  wire [3:0]  in_am_tens,        // Current minute tens
    input  wire [3:0]  in_am_units,       // Current minute units
    input  wire [5:0]  in_ss,             // Current seconds
    
    output reg         alarm_signal,      // Alarm output
    output reg         hourly_signal,     // Hourly beep pulse
    output reg         alarm_finish,       // Alarm setting finished flag

    output reg  [3:0]  out_ah_tens,        // Alarm hour tens
    output reg  [3:0]  out_ah_units,       // Alarm hour units
    output reg  [3:0]  out_am_tens,        // Alarm minute tens
    output reg  [3:0]  out_am_units,       // Alarm minute units
    output reg  [1:0]  alarm_state        // Alarm mode state
);


    //==========================================================
    // FSM STATES
    //==========================================================
    localparam H1_SET          = 3'b000;
    localparam H0_SET          = 3'b001;
    localparam M1_SET          = 3'b010;
    localparam M0_SET          = 3'b011;
    localparam ALARM_STATE_SET = 3'b100;

    reg [2:0] current_state, next_state;

    //==========================================================
    // FSM State Register
    //==========================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= H1_SET;
        else if (en_alarm_mode == 2'b01)
            current_state <= next_state;
    end

    //==========================================================
    // FSM Next State Logic (Mode button)
    //==========================================================
    always @(*) begin
        next_state = current_state;
        
        if (en_alarm_mode == 2'b01 && Mode_rising) begin
            case (current_state)
                H1_SET          : next_state = H0_SET;
                H0_SET          : next_state = M1_SET;
                M1_SET          : next_state = M0_SET;
                M0_SET          : next_state = ALARM_STATE_SET;
                ALARM_STATE_SET : next_state = H1_SET;
                default         : next_state = H1_SET;
            endcase
        end
    end

    //==========================================================
    // Alarm Digits Editing (Set button)
    //==========================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alarm_state  <= 2'b00;
            out_ah_tens  <= 4'd0;
            out_ah_units <= 4'd0;
            out_am_tens  <= 4'd0;
            out_am_units <= 4'd0;
        end

        else if (en_alarm_mode == 2'b01 && Set_rising) begin
            case (current_state)
                // H1
                H1_SET: begin
                    out_ah_tens <= (out_ah_tens == 2) ? 0 : out_ah_tens + 1;
                end

                // H0
                H0_SET: begin
                    if (out_ah_tens == 2)
                        out_ah_units <= (out_ah_units == 3) ? 0 : out_ah_units + 1;
                    else
                        out_ah_units <= (out_ah_units == 9) ? 0 : out_ah_units + 1;
                end

                // M1
                M1_SET: begin
                    out_am_tens <= (out_am_tens == 5) ? 0 : out_am_tens + 1;
                end

                // M0
                M0_SET: begin
                    out_am_units <= (out_am_units == 9) ? 0 : out_am_units + 1;
                end

                // Alarm State
                ALARM_STATE_SET: begin
                    alarm_state <= alarm_state + 1;
                end
        endcase
    end
end



    //==========================================================
    // Alarm Finish
    //==========================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            alarm_finish <= 1'b0;
        else begin
            if (en_alarm_mode != 2'b01)
                alarm_finish <= 1'b0;
            else if (current_state == ALARM_STATE_SET)
                alarm_finish <= 1'b1;
            else
                alarm_finish <= 1'b0;
        end
    end




    //==============================================================
    // DAILY ALARM & HOURLY SIGNAL
    //
    // Mode button cycles alarm state after finishing digit editing:
    //
    //   (00 → 01 → 10 → 11 → 00)
    //
    // 00 = Both ON
    // 01 = Both OFF
    // 10 = Daily Alarm only
    // 11 = Hourly Signal only
    //==============================================================


    // Enable flags based on alarm_state
    wire       daily_alarm_on;
    wire       hourly_signal_on;

    // Registers used for hourly signal logic
    reg [4:0]  daily_count ;
    reg [2:0]  hourly_count ;

    // Used to prevent alarm retriggering in same minute
    reg        alarm_latched;


    //==============================================================
    //                 DAILY ALARM & HOURLY SIGNAL                
    //==============================================================

    assign daily_alarm_on  = (alarm_state == 2'b00) || (alarm_state == 2'b10);
    assign hourly_signal_on = (alarm_state == 2'b00) || (alarm_state == 2'b11);

    // HOURLY BEEP
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hourly_signal <= 1'b0;
            hourly_count  <= 3'd0;
        end 
        
        else begin
            // Trigger hourly beep ONCE at mm = 00
           if ( hourly_signal_on       &&
                en_alarm_mode != 2'b01 &&
                (in_am_tens == 'd5)    &&
                (in_am_units == 'd9)   &&
                in_ss == 'd59) begin

                    hourly_signal <= 1'b1;
                    hourly_count  <= 3'd1;   // start counting seconds
            end

            // Keep hourly_signal HIGH for 5 seconds
            else if (hourly_signal) begin
                if (hourly_count == 3'd5) begin
                    hourly_signal <= 1'b0;   // auto stop after 5 sec
                end 
                else begin
                    hourly_count <= hourly_count + 1'b1;
                end
            end
        end
    end
    

///////////////////////////////////////////////////////////////////////////

    // ALARM SIGNAL COMPARISON
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alarm_signal  <= 1'b0;
            alarm_latched <= 1'b0;
        end else begin
            // Clear latch when minute changes
            if (!(in_am_tens == out_am_tens &&
                in_am_units == out_am_units)) begin
                alarm_latched <= 1'b0;
            end
            // Trigger alarm ONCE
            if (daily_alarm_on &&
                en_alarm_mode != 2'b01 &&
                !alarm_latched &&
                (in_ah_tens  == out_ah_tens) &&
                (in_ah_units == out_ah_units) &&
                (in_am_tens  == out_am_tens) &&
                (in_am_units == out_am_units) &&
                in_ss < 6'd20) begin
                alarm_signal  <= 1'b1;
                alarm_latched <= 1'b1;
            end
            // Stop alarm
            else if (alarm_signal &&
                    (Set_rising || in_ss >= 6'd20)) begin
                alarm_signal <= 1'b0;
            end
        end
    end
endmodule
