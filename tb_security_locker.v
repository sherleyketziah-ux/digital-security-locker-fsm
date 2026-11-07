`timescale 1ns/1ps

module tb_security_locker;

    reg clk;
    reg rst;
    reg submit;
    reg [3:0] user_password;

    wire unlock;
    wire buzzer;
    wire [1:0] attempt_count;

    // Instantiate the design under test
    digital_security_locker dut (
        .clk(clk),
        .rst(rst),
        .submit(submit),
        .user_password(user_password),
        .unlock(unlock),
        .buzzer(buzzer),
        .attempt_count(attempt_count)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Task to submit a password
    task enter_password;
        input [3:0] password;
        begin
            @(negedge clk);
            user_password = password;
            submit = 1'b1;

            @(negedge clk);
            submit = 1'b0;

            // Wait for the FSM to process the password
            repeat (4) @(negedge clk);
        end
    endtask

    initial begin
        // Initialize signals
        clk = 1'b0;
        rst = 1'b1;
        submit = 1'b0;
        user_password = 4'b0000;

        // Generate waveform dump
        $dumpfile("locker.vcd");
        $dumpvars(0, tb_security_locker);

        // Reset the design
        repeat (2) @(negedge clk);
        rst = 1'b0;

        // Test 1: Wrong password
        enter_password(4'b0011);

        // Test 2: Wrong password
        enter_password(4'b0101);

        // Test 3: Wrong password -> buzzer ON
        enter_password(4'b1100);

        // Test 4: Correct password after lockout
        // Locker must remain locked
        enter_password(4'b1010);

        // Display results
        $display("Attempts = %d", attempt_count);
        $display("Unlock   = %b", unlock);
        $display("Buzzer   = %b", buzzer);

        if (attempt_count == 3 && buzzer == 1 && unlock == 0)
            $display("PASS: Lockout and buzzer verified.");
        else
            $display("FAIL: Check the design.");

        #20;
        $finish;
    end

endmodule
