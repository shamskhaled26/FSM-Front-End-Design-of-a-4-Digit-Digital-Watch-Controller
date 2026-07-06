`timescale 1ms/1us
module QW_display_tb();

reg mode;

reg CLK,RST,set;
reg [1:0] enable;

wire [3:0] mm_0;
wire [3:0] mm_1;
wire [3:0] hh_0;
wire [3:0] hh_1;
wire [5:0] ss;
wire end_of_set;



time_display_set time_display_set(
    .mode(mode),
    .set(set),
    .CLK(CLK),
    .RST(RST),
    .enable(enable),
    .mm_0(mm_0),//0>>9
    .mm_1(mm_1),//0>>5
    .hh_0(hh_0),//0>>9
    .hh_1(hh_1),//0>>2
    .ss(ss),
    .end_of_set(end_of_set)
);

always #1 CLK = ~CLK;

initial begin 
    initialize();
    reset();
repeat(25)@(negedge CLK);
    ////////////////////////////////////////////////////////////
    // ---------- DISPLAY MODE ----------
    ////////////////////////////////////////////////////////////
    $display("\n========== DISPLAY MODE TEST START ==========");
    check_time_display(); // task to check time in display mode
    repeat(50) @(negedge CLK);


press_M();// check display mode   >>alarm 

repeat(100)@(negedge CLK);
press_M();// check display mode  alarm >>stopwatch


repeat(100)@(negedge CLK);

enable=2'b11;
press_M();@(posedge CLK);// check display mode stopwatch>>timeset

// mode=1;@(posedge CLK);mode=0;
////////////////////////////////////////////////////////////
    // ---------- TIME SET MODE ----------
    ////////////////////////////////////////////////////////////
    press_M(); // move from Stopwatch >> Time Set
    $display("\n========== TIME SET MODE TEST START ==========");
check_time_set();// task to check time set mode

///////////////////////////////////////////////////////////

press_M();//exittime set  mode
repeat(100)@(posedge CLK);

$stop;



end

initial begin
    $monitor("time=%0d ,hour =%0d%0d , min = %0d%0d   ",$time,hh_1,hh_0,mm_1,mm_0);
end

task initialize;
    begin
        CLK=0;
        mode=0;
        set=0;
        enable=2'b00;
    end
endtask

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

task check_time_set;
    begin       
        $display("\n[Time Set Mode] Starting time set operation");

$display("\n[Time Set] Editing HH tens (hh_1)");
        press_M();
        repeat(5)@(negedge CLK); // wait before increment
        press_S();
        repeat(5)@(negedge CLK);
        $display("[%0t] HH tens incremented -> hh_1 = %0d", $time, time_display_set.hh_1);

    

    // ---------- HH Units ----------
        $display("\n[Time Set] Editing HH units (hh_0)");
        press_M();
        repeat(5)@(negedge CLK);//h0=h0+7
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    $display("[%0t] hh_0 increment = %0d", $time, time_display_set.hh_0);

    $display("\n[Time Set] Editing MM tens (mm_1)");
        press_M();
        @(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(5)@(negedge CLK);
$display("[%0t] mm_1 increment = %0d", $time, time_display_set.mm_1);

$display("\n[Time Set] Editing MM units (mm_0)");
    press_M();
    @(negedge CLK);//m0=m0+5
    press_S();
    repeat(5)@(negedge CLK);
    press_S();
    repeat(10)@(negedge CLK);
    press_S();
    repeat(10)@(negedge CLK);
    press_S();
    repeat(10)@(negedge CLK);
    press_S();
    repeat(10)@(negedge CLK);
$display("[%0t] mm_0 increment = %0d", $time, time_display_set.mm_0);
    
     // ---------- FINAL TIME ----------
        $display("\n[Time Set] Final set time: %0d%0d:%0d%0d",
            time_display_set.hh_1,
            time_display_set.hh_0,
            time_display_set.mm_1,
            time_display_set.mm_0
        );
    
    
    end
endtask
endmodule
