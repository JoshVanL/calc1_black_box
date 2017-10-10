`uselib lib=calc1_black_box

module add_calc1_tb;

wire [0:31]   out_data1, out_data2, out_data3, out_data4;
wire [0:1]    out_resp1, out_resp2, out_resp3, out_resp4;

reg 	      c_clk;
reg [0:3]     req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
reg [0:31]    req1_data_in, req2_data_in, req3_data_in, req4_data_in;
reg [1:7]     reset;

integer resp_wire, resp;

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


    $display("\nTesting adding operator.. \n");

    // First drive reset. Driving bit 1 is enough to reset the design.
    // TEST 1
    resetAll;
    add(32'b0000_0000_0000_0000_0000_0000_0000_0001, 32'b0001_1111_1111_1111_1111_1111_1111_1111, 1, "carry case");

    // TEST2
    resetAll;
    add(32'b0000_0000_0000_0000_0000_0000_0000_0000, 32'b0001_1111_1111_1111_1111_1111_1111_1111, 2, "0 + 0");

    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000;

    // TEST3
    resetAll;
    req1_cmd_in = 1;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_1000;
    #200
    req1_cmd_in = 0;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
    waitForResp1(out_resp1);
    test(out_data1, 32'b0000_0000_0000_0000_0000_0000_0000_1000, 3);

    // TEST4
    resetAll;
    req1_cmd_in = 1;
    req1_data_in = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
    #200
    req1_cmd_in = 0;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
    waitForResp1(out_resp1);
    test(out_data1, 32'b0000_0000_0000_0000_1000_0000_0000_0000, 4);

    // TEST5
    resetAll;
    req2_cmd_in = 1;
    req2_data_in = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
    #200
    req2_cmd_in = 0;
    req2_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
    waitForResp2;
    test(out_data2, 32'b0000_0000_0000_0000_1000_0000_0000_0000, 5);

    // TEST6
    resetAll;
    req3_cmd_in = 1;
    req3_data_in = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
    #200
    req3_cmd_in = 0;
    req3_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
    waitForResp3;
    test(out_data3, 32'b0000_0000_0000_0000_1000_0000_0000_0000, 6);

    // TEST7 //reg 4 times out
    resetAll;
    req4_cmd_in = 1;
    req4_data_in = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
    #200
    req4_cmd_in = 0;
    req4_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
    waitForResp4;
    test(out_data4, 32'b0000_0000_0000_0000_1000_0000_0000_0000, 7);

    // TEST8 // Overflow doesn't return value and wont error 2 [1] returns 0,
    // not accepting max value??
    resetAll;
    req1_cmd_in = 1;
    req1_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
    #200
    req1_cmd_in = 0;
    req1_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000; //Overflow
    waitForResp1;
    test(out_resp1, 2, 8);

    // TEST9 // Overflow doesn't return value and wont error 2 [2]
    resetAll;
    req2_cmd_in = 1;
    req2_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
    #200
    req2_cmd_in = 0;
    req2_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000; //Overflow
    waitForResp2;
    test(out_resp2, 2, 9);

    // TEST10 // Overflow
    resetAll;
    req3_cmd_in = 1;
    req3_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
    #200
    req3_cmd_in = 0;
    req3_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000; //Overflow
    waitForResp3;
    test(out_resp3, 2, 10);

    // TEST11 // Overflow doesn't return value and wont error 2 [2]
    resetAll;
    req4_cmd_in = 1;
    req4_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
    #200
    req4_cmd_in = 0;
    req4_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000; //Overflow
    waitForResp4;
    test(out_resp4, 2, 11);

    $stop;

end // initial begin

always
    @ (reset or req1_cmd_in or req1_data_in or req2_cmd_in or req2_data_in or req3_cmd_in or req3_data_in or req4_cmd_in or req4_data_in, out_resp1, out_resp2, out_resp3, out_resp4) begin

end

    task waitForResp;
        fork : f
            begin
                #2000
                $display("%0t : timeout on all responces", $time);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp1);
                resp = out_resp1;
                resp_wire = 1;
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp2);
                resp = out_resp2;
                resp_wire = 2;
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp3);
                resp = out_resp3;
                resp_wire = 3;
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp3);
                resp = out_resp4;
                resp_wire = 4;
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
        input exp_resp_wire, n;
        integer exp_resp_wire, n;
        reg[100*8:0] testName;

        integer fail;
        reg[100*8:0] outputStr;

        begin
        outputStr = $sformat("Test %d - %s\n", n, tesName);
        fail = 0;

        if (resp_wire != exp_resp_wire)
            outputStr = $sformat("%sgot unexpected responce wire. exp=%d got=%d\n", outputStr, exp_resp_wire, resp_wire);
            fail = 1;

        if ( resp != 1 )
            outputStr = $sformat("%sresponce wire from %d got unexpected responce. exp=1 got=%d\n", outputStr, resp_wire, resp);
        fail = 1;

        if ( exp != act )
            outputStr = $sformat("got unexpected result from oporator. exp=%d got=%d\n", outputStr, exp, act);
        fail = 1;

        if ( !fail )
            outputStr = $sformat("Test %d Passed.", outputStr, n);

        $display("%s", outputStr);
        end
    endtask

    task add;
    reg [0:31] x1, x2;
    integer n;
    reg [100*8:0] testName;
    begin
        resetAll;
        req1_cmd_in = 1;
        req1_data_in = x1;
        #200
        req1_cmd_in = 0;
        req1_data_in = x2;
        #200
        waitForResp;
        // actual, expected, responce wire, test #, test name
        test(out_data1, (x1+x2), 1, n, testName);
    end
    endtask

endmodule // add_calc1_tb
