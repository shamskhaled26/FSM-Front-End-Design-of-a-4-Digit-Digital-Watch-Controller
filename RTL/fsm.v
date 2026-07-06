module fsm(
    input CLK,RST,    
    input set,
    input  mode,
    input Stop_watch_end,
    input end_of_set,
    input alarm_finish,
    output reg [1:0] enable
);
reg [1:0] current_state,next_state;

localparam [1:0] time_display = 2'b00,
            set_alarm = 2'b01,
            stopwatch = 2'b10,
            set_time =  2'b11;

always @(posedge CLK  or negedge RST) begin
    if(!RST)
        current_state  <= time_display;
    else
        current_state <= next_state;

end

//output logic
//mux
always @(*) begin
    case(current_state)
        time_display: begin
            enable = 2'b00;
                        
        end
        set_alarm: begin
            enable = 2'b01;
        end
        
        stopwatch: begin
            enable = 2'b10;
        end
        set_time: begin
            enable = 2'b11;           
            end
        
            
        
    endcase
end

always @(*) begin
    case(current_state)
        time_display: begin
            if (enable==2'b00 && mode == 'b1) begin
            next_state = set_alarm;//move to next mode >>  alarm setup
            end
            else next_state = time_display;
        end
         set_alarm: begin
            if (enable==2'b01 && alarm_finish && mode == 'b1) begin
            next_state = stopwatch;//move to next mode >>  alarm setup
            end
            else next_state = set_alarm;
        end
            
        stopwatch: begin
            if (enable==2'b10 && Stop_watch_end && mode == 'b1) begin
            next_state = set_time;//move to next mode >>  alarm setup
            end  
            else next_state = stopwatch;
        end                                       
        set_time: begin
            if (enable==2'b11 && end_of_set == 'b1 && mode == 'b1) begin
            next_state = time_display;//move to next mode >>  alarm setup
            end
            else next_state = set_time;
        end
        
    endcase
end

endmodule
