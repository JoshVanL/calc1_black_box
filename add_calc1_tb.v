`uselib lib=calc1_black_box

module add_calc1_tb;

wire [0:31]   out_data1, out_data2, out_data3, out_data4;
wire [0:1]    out_resp1, out_resp2, out_resp3, out_resp4;

reg 	      c_clk;
reg [0:3]     req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
reg [0:31]    req1_data_in, req2_data_in, req3_data_in, req4_data_in;
reg [1:7]     reset;

integer totalTests, passedTests, failedTests;
integer resp_wire;
reg [0:1] resp;
reg [0:31] out_dat;
integer i;
reg [0:31] a, b;

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

    totalTests = 0;
    passedTests = 0;
    failedTests = 0;
end

always #100 c_clk = ~c_clk;

initial
begin


    $display("\nTesting adding operator.. \n");

    // First drive reset. Driving bit 1 is enough to reset the design.
    // TEST 1
    resetAll;
    a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
    b = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
    for (i = 1; i <= 4; i = i + 1)
    begin
        add(a, b, i, "normal");
    end

    // TEST 2
    resetAll;
    a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
    b = 32'b0001_1111_1111_1111_1111_1111_1111_1111;
    for (i = 1; i <= 4; i = i + 1)
    begin
        add(a, b, i, "carry case");
    end

    // TEST3
    a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    b = 32'b0001_1111_1111_1111_1111_1111_1111_1111;
    for (i = 1; i <= 4; i = i + 1)
    begin
        add(a, b, i, "0 + n");
        //b = $urandom% (2**31);
    end

    // TEST3
    a = 32'b0000_0000_0000_0000_0000_0000_0000_1000;
    b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
    for (i = 1; i <= 4; i = i + 1)
    begin
        add(a, b, i, "n + 0");
        //a = $urandom% (2**32);
    end

    // TEST4
    a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
    for (i = 1; i <= 4; i = i + 1)
    begin
        add(a, b, i, "0 + 0");
    end

    // TEST8 // Overflow doesn't return value and wont error 2 [1] returns 0,
    // not accepting max value??
    resetAll;
    a = 32'b1111_0000_0000_0000_0000_0000_0000_0000;
    b = 32'b1111_0000_0000_0000_0000_0000_0000_0000; //Overflow
    for (i = 1; i <= 4; i = i + 1)
    begin
        //$display("%0d - %0d", a, b);
        add(a, b, i, "Overflow");
    end

    //// TEST9 // Overflow doesn't return value and wont error 2 [2]
    //resetAll;
    //req2_cmd_in = 1;
    //req2_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
    //#200
    //req2_cmd_in = 0;
    //req2_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000; //Overflow
    //waitForResp2;
    //test(out_resp2, 2, 9);

    //// TEST10 // Overflow
    //resetAll;
    //req3_cmd_in = 1;
    //req3_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
    //#200
    //req3_cmd_in = 0;
    //req3_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000; //Overflow
    //waitForResp3;
    //test(out_resp3, 2, 10);

    //// TEST11 // Overflow doesn't return value and wont error 2 [2]
    //resetAll;
    //req4_cmd_in = 1;
    //req4_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
    //#200
    //req4_cmd_in = 0;
    //req4_data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000; //Overflow
    //waitForResp4;
    //test(out_resp4, 2, 11);


    finish;

    $stop;

end // initial begin

always
    @ (reset or req1_cmd_in or req1_data_in or req2_cmd_in or req2_data_in or req3_cmd_in or req3_data_in or req4_cmd_in or req4_data_in, out_resp1, out_resp2, out_resp3, out_resp4, resp, resp_wire) begin

end

    task waitForResp;
        fork : f
            begin
                #4000
                $display("%0t : timeout on all response wires", $time);
                resp_wire = 0;
                resp = 0;
                out_dat = 0;
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp1);
                out_dat = out_data1;
                resp = out_resp1;
                resp_wire = 1;
                $display("%0d", out_data1);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp2);
                out_dat = out_data2;
                resp = out_resp2;
                resp_wire = 2;
                $display("%0d", out_data2);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp3);
                out_dat = out_data3;
                resp = out_resp3;
                resp_wire = 3;
                $display("%0d", out_data3);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp4);
                out_dat = out_data4;
                resp = out_resp4;
                $display("%0d", out_data4);
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
        #1000;
    end
    endtask


    task test;
        input exp, exp_resp_wire, testName;

        reg[0:63] exp;
        integer exp_resp_wire;
        reg[100*8:0] testName;


        reg fail;

        begin
        totalTests = totalTests + 1;

        fail = 0;

        if (resp_wire != exp_resp_wire)
        begin
            $display("got response form an unexpected wire. exp=%0d got=%0d", exp_resp_wire, resp_wire);
            fail = 1;
        end

        if ( resp != 1 )
        begin
            $display("response wire from %0d got unexpected response. exp=1 got=%0d", resp_wire, resp);
            fail = 1;
        end

        if ( exp != out_dat )
        begin
            $display("got unexpected result from operator. exp=%0d got=%0d", exp, out_dat);
            fail = 1;
        end

        if ( fail == 1 )
        begin
            failedTests = failedTests + 1;
            $display("Test %0d Failed.\n", totalTests);
        end
        else
        begin
            passedTests = passedTests + 1;
            $display("Test %0d Passed.\n", totalTests);
        end

        end
    endtask

    task finish;
        begin
            $display("Total tests:  %0d\nTotal passed: %0d\nTotal failed: %0d\n", totalTests, passedTests, failedTests);
        end
    endtask


    task add;
    input x1, x2, inpWire, testName;

    //reg [0:31] x1, x2;
    reg [100*8:0] testName;
    integer inpWire;
    reg[0:31] x1, x2;

    begin
        resetAll;
        $display("Test %0d - %0s  r(%0d)", totalTests, testName, inpWire);
        putOnWire(inpWire, x1, x2, 1);
        waitForResp;
        // actual, expected, responce wire, test name
        $display("%0d %0d", x1, x2);
        test((x1 + x2), inpWire, testName);
    end
    endtask


    task putOnWire;
        input inpWire, data1, data2, cmd;

        integer inpWire;
        reg [0:31] data1, data2;
        reg [0:3]  cmd;
        begin
            case (inpWire)
                1:begin
                        req1_cmd_in = cmd;
                        req1_data_in = data1;
                        #200;
                        req1_cmd_in = 0;
                        req1_data_in = data2;
                    end
                2:begin
                        req2_cmd_in = cmd;
                        req2_data_in = data1;
                        #300;
                        req2_cmd_in = 0;
                        req2_data_in = data2;
                    end
                3:begin
                        req3_cmd_in = cmd;
                        req3_data_in = data1;
                        #200;
                        req3_cmd_in = 0;
                        req3_data_in = data2;
                    end
                4:begin
                        req4_cmd_in = cmd;
                        req4_data_in = data1;
                        #200;
                        req4_cmd_in = 0;
                        req4_data_in = data2;
                    end
            endcase
            #200;
        end
    endtask

endmodule // add_calc1_tb
