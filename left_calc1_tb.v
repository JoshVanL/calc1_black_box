`uselib lib=calc1_black_box

module left_calc1_tb;

wire [0:31]   out_data1, out_data2, out_data3, out_data4;
wire [0:1]    out_resp1, out_resp2, out_resp3, out_resp4;

reg 	      c_clk;
reg [0:3]     req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
reg [0:31]    req1_data_in, req2_data_in, req3_data_in, req4_data_in;
reg [1:7]     reset;

calc1 DUV(out_data1, out_data2, out_data3, out_data4, out_resp1, out_resp2, out_resp3, out_resp4, c_clk, req1_cmd_in, req1_data_in, req2_cmd_in, req2_data_in, req3_cmd_in, req3_data_in, req4_cmd_in, req4_data_in, reset);

initial
begin
    c_clk = 0;
    req1_cmd_in = 0;
    req1_data_in = 0;
    req2_cmd_in = 0;
    req2_data_in = 0;
    req3_cmd_in = 0;
    req3_data_in = 0;
    req4_data_in = 0;
end

always #100 c_clk = ~c_clk;

initial
begin


    $display("\nTesting shift left operator.. \n");

    // First drive reset. Driving bit 1 is enough to reset the design.
    // TEST 1
    resetAll;
    req1_cmd_in = 5;
    req1_data_in = 32'b0001_1111_1111_1111_1111_1111_1111_1111;
    #200
    req1_cmd_in = 0;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
    waitForResp1;
    test(out_data1, 32'b1111_1111_1111_1111_1111_1111_1111_1000, 1);

    // TEST2 // 0 -0
    resetAll;
    req1_cmd_in = 2;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    #200
    req1_cmd_in = 0;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    waitForResp1;
    test(out_data1, 32'b0000_0000_0000_0000_0000_0000_0000_0000, 2);

    // TEST3 n - 0
    resetAll;
    req1_cmd_in = 2;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_1000;
    #200
    req1_cmd_in = 0;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    waitForResp1;
    test(out_data1, 32'b0000_0000_0000_0000_0000_0000_0000_1000, 3);

    // TEST4 //Sub by zero works for reg1
    resetAll;
    req1_cmd_in = 2;
    req1_data_in = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
    #200
    req1_cmd_in = 0;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    waitForResp1;
    test(out_data1, 32'b0000_0000_0000_0000_1000_0000_0000_0000, 4);

    // TEST5
    resetAll;
    req2_cmd_in = 2;
    req2_data_in = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
    #200
    req2_cmd_in = 0;
    req2_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Sub by zero always returns 0 for reg2
    waitForResp2;
    test(out_data2, 32'b0000_0000_0000_0000_1000_0000_0000_0000, 5);

    // TEST6 //Sub by zero works for reg3
    resetAll;
    req3_cmd_in = 2;
    req3_data_in = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
    #200
    req3_cmd_in = 0;
    req3_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    waitForResp3;
    test(out_data3, 32'b0000_0000_0000_0000_1000_0000_0000_0000, 6);

    // TEST7 //reg 4 times out
    resetAll;
    req4_cmd_in = 2;
    req4_data_in = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
    #200
    req4_cmd_in = 0;
    req4_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    waitForResp4;
    test(out_data4, 32'b0000_0000_0000_0000_1000_0000_0000_0000, 7);

    // TEST8 // Underflow
    resetAll;
    req1_cmd_in = 2;
    req1_data_in = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
    #200
    req1_cmd_in = 0;
    req1_data_in = 32'b0000_0000_0001_0000_0000_0000_0000_0000; //Underflow
    waitForResp1;
    test(out_resp1, 2, 8);
    test(out_data1, 32'b1111_1111_1111_1111_1111_1111_1111_1111, 9);

    // TEST9 // Underflow
    resetAll;
    req2_cmd_in = 2;
    req2_data_in = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
    #200
    req2_cmd_in = 0;
    req2_data_in = 32'b0000_0000_0001_0000_0000_0000_0000_0000; //Underflow
    waitForResp2;
    test(out_resp2, 2, 9);
    test(out_data2, 32'b1111_1111_1111_1111_1111_1111_1111_1111, 9);

    // TEST10 // Underflow 1
    resetAll;
    req3_cmd_in = 2;
    req3_data_in = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
    #200
    req3_cmd_in = 0;
    req3_data_in = 32'b0000_0000_0001_0000_0000_0000_0000_0000; //Underflow
    waitForResp3;
    test(out_resp3, 2, 10);
    test(out_data3, 32'b1111_1111_1111_1111_1111_1111_1111_1111, 10);

    // TEST11 // Underflow, timeout
    resetAll;
    req4_cmd_in = 2;
    req4_data_in = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
    #200
    req4_cmd_in = 0;
    req4_data_in = 32'b0000_0000_0001_0000_0000_0000_0000_0000; //Underflow
    waitForResp4;
    test(out_resp4, 2, 11);
    test(out_data4, 32'b1111_1111_1111_1111_1111_1111_1111_1111, 11);

    $stop;

end // initial begin

always
    @ (reset or req1_cmd_in or req1_data_in or req2_cmd_in or req2_data_in or req3_cmd_in or req3_data_in or req4_cmd_in or req4_data_in) begin

    end

    task waitForResp1;
        fork : f
            begin
                #2000
                $display("%0t : timeout", $time);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp1);
                //$display("%t : resp1 signal", $time);
                disable f;
            end
        join
    endtask

    task waitForResp2;
        fork : f
            begin
                #2000
                $display("%0t : timeout", $time);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp2);
                disable f;
            end
        join
    endtask

    task waitForResp3;
        fork : f
            begin
                #2000
                $display("%0t : timeout", $time);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp3);
                disable f;
            end
        join
    endtask

    task waitForResp4;
        fork : f
            begin
                #2000
                $display("%0t : timeout", $time);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp4);
                disable f;
            end
        join
    endtask


    task resetAll;
    begin
        reset[1] = 1;
        #800
        reset[1] = 0;
        req1_cmd_in = 0;
        req1_data_in = 0;
        req2_cmd_in = 0;
        req2_data_in = 0;
        req3_cmd_in = 0;
        req3_data_in = 0;
        req4_data_in = 0;
        #300;
    end
    endtask


    task test;
        input [0:31] act, exp;
        input integer n;
        if ( exp == act)
            $display("\nTest %0d passed \n\n", n);
        else
            $display("\nTest %0d didn't pass \nexp: %0d\nact: %0d \n\n", n, exp, act);
    endtask

endmodule // sub_calc1_tb