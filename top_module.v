module top_module(
    input             set,
    input             mode,
    input             CLK,RST,

    output     [3:0]  Digit_3,  // in (Timekeeping,Time_set,Alarm) --> hh_1 , in Stop_Watch --> mm1
    output     [3:0]  Digit_2,  // in (Timekeeping,Time_set,Alarm) --> hh_0 , in Stop_Watch --> mm0
    output     [3:0]  Digit_1,  // in (Timekeeping,Time_set,Alarm) --> hh_1 , in Stop_Watch --> ss1
    output     [3:0]  Digit_0,  // in (Timekeeping,Time_set,Alarm) --> hh_0 , in Stop_Watch --> ss0

    output     [1:0]  Alarm_state ,   // 00 Both ON, 01 Both OFF, 10 Daily ON, 11 Hourly ON
    output            Alarm_Signal,
    output            hourly_signal
    
);
///////////////////////////////////////////
//           Internal Signals            //
///////////////////////////////////////////

// push_button_edge signals
wire S_r , M_r ;
//////////////////////////////////////////////

// Stop_Watch signals 
wire [3:0] Digit3_SW;  //mm_1 0>>5
wire [3:0] Digit2_SW;  //mm_0 0>>9
wire [3:0] Digit1_SW;  //ss_1 0>>5
wire [3:0] Digit0_SW;  //ss_0 0>>9

//////////////////////////////////////////////

// Time_Keeping_Set signals 
wire [3:0] Digit3_Time;     //hh_1 0>>2
wire [3:0] Digit2_Time;     //hh_0 0>>9
wire [3:0] Digit1_Time;     //mm_1 0>>5
wire [3:0] Digit0_Time;     //mm_0 0>>9
wire [1:0] enable;
wire       Stop_watch_end;  // End signal
wire [5:0] ss;              //0>>59

//////////////////////////////////////////////

// Alarm signals 
wire [3:0] Digit3_Alarm;  //hh_1 0>>2
wire [3:0] Digit2_Alarm;  //hh_0 0>>9
wire [3:0] Digit1_Alarm;  //mm_1 0>>5
wire [3:0] Digit0_Alarm;  //mm_0 0>>9

wire       alarm_finish;



//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////




//////////////// push_button_edge instant////////////////
push_button_edge button_edge (
    .CLK(CLK),
    .RST(RST),
    .Set(set),
    .Mode(mode),
    .S_r(S_r),
    .M_r(M_r)
);


/////////////////// time_display_set///////////////////
time_display_set time_display_set(
    .mode(M_r),
    .set(S_r),
    .CLK(CLK),
    .RST(RST),
    .enable(enable),

    .hh_1(Digit3_Time),//0>>2
    .hh_0(Digit2_Time),//0>>9
    .mm_1(Digit1_Time),//0>>5
    .mm_0(Digit0_Time),//0>>9
    .ss(ss),           //0>>59
    
    .end_of_set(end_of_set)
);


///////////////////// Alarm instant/////////////////////
alarm_mode alarm_mode (
    .clk(CLK),
    .rst_n(RST),
    .Mode_rising(M_r),                // Next digit
    .Set_rising(S_r),                 // Increment digit

    .en_alarm_mode(enable),     // Alarm mode enable

    .in_ah_tens(Digit3_Time),        // current hour tens
    .in_ah_units(Digit2_Time),       // current hour units
    .in_am_tens(Digit1_Time),        // current minute tens
    .in_am_units(Digit0_Time),       // current minute units
    .in_ss(ss),                      // current sec 0>>59

    .out_ah_tens(Digit3_Alarm),
    .out_ah_units(Digit2_Alarm),
    .out_am_tens(Digit1_Alarm),
    .out_am_units(Digit0_Alarm),

    .alarm_signal(Alarm_Signal),
    .hourly_signal(hourly_signal),   // 1-sec pulse every hour if enabled
    .alarm_state(Alarm_state),       // 00 Both ON, 01 Both OFF, 10 Daily ON, 11 Hourly ON
    .alarm_finish(alarm_finish)        // 00 Both ON, 01 Both OFF, 10 Daily ON, 11 Hourly ON
);



///////////////////// Stop_Watch instant///////////////////// 
Stop_Watch Stop_Watch(
    .M_r(M_r),
    .S_r(S_r),
    .CLK(CLK),
    .RST(RST),
    .Enable(enable),

    .m_1(Digit3_SW),
    .m_0(Digit2_SW),
    .s_1(Digit1_SW),
    .s_0(Digit0_SW),

    .Stop_watch_end(Stop_watch_end)
);


///////////////////// Digit3_MUX instant/////////////////////                    
Digit_MUX #(.Width(4)) Digit3_MUX (
.Enable(enable), 
.Time_Keeping(Digit3_Time),             
.Time_Set(Digit3_Time),                 
.Alarm_Time(Digit3_Alarm),               
.Stop_Watch_Time(Digit3_SW),           
.MUX_Out(Digit_3)             
);

///////////////////// Digit2_MUX instant/////////////////////                     
Digit_MUX #(.Width(4)) Digit2_MUX (
.Enable(enable), 
.Time_Keeping(Digit2_Time),             
.Time_Set(Digit2_Time),                 
.Alarm_Time(Digit2_Alarm),               
.Stop_Watch_Time(Digit2_SW),           
.MUX_Out(Digit_2)             
);

///////////////////// Digit1_MUX instant/////////////////////                     
Digit_MUX #(.Width(4)) Digit1_MUX (
.Enable(enable), 
.Time_Keeping(Digit1_Time),             
.Time_Set(Digit1_Time),                 
.Alarm_Time(Digit1_Alarm),               
.Stop_Watch_Time(Digit1_SW),           
.MUX_Out(Digit_1)             
);


///////////////////// Digit0_MUX instant/////////////////////               
Digit_MUX #(.Width(4)) Digit0_MUX (
.Enable(enable), 
.Time_Keeping(Digit0_Time),             
.Time_Set(Digit0_Time),                 
.Alarm_Time(Digit0_Alarm),               
.Stop_Watch_Time(Digit0_SW),           
.MUX_Out(Digit_0)             
);


///////////////////// FSM_Controler/////////////////////
fsm fsm(
    .mode(M_r),
    .set(S_r),
    .CLK(CLK),
    .RST(RST),
    .enable(enable),
    .end_of_set(end_of_set),
    .alarm_finish(alarm_finish),
    .Stop_watch_end(Stop_watch_end)
);

endmodule