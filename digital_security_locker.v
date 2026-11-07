module digital_security_locker #(
    parameter [3:0] PASSWORD = 4'b1010
)(
    input wire clk,
    input wire rst,
    input wire submit,
    input wire [3:0] user_password,

    output reg unlock,
    output reg buzzer,
    output reg [1:0] attempt_count
);

    // FSM state declarations
    localparam IDLE     = 2'b00;
    localparam CHECK    = 2'b01;
    localparam UNLOCKED = 2'b10;
    localparam LOCKOUT  = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] entered_password;

    // Sequential logic: state, password and attempt counter
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state            <= IDLE;
            entered_password <= 4'b0000;
            attempt_count    <= 2'b00;
            unlock           <= 1'b0;
            buzzer           <= 1'b0;
        end
        else begin
            case (state)

                IDLE: begin
                    unlock <= 1'b0;
                    if (submit) begin
                        entered_password <= user_password;
                        state <= CHECK;
                    end
                end

                CHECK: begin
                    if (entered_password == PASSWORD) begin
                        state  <= UNLOCKED;
                        unlock <= 1'b1;
                    end
                    else begin
                        if (attempt_count == 2'd2) begin
                            attempt_count <= 2'd3;
                            state  <= LOCKOUT;
                            buzzer <= 1'b1;
                            unlock <= 1'b0;
                        end
                        else begin
                            attempt_count <= attempt_count + 1'b1;
                            state  <= IDLE;
                            unlock <= 1'b0;
                        end
                    end
                end

                UNLOCKED: begin
                    unlock <= 1'b1;
                    buzzer <= 1'b0;
                    state  <= UNLOCKED;
                end

                LOCKOUT: begin
                    unlock <= 1'b0;
                    buzzer <= 1'b1;
                    state  <= LOCKOUT;
                end

                default: begin
                    state  <= IDLE;
                    unlock <= 1'b0;
                    buzzer <= 1'b0;
                end

            endcase
        end
    end

endmodule
