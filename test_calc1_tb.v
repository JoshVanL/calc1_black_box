`uselib lib=calc1_black_box

module test_calc1_tb;

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
integer i, j, k, l;
reg [0:31] a, b, c;
reg [0:31] max;

calc1 DUV(out_data1, out_data2, out_data3, out_data4, out_resp1, out_resp2, out_resp3, out_resp4, c_clk, req1_cmd_in, req1_data_in, req2_cmd_in, req2_data_in, req3_cmd_in, req3_data_in, req4_cmd_in, req4_data_in, reset);


always #100 c_clk = ~c_clk;

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

    max = 32'b1111_1111_1111_1111_1111_1111_1111_1111;

    //testAdd;
    //testSub;
    //testLeft;
    testRight;

    //Parallel2;

    finish;

    $stop;
end

task testAdd;
    begin


        $display("\n --- Testing adding operator.. ---\n");

        // First drive reset. Driving bit 1 is enough to reset the design.
        // TEST 1
        resetAll;
        a = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
        b = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        for (i = 1; i <= 4; i = i + 1) begin
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

         //TEST3
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

         //TEST4
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


    end // initial begin
endtask

task testSub;
    begin

        $display("\n --- Testing subtracting operator.. ---\n");

        // First drive reset. Driving bit 1 is enough to reset the design.
        // TEST 1
        resetAll;
        a = 32'b0001_0100_1111_1111_1111_1111_1111_1101;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        //$display("%0d", a-b);
        for (i = 1; i <= 4; i = i + 1) begin
            //b = $urandom%(2**10);
            sub(a, b, i, "normal");
        end

        // TEST 2
        resetAll;
        a = 32'b0001_1111_1111_0000_0000_1111_1111_1111;
        b = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            //a = $urandom%(2**31);
            sub(a, b, i, "carry case");
        end

        // TEST3
        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        b = 32'b0001_1111_1111_1111_1111_1111_1111_1111;
        for (i = 1; i <= 4; i = i + 1)
        begin
            //b = $urandom%(2**31);
            sub(a, b, i, "0 - n");
        end

        // TEST3
        a = 32'b0000_0011_0100_0100_0100_0000_0000_1000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
        for (i = 1; i <= 4; i = i + 1)
        begin
            a = $urandom% (2**31);
            sub(a, b, i, "n - 0");
        end

        // TEST4
        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
        for (i = 1; i <= 4; i = i + 1)
        begin
            sub(a, b, i, "0 - 0");
        end

        // TEST8 // Overflow doesn't return value and wont error 2 [1] returns 0,
        // not accepting max value??
        resetAll;
        a = 32'b0000_0000_0101_0100_0110_0000_1110_0000;
        b = 32'b1111_0000_0000_0000_0000_0000_0000_0000; //Overflow
        for (i = 1; i <= 4; i = i + 1)
        begin
            //a = $urandom% (2**30);
            //$display("%0d - %0d", a, b);
            sub(a, b, i, "Underflow");
        end

    end //// initial begin
endtask


task testLeft;
    begin

        $display("\n --- Testing shift left operator.. ---\n");

        // First drive reset. Driving bit 1 is enough to reset the design.
        // TEST 1
        resetAll;
        a = 32'b0001_0100_1111_1111_1111_1111_1111_1101;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        //$display("%0d", a-b);
        for (i = 1; i <= 4; i = i + 1) begin
            left(a, b, i, "normal", 1);
            //a = $urandom% (2**21);
            //b = $urandom% (2**3);
        end

        // TEST 2
        resetAll;
        a = 32'b0000_1111_1111_0000_0000_1111_1111_1111;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        for (i = 1; i <= 4; i = i + 1)
        begin
            left(a, b, i, "carry case", 1);
        end

        // TEST3
        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0101_1110;
        for (i = 1; i <= 4; i = i + 1)
        begin
            b = $urandom% (2**31);
            left(a, b, i, "0 << n", 1);
        end

        // TEST3
        a = 32'b0000_0011_0100_0100_0100_0000_0000_1000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            a = $urandom% (2**31);
            left(a, b, i, "n << 0", 1);
        end

        // TEST4
        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
        for (i = 1; i <= 4; i = i + 1)
        begin
            left(a, b, i, "0 << 0", 1);
        end

        // TEST8 // Overflow doesn't return value and wont error 2 [1] returns 0,
        // not accepting max value??
        resetAll;
        a = 32'b1100_0000_0101_0100_0110_0000_1110_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0100; //OverflowQ
        for (i = 1; i <= 4; i = i + 1)
        begin
            //$display("%0d - %0d", a, b);
            //a = $urandom% (2**31);
            left(a, b, i, "Overflow", 2);
        end

    end // initial begin
endtask

task testRight;
    begin

        $display("\n --- Testing shift right operator.. --- \n");

        // First drive reset. Driving bit 1 is enough to reset the design.
        // TEST 1
        //resetAll;
        //a = 32'b0001_0100_1111_1111_1111_1111_1111_0000;
        //b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        ////$display("%0d", a-b);
        //for (i = 1; i <= 4; i = i + 1) begin
        //    right(a, b, i, "normal", 1);
        //end

        //resetAll;
        //a = 32'b0001_0100_1111_1111_1111_1111_1111_1100;
        //b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        ////$display("%0d", a-b);
        //for (i = 1; i <= 4; i = i + 1) begin
        //    a = $urandom% (2**31);
        //    right(a, b, i, "n >> 1", 1);
        //end

        // TEST 2
        //resetAll;
        //a = 32'b1111_1111_0000_1111_0000_1111_0000_1111;
        //b = 32'b0000_0000_0000_0000_0000_0000_0000_1010;
        //c = 32'b0000_0000_0000_0100_0000_0100_0000_0000;
        //for (j = 1; j <= 16; j = j + 1) begin
        //    for (i = 1; i <= 4; i = i + 1) begin
        //        right(a, (b+c), i, "carry case", 2);
        //    end
        //    //c = c << 1;
        //end
        //b = b << 1;

        //// TEST3
        //a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        //b = 32'b0001_1111_1111_1111_1111_1111_1111_1111;
        //for (j = 1; j <= 16; j = j + 1) begin
        //    b = $urandom% (2**31);
        //    for (i = 1; i <= 4; i = i + 1) begin
        //        right(a, b, i, "0 >> n", 1);
        //    end
        //end

        //// TEST3
        //a = 32'b0000_0011_0100_0100_0100_0000_0000_1000;
        //b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
        //a = $urandom% (2**31);
        //for (i = 1; i <= 4; i = i + 1) begin
        //    right(a, b, i, "n >> 0", 1);
        //    //a = $urandom% (2**32);
        //end

        //// TEST4
        //a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        //b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
        //for (i = 1; i <= 4; i = i + 1)
        //begin
        //    right(a, b, i, "0 >> 0", 1);
        //end

        // TEST8 // Overflow doesn't return value and wont error 2 [1] returns 0,
        // not accepting max value??
        resetAll;
        a = 32'b0000_0000_0101_0100_0110_0000_1110_0000;
        b = 32'b1111_0000_0000_0000_0000_0000_0000_0000; //Overflow
        for (i = 1; i <= 4; i = i + 1)
        begin
            //$display("%0d - %0d", a, b);
            right(a, b, i, "Underflow", 2);
        end

    end // initial begin
endtask

task Parallel2;
begin

    $display("\n --- Testing operators in parallel.. ---\n");

    a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
    b = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
    for (i = 1; i <= 4; i = i + 1) begin
        for (j = 1; j <= 4; j = j + 1) begin
            if (i != j) begin
                parallel2(a, b, 1, i, a, b, 1, j, "parallel command test - add");
            end
        end
    end
    for (i = 1; i <= 4; i = i + 1) begin
        for (j = 1; j <= 4; j = j + 1) begin
           if (i != j) begin
                parallel2(a, b, 2, i, a, b, 2, j, "parallel command test - sub");
            end
        end
    end
    a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
    b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
    for (i = 1; i <= 4; i = i + 1) begin
        for (j = 1; j <= 4; j = j + 1) begin
           if (i != j) begin
                parallel2(a, b, 5, i, a, b, 5, j, "parallel command test - left");
            end
        end
    end
    a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
    b = 32'b0000_0000_0000_0000_0000_0000_0000_1111;
    for (i = 1; i <= 4; i = i + 1) begin
        for (j = 1; j <= 4; j = j + 1) begin
           if (i != j) begin
                parallel2(a, b, 6, i, a, b, 6, j, "parallel command test - right");
            end
        end
    end
    //a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
    //b = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
    //for (i = 1; i <= 4; i = i + 1) begin
    //    for (j = 1; j <= 4; j = j + 1) begin
    //        for (k = 1; k <= 6; k  = k + 1) begin
    //            for (l = 1; l <= 6; l  = l + 1) begin
    //            if (i != j && k != 3 && k != 4 && l != 3 && l != 4) begin
    //                parallel2(a, b, k, i, a, b, l, j, "parallel command test - add");
    //            end
    //            end
    //        end
    //    end
    //end
end
endtask

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
                //$display("%0d", out_resp1);
                resp_wire = 1;
                //$display("%0d - 1", out_data1);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp2);
                out_dat = out_data2;
                //$display("%0d", out_resp2);
                resp = out_resp2;
                resp_wire = 2;
                //$display("%0d - 2", out_data2);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp3);
                out_dat = out_data3;
                //$display("%0d", out_resp3);
                resp = out_resp3;
                resp_wire = 3;
                //$display("%0d - 3", out_data3);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp4);
                out_dat = out_data4;
                //$display("%0d", out_resp4);
                resp = out_resp4;
                //$display("%0d - 4", out_data4);
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
            req4_cmd_in = 0;
            #1000;
        end
    endtask


    task test;
        input exp, exp_resp_wire, exp_resp;

        reg[0:31] exp;
        integer exp_resp_wire;
        reg[0:1] exp_resp;


        reg fail;
        begin
            $display("responce: %0d - out_data: %b", resp, out_dat);
            fail = 0;

            if (resp_wire != exp_resp_wire)
            begin
                $display("got response from an unexpected wire. exp=%0d got=%0d", exp_resp_wire, resp_wire);
                fail = 1;
            end

            if ( resp != exp_resp )
            begin
                $display("response wire from %0d got unexpected response. exp=%0d got=%0d", resp_wire, exp_resp, resp);
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
        integer inpWire;
        reg[0:31] x1, x2;
        reg [100*8:0] testName;
        reg[0:1] exp_resp;
        reg [0:63] work;

        begin
            totalTests = totalTests + 1;
            resetAll;
            $display("Test %0d - %0s  r(%0d)", totalTests, testName, inpWire);
            put2OnWire(inpWire, x1, x2, 1);
            waitForResp;

            work = x1 + x2;
            if (work > max)
                exp_resp = 2;
            else
                exp_resp = 1;


            test((x1 + x2), inpWire, exp_resp);
        end
    endtask

    task sub;
        input x1, x2, inpWire, testName;

        //reg [0:31] x1, x2;
        integer inpWire;
        reg[0:31] x1, x2;
        reg [100*8:0] testName;
        reg[0:1] exp_resp;

        begin
            totalTests = totalTests + 1;
            resetAll;
            $display("Test %0d - %0s  r(%0d)", totalTests, testName, inpWire);
            put2OnWire(inpWire, x1, x2, 2);
            waitForResp;

            if (x2 > x1)
                exp_resp = 2;
            else
                exp_resp = 1;

            test(resolve(x1, x2, 1), inpWire, exp_resp);
        end
    endtask

    task left;
        input x1, x2, inpWire, testName, exp_resp;
        integer inpWire;
        reg[0:31] x1, x2;
        reg [100*8:0] testName;
        reg[0:1] exp_resp;

        begin
            totalTests = totalTests + 1;
            resetAll;
            $display("Test %0d - %0s  r(%0d)", totalTests, testName, inpWire);
            put2OnWire(inpWire, x1, x2, 5);
            waitForResp;

            test(resolve(x1, x2, 5), inpWire, exp_resp);
        end
    endtask

    task right;
        input x1, x2, inpWire, testName, exp_resp;
        //reg [0:31] x1, x2;
        integer inpWire;
        reg[0:31] x1, x2;
        reg [100*8:0] testName;
        reg[0:1] exp_resp;

        begin
            //$display("%0d - %0d", x1, x2);
            //$display("%0d", x1 >> x2);
            totalTests = totalTests + 1;
            resetAll;
            $display("Test %0d - %0s  r(%0d)", totalTests, testName, inpWire);
            put2OnWire(inpWire, x1, x2, 6);
            waitForResp;
            // actual, expected, responce wire, test name
            //$display("%0d %0d", x1, x2);
            //$display("%0d", (x1-x2));
            test(resolve(x1, x2, 6), inpWire, exp_resp);
        end
    endtask

    task parallel2;
        input x11, x12, cmd1, wire1, x21, x22, cmd2, wire2, testName;
        //reg [0:31] x1, x2;
        integer wire1, wire2;
        reg [0:3]  cmd1, cmd2;
        reg[0:31] x11, x12, x21, x22;
        reg [100*8:0] testName;

        begin
            //$display("%0d - %0d", x1, x2);
            //$display("%0d", x1 >> x2);
            totalTests = totalTests + 2;
            resetAll;
            $display("Test %0d - %0s  r(%0d, %0d)", totalTests, testName, wire1, wire2);
            putOnWire(wire1, x11, cmd1  );
            putOnWire(wire2, x21, cmd2);
            #200;
            putOnWire(wire1, x12, 0);
            putOnWire(wire2, x22, 0);
            waitForResp;
            test(resolve(x11, x12, cmd1), wire1, 1);
            waitForResp;
            test(resolve(x21, x22, cmd2), wire2, 1);
        end
    endtask

    function reg[0:31] resolve(input x1, x2, cmd);
        reg [0:31] x1, x2;
        reg[0:3] cmd;
        begin
            case (cmd)
                0:begin
                    resolve = 0;
                end
                1:begin
                    resolve = x1 + x2;
                end
                2:begin
                    resolve = x1 - x2;
                end
                5:begin
                    resolve =  x1 << x2;
                end
                6:begin
                    resolve =  x1 >> x2;
                end
                default:begin
                    resolve = 0;
                end
            endcase
            $display("resolve: %0d (%0d) %0d = %0d", x1, cmd, x2, resolve);
        end
    endfunction


    task putOnWire;
        input inpWire, data, cmd;
        integer inpWire;
        reg [0:31] data;
        reg [0:3]  cmd;
        begin
            case (inpWire)
                1:begin
                    req1_cmd_in = cmd;
                    req1_data_in = data;
                end
                2:begin
                    req2_cmd_in = cmd;
                    req2_data_in = data;
                end
                3:begin
                    req3_cmd_in = cmd;
                    req3_data_in = data;
                end
                4:begin
                    req4_cmd_in = cmd;
                    req4_data_in = data;
                end
            endcase
        end
    endtask


    task put2OnWire;
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
                    #200;
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
        end
    endtask

    endmodule //  test_calc1_tb
