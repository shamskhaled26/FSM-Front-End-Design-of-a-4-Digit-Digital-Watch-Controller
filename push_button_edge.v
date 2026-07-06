module push_button_edge (
    input  wire CLK,
    input  wire RST,     // active low reset 
    input  wire Set,
    input  wire Mode,
    output reg  S_r,
    output reg  M_r
);

// Internal Signals 
reg S_old, M_old;       // registers to store previous value


// Sequntial Logic 
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        S_old  <= 1'b0;
        M_old  <= 1'b0;

        M_r <= 1'b0;
        S_r <= 1'b0;
    end 

    else begin
        // rising edge if -> current = 1 and old = 0
        M_r <=  Mode  & ~M_old;
        S_r <=  Set & ~S_old;
        
        M_old <= Mode;
        S_old <= Set;
    end
end

endmodule
