module time_display_set(
    input mode, set,              // mode: move between digits, set: increment digit
    input CLK, RST,
    input [1:0] enable,            // enable from main FSM

    output reg [3:0] mm_0,          // minute units   (0 → 9)
    output reg [3:0] mm_1,          // minute tens    (0 → 5)
    output reg [3:0] hh_0,          // hour units     (0 → 9)
    output reg [3:0] hh_1,          // hour tens      (0 → 2)
    output reg [5:0] ss,            // seconds        (0 → 59)
    output reg end_of_set           // goes high after last digit
);

    //==========================================================
    // FSM STATES (Digit Selection Order)
    //==========================================================
    localparam HH1_SET = 2'd0;      // Hour tens
    localparam HH0_SET = 2'd1;      // Hour units
    localparam MM1_SET = 2'd2;      // Minute tens
    localparam MM0_SET = 2'd3;      // Minute units

    reg [1:0] current_state, next_state;

    //==========================================================
    // FSM State Register
    //==========================================================
    always @(posedge CLK or negedge RST) begin
        if (!RST)
            current_state <= HH1_SET;
        else if (enable == 2'b11)
            current_state <= next_state;
    end

    //==========================================================
    // FSM Next State Logic (mode)
    //==========================================================
    always @(*) begin
        next_state = current_state;

        if (mode && enable == 2'b11) begin
            case (current_state)
                HH1_SET: next_state = HH0_SET;
                HH0_SET: next_state = MM1_SET;
                MM1_SET: next_state = MM0_SET;
                MM0_SET: next_state = HH1_SET;
                default: next_state = HH1_SET;
            endcase
        end
    end

    //==========================================================
    // End Of Set (last state MM0_SET)
    //==========================================================
    always @(posedge CLK or negedge RST) begin
        if (!RST)
            end_of_set <= 1'b0;
        else if (enable == 2'b11 && current_state == MM0_SET)
            end_of_set <= 1'b1;
        else
            end_of_set <= 1'b0;
    end

    //==========================================================
    // Time Counting + Time Set Logic
    //==========================================================
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            hh_0 <= 0;
            hh_1 <= 0;
            mm_1 <= 0;
            mm_0 <= 0;
            ss   <= 0;
        end
        else 
        
        begin
            //================ NORMAL TIME COUNT =================
            if (ss < 6'd59)
            ss <= ss + 6'd1;

            else begin
                ss <= 6'd0;

                // ===== Minutes =====
                if (mm_0 < 4'd9)
                    mm_0 <= mm_0 + 4'd1;

                else if (mm_1 < 4'd5 && mm_0 == 4'd9) begin
                    mm_1 <= mm_1 + 4'd1;
                    mm_0 <= 4'd0;
                end

                else if (mm_1 == 4'd5 && mm_0 == 4'd9) begin
                    mm_1 <= 4'd0;
                    mm_0 <= 4'd0;

                    // ===== Hours (24h format) =====
                    if (hh_1 == 4'd2 && hh_0 == 4'd3) begin
                        // 23 -> 00
                        hh_1 <= 4'd0;
                        hh_0 <= 4'd0;
                    end

                    else if (hh_0 == 4'd9) begin
                        hh_1 <= hh_1 + 4'd1;
                        hh_0 <= 4'd0;
                    end

                    else begin
                        hh_0 <= hh_0 + 4'd1;
                    end
                end
            end
        end

        //================ TIME SET MODE =================
        if (set && enable==2'b11) begin
            case (current_state)

                HH1_SET:
                    hh_1 <= (hh_1 < 2) ? hh_1 + 1 : 0;

                HH0_SET:
                    hh_0 <= (hh_0 < 9) ? hh_0 + 1 : 0;

                MM1_SET:
                    mm_1 <= (mm_1 < 5) ? mm_1 + 1 : 0;

                MM0_SET:
                    mm_0 <= (mm_0 < 9) ? mm_0 + 1 : 0;

            endcase
        end
    end

endmodule
