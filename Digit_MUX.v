module Digit_MUX #(
parameter Width = 8
)(
input   wire   [1:0]         Enable,

input   wire   [Width-1:0]   Time_Keeping,
input   wire   [Width-1:0]   Time_Set,
input   wire   [Width-1:0]   Alarm_Time,
input   wire   [Width-1:0]   Stop_Watch_Time,

output  reg    [Width-1:0]   MUX_Out
);


always @(*) begin
	case(Enable) 
		2'b00 : MUX_Out = Time_Keeping ;
		2'b01 : MUX_Out = Alarm_Time ;	
		2'b10 : MUX_Out = Stop_Watch_Time ;
		2'b11 : MUX_Out = Time_Set ;			
	endcase
end	

endmodule