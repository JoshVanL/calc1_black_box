`uselib lib=calc1_black_box
`define ADD 1
`define SUB 2
`define LEFT 5
`define RIGHT 6


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
reg [0:31] a, b, c, d;

reg[256*8:0] string;

reg passed;

calc1 DUV(out_data1, out_data2, out_data3, out_data4, out_resp1, out_resp2, out_resp3, out_resp4, c_clk, req1_cmd_in, req1_data_in, req2_cmd_in, req2_data_in, req3_cmd_in, req3_data_in, req4_cmd_in, req4_data_in, reset);


always #100 c_clk = ~c_clk;

integer file;

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

    file = $fopen("calc1_black_box/results", "w");

    testAdd;
    testSub;
    testLeft;
    testRight;

    testWrong;

    testParallel2;
    testParallel3;
    testParallel4;

    finish;

    $fclose(file);

    $stop;
end

task testAdd;
    begin
        print(file, "\n --- Testing adding operator ---\n");

        a = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
        b = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        for (i = 1; i <= 4; i = i + 1) begin
            driver(a, b, `ADD, i, "normal");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        b = 32'b0001_1111_1111_1111_1111_1111_1111_1111;
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `ADD, i, "carry case");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            b = $urandom% (2**31);
            driver(a, b, `ADD, i, "0 + n");
        end

        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            a = $urandom% (2**31);
            driver(a, b, `ADD, i, "n + 0");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `ADD, i, "0 + 0");
        end

        a = 32'b1111_0000_0000_0000_0000_0000_0000_0000;
        b = 32'b1111_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `ADD, i, "Overflow");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        b = 32'b0001_0100_1111_1111_1111_1111_1100_1101;
        c = 1;
        for (j=1; j <= 2; j = j + 1) begin
            for (i=0; i < 31; i = i + 1) begin
                driver(a, b, `ADD, c, "Test first data input bits");
                a = a * 2;
            end
            a = 1;
            c = 3;
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1100_1101;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        c = 1;
        for (j=1; j <= 2; j = j + 1) begin
            for (i=0; i < 31; i = i + 1) begin
                driver(a, b, `ADD, c, "Test second data input bits");
                b = b * 2;
            end
            b = 1;
            c = 3;
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1110_1101;
        b = 32'b0000_0000_0000_0000_0000_0000_0001_0000;
        c = 1;
        for (j=1; j <= 2; j = j + 1) begin
            driver(a, b, `ADD, c, "Add in 5th position");
            c = 3;
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1110_1101;
        b = 32'b1011_0110_0011_0110_0000_0000_1010_0000;
        c = 1;
        for (j=1; j <= 2; j = j + 1) begin
            driver(a, b, `ADD, c, "Add in 6th position");
            c = 3;
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1110_1101;
        b = 32'b0000_0000_0000_0000_0011_0000_0011_0000;
        driver(a, b, `ADD, 1, "Add in 5 + 6 position");
        driver(a, b, `ADD, 3, "Add in 5 + 6 position");

        a = 32'b0001_0100_1111_1111_1111_1111_1110_1101;
        b = 32'b0000_0000_0000_0000_0001_0000_0000_0000;
        c = 1;
        for (j=1; j <= 2; j = j + 1) begin
            driver(a, b, `ADD, c, "Add in 13th position");
            c = 3;
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1110_1101;
        b = 32'b0000_0000_0000_0000_0010_0000_0000_0000;
        c = 1;
        for (j=1; j <= 2; j = j + 1) begin
            driver(a, b, `ADD, c, "Add in 14th position");
            c = 3;
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1110_1101;
        b = 32'b0000_0000_0000_0000_0011_0000_0000_0000;
        driver(a, b, `ADD, 1, "Add in 13 + 14 position");
        driver(a, b, `ADD, 3, "Add in 13 + 14 position");

         //5 - 13, 14
         //6 - 13, 14
        a = 32'b0001_0100_1111_1111_1111_1111_1110_1101;
        b = 32'b0000_0000_0000_0000_0000_0000_0001_0000;
        c = 1;
        d = 32'b0000_0000_0000_0000_0001_0000_0000_0000;
        for (j=1; j <= 2; j = j + 1) begin
            for (i=1; i <= 2; i = i + 1) begin
                driver(a, (b + d), `ADD, c, "Bad bits in conjunction");
                d = d * 2;
                driver(a, (b + d), `ADD, c, "Bad bits in conjunction");
                b = b * 2;
                d = 32'b0000_0000_0000_0000_0001_0000_0000_0000;
            end
            c = 3;
            b = 32'b0000_0000_0000_0000_0000_0000_0001_0000;
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1110_1101;
        b = 32'b0000_0000_0000_0000_0010_0000_0000_0000;
        c = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        for (i=1; i < 32; i = i + 1) begin
            $sformat(string, "Add in 14 + %0d position", i);
            print(file, string);
            driver(a, (b + c), `ADD, 1, "Add in 14 + other position");
            driver(a, (b + c), `ADD, 3, "Add in 14 + other position");
            c = c * 2;
        end

        c = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        b = 32'b0000_0000_0000_0000_0010_0011_0000_0000;
        driver(a, b, `ADD, 1, "Add in 14 + 9 + 10 position");
        driver(a, b, `ADD, 3, "Add in 14 + 9 + 10 position");

        a = 32'b0001_0100_1111_1111_1111_1111_1110_1101;
        b = 32'b0000_0000_0000_0000_0001_0000_0000_0000;
        c = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        for (i=1; i < 32; i = i + 1) begin
            $sformat(string, "Add in 13 + %0d position", i);
            print(file, string);
            driver(a, (b + c), `ADD, 1, "Add in 13 + other position");
            driver(a, (b + c), `ADD, 3, "Add in 13 + other position");
            c = c * 2;
        end

        c = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        b = 32'b0000_0000_0000_0000_0001_0011_0000_0000;
        driver(a, b, `ADD, 1, "Add in 13 + 9 + 10 position");
        driver(a, b, `ADD, 3, "Add in 13 + 9 + 10 position");

    end
endtask

task testSub;
    begin
        print(file, "\n --- Testing subtracting operator ---\n");

        a = 32'b0001_0100_1111_1111_1111_1111_1111_1101;
        b = 32'b0000_0000_0001_0011_0010_0000_0000_0001;
        for (i = 1; i <= 4; i = i + 1) begin
            driver(a, b, `SUB, i, "normal");
        end

        a = 32'b0001_1111_0000_0000_0000_0001_1111_1111;
        b = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `SUB, i, "carry case");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            b = $urandom% (2**31);
            driver(a, b, `SUB, i, "0 - n");
        end

        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
        for (i = 1; i <= 4; i = i + 1)
        begin
            a = $urandom% (2**31);
            driver(a, b, `SUB, i, "n - 0");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `SUB, i, "0 - 0");
        end

        a = 32'b0000_0000_0101_0100_0110_0000_1110_0000;
        b = 32'b1111_0000_0000_0000_0000_0000_0000_0000; //Overflow
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `SUB, i, "Underflow");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        b = 32'b0001_0100_1111_1111_1111_1111_1100_1101;
        c = 1;
        for (j=1; j <= 2; j = j + 1) begin
            for (i=0; i < 31; i = i + 1) begin
                driver(a, b, `SUB, c, "Test first data input bits");
                a = a * 2;
            end
            a = 1;
            c = 3;
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1100_1101;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        c = 1;
        for (j=1; j <= 2; j = j + 1) begin
            for (i=0; i < 31; i = i + 1) begin
                driver(a, b, `SUB, c, "Test second data input bits");
                b = b * 2;
            end
            c = 3;
            b = 1;
        end

    end
endtask


task testLeft;
    begin

        print(file, "\n --- Testing shift left operator ---\n");

        a = 32'b0000_0100_1111_1111_1111_1111_1111_1101;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        for (i = 1; i <= 4; i = i + 1) begin
            driver(a, b, `LEFT, i, "normal");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            b = $urandom% (2**31);
            driver(a, b, `LEFT, i, "0 << n");
        end

        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            a = $urandom% (2**31);
            driver(a, b, `LEFT, i, "n << 0");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `LEFT, i, "0 << 0");
        end

        a = 32'b1111_0000_1111_0000_1111_0000_1111_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0010_0010;
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `LEFT, i, "Overflow");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0101;
        for (i = 1; i <= 4; i = i + 1) begin
            for (j=0; j < 31; j = j + 1) begin
                driver(a, b, `LEFT, i, "Test first data input bits -- Left");
                a = a * 2;
            end
            a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0101;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        for (i = 1; i <= 4; i = i + 1) begin
            for (j=0; j < 31; j = j + 1) begin
                driver(a, b, `LEFT, i, "Test second data input bits -- Left");
                b = b * 2;
            end
            b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        end

        //For second data input drive 16 bit position off by 1
        a = 32'b0000_0000_0000_0000_0000_0000_0000_0111;
        b = 32'b0000_0000_0000_0000_0000_0000_0001_0000;
        for (i = 1; i <= 4; i = i + 1) begin
            if (i != 2)
                driver(a, b, `LEFT, i, "Shift left - 5th bit");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0111;
        b = 32'b0000_0000_0000_0000_0000_0000_0001_0000;
        c = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        for (j = 0; j < 32; j = j + 1) begin
            for (i = 1; i <= 4; i = i + 1) begin
                if (i != 2)
                    driver(a, (b + c), `LEFT, i, "Shift left - 5th bit and smaller");
            end
            c = c * 2;
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0111;
        b = 32'b0000_0000_0000_0000_0000_0000_0001_0110;
        driver(a, b, `LEFT, 1, "Shift left - 16 + 6");
        b = 32'b0000_0000_0000_0000_0000_0000_0001_1100;
        driver(a, b, `LEFT, 1, "Shift left - 16 + 12");
        b = 32'b0000_0000_0000_0000_0000_0000_0011_0000;
        driver(a, b, `LEFT, 1, "Shift left - 16 + 32 + 0");
        b = 32'b0000_0000_0000_0000_0000_0000_0011_0001;
        driver(a, b, `LEFT, 1, "Shift left - 16 + 32 + 1");
        b = 32'b0000_0000_0000_0000_0000_0000_0011_0010;
        driver(a, b, `LEFT, 1, "Shift left - 16 + 32 + 2");
        b = 32'b0000_0000_0000_0000_0000_0000_0101_0010;
        driver(a, b, `LEFT, 1, "Shift left - 16 + 64 + 2");
        b = 32'b0000_0000_0000_0000_0000_0001_0101_0010;
        driver(a, b, `LEFT, 1, "Shift left - 16 + 64  + 256 + 2");

    end
endtask

task testRight;
    begin

        print(file, "\n --- Testing shift right operator --- \n");

        a = 32'b0001_0100_1111_1111_1111_1111_1111_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        for (i = 1; i <= 4; i = i + 1) begin
            driver(a, b, `RIGHT, i, "normal");
        end

        b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        for (i = 1; i <= 4; i = i + 1) begin
            a = $urandom% (2**31);
            driver(a, b, `RIGHT, i, "n >> 1");
        end

        a = 32'b1111_1111_0000_1111_0000_1111_0000_1111;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_1010;
        for (i = 1; i <= 4; i = i + 1) begin
            driver(a, (b+c), `RIGHT, i, "carry case");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        for (i = 1; i <= 4; i = i + 1) begin
            b = $urandom% (2**31);
            driver(a, b, `RIGHT, i, "0 >> n");
        end

        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
        for (i = 1; i <= 4; i = i + 1) begin
            a = $urandom% (2**31);
            driver(a, b, `RIGHT, i, "n >> 0");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //Add by zero always returns 0
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `RIGHT, i, "0 >> 0");
        end

        a = 32'b0000_0000_0101_0100_0110_0000_1110_0000;
        b = 32'b1111_0000_0000_0000_0000_0000_0000_0000; //Overflow
        for (i = 1; i <= 4; i = i + 1)
        begin
            driver(a, b, `RIGHT, i, "Underflow");
        end

        a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0101;
        for (i = 1; i <= 4; i = i + 1) begin
            for (j=0; j < 31; j = j + 1) begin
                driver(a, b, `RIGHT, i, "Test first data input bits -- Right");
                a = a * 2;
            end
            a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        end

        a = 32'b1111_1111_1111_1111_1111_1111_1111_1000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        for (i = 1; i <= 4; i = i + 1) begin
            for (j=0; j < 31; j = j + 1) begin
                driver(a, b, `RIGHT, i, "Test second data input bits -- Right");
                b = b * 2;
            end
            b = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        end
    end
endtask

task testWrong;
    begin
        print(file, "\n --- Testing invalid command ---\n");

        a = $urandom% (2**31);
        b = $urandom% (2**31);
        for (i = 1; i <= 4; i = i + 1) begin
            driver(a, b, 3, i, "invalid command");
        end
    end
endtask

task testParallel2;
    begin
        print(file, "\n --- Testing 2 operators in parallel ---\n");

        // Unique combination of 2 out of 4 wires
        //for (i = 1; i < 4; i = i + 1) begin
        //for(j = i + 1; j <= 4; j = j +1) begin

        a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        b = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
        for (i = 1; i < 4; i = i + 1) begin
            for(j = i + 1; j <= 4; j = j+1) begin
                driver2(a, b, `ADD, i, a, b, 1, j, "parallel command test - add");
            end
        end


        a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        b = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
        for (i = 1; i < 4; i = i + 1) begin
            for(j = i + 1; j <= 4; j = j+1) begin
                driver2(a, b, `SUB, i, a, b, 2, j, "parallel command test - sub");
            end
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        for (i = 1; i < 4; i = i + 1) begin
            for(j = i + 1; j <= 4; j = j+1) begin
                driver2(a, b, `LEFT, i, a, b, 5, j, "parallel command test - left");
            end
        end

        a = 32'b0001_0100_1111_1111_1111_1111_1111_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        for (i = 1; i < 4; i = i + 1) begin
            for(j = i + 1; j <= 4; j = j+1) begin
                a = $urandom% (2**31);
                driver2(a, b, `RIGHT, i, a, b, 6, j, "parallel command test - right");
            end
        end

    end
endtask

task testParallel3;
    begin
        print(file, "\n --- Testing 3 operators in parallel ---\n");

        // Unique combination of 3 out of 4 wires
        // {{1, 2, 3}, {1, 2, 4}, {1, 3, 4}, {2, 3, 4}}

        a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        b = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
        driver3(a, b, `ADD, 1, a, b, `ADD, 2, a, b, `ADD, 3, "parallel 3 command test - add");
        driver3(a, b, `ADD, 1, a, b, `ADD, 2, a, b, `ADD, 4, "parallel 3 command test - add");
        driver3(a, b, `ADD, 1, a, b, `ADD, 3, a, b, `ADD, 4, "parallel 3 command test - add");
        driver3(a, b, `ADD, 2, a, b, `ADD, 3, a, b, `ADD, 4, "parallel 3 command test - add");


        a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        b = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
        driver3(a, b, `SUB, 1, a, b, `SUB, 2, a, b, `SUB, 3, "parallel 3 command test - sub");
        driver3(a, b, `SUB, 1, a, b, `SUB, 2, a, b, `SUB, 4, "parallel 3 command test - sub");
        driver3(a, b, `SUB, 1, a, b, `SUB, 3, a, b, `SUB, 4, "parallel 3 command test - sub");
        driver3(a, b, `SUB, 2, a, b, `SUB, 3, a, b, `SUB, 4, "parallel 3 command test - sub");

        a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        driver3(a, b, `LEFT, 1, a, b, `LEFT, 2, a, b, `LEFT, 3, "parallel 3 command test - left");
        driver3(a, b, `LEFT, 1, a, b, `LEFT, 2, a, b, `LEFT, 4, "parallel 3 command test - left");
        driver3(a, b, `LEFT, 1, a, b, `LEFT, 3, a, b, `LEFT, 4, "parallel 3 command test - left");
        driver3(a, b, `LEFT, 2, a, b, `LEFT, 3, a, b, `LEFT, 4, "parallel 3 command test - left");

        a = 32'b0001_0100_1111_1111_1111_1111_1111_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        driver3(a, b, `RIGHT, 1, a, b, `RIGHT, 2, a, b, `RIGHT, 3, "parallel 3 command test - right");
        driver3(a, b, `RIGHT, 1, a, b, `RIGHT, 2, a, b, `RIGHT, 4, "parallel 3 command test - right");
        driver3(a, b, `RIGHT, 1, a, b, `RIGHT, 3, a, b, `RIGHT, 4, "parallel 3 command test - right");
        driver3(a, b, `RIGHT, 2, a, b, `RIGHT, 3, a, b, `RIGHT, 4, "parallel 3 command test - right");
    end
endtask

task testParallel4;
    begin
        print(file, "\n --- Testing 4 operators in parallel ---\n");

        // Unique combination of 4 out of 4 wires
        // {{1, 2, 3, 4}}

        a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        b = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
        //a = ;
        driver4($urandom% (2**31), $urandom% (2**31), `ADD, 1, $urandom% (2**31), $urandom% (2**31), `ADD, 2, $urandom% (2**31), $urandom% (2**31), `ADD, 3, $urandom% (2**31), $urandom% (2**31), `ADD, 4, "parallel 4 command test - add");

        a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        b = 32'b0000_0011_1100_0100_0110_0000_0000_0001;
        driver4(a, b, `SUB, 1, a, b, `SUB, 2, a, b, `SUB, 3, a, b, `SUB, 4, "parallel 4 command test - sub");

        a = 32'b0001_0100_1111_1111_1111_1111_1111_1110;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        driver4(a, b, `LEFT, 1, a, b, `LEFT, 2, a, b, `LEFT, 3, a, b, `LEFT, 4, "parallel 4 command test - left");

        a = 32'b0001_0100_1111_1111_1111_1111_1111_0000;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        driver4(a, b, `RIGHT, 1, a, b, `RIGHT, 2, a, b, `RIGHT, 3, a, b, `RIGHT, 4, "parallel 4 command test - right");

        driver4($urandom% (2**31), $urandom% (2**31), `ADD, 1, $urandom% (2**31), $urandom% (2**31), `ADD, 2, $urandom% (2**31), $urandom% (2**31), `ADD, 3, $urandom% (2**31), $urandom% (2**31), `ADD, 4, "parallel 4 command test - add");
        driver4($urandom% (2**31), $urandom% (2**31), `SUB, 1, $urandom% (2**31), $urandom% (2**31), `SUB, 2, $urandom% (2**31), $urandom% (2**31), `SUB, 3, $urandom% (2**31), $urandom% (2**31), `SUB, 4, "parallel 4 command test - add");
        driver4($urandom% (2**31), $urandom% (2**31), `LEFT, 1, $urandom% (2**31), $urandom% (2**31), `LEFT, 2, $urandom% (2**31), $urandom% (2**31), `LEFT, 3, $urandom% (2**31), $urandom% (2**31), `LEFT, 4, "parallel 4 command test - add");
        driver4($urandom% (2**31), $urandom% (2**31), `RIGHT, 1, $urandom% (2**31), $urandom% (2**31), `RIGHT, 2, $urandom% (2**31), $urandom% (2**31), `RIGHT, 3, $urandom% (2**31), $urandom% (2**31), `RIGHT, 4, "parallel 4 command test - add");
    end
endtask

task waitForResp;
    fork : f
        begin
            #4000
            $sformat(string, "%0t : timeout on all response wires", $time);
            print(file, string);
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


task checker;
    input exp, exp_resp_wire, exp_resp;

    reg[0:31] exp;
    integer exp_resp_wire;
    reg[0:1] exp_resp;

    reg fail;
    begin
        $sformat(string, "responce: %0d - out_data: %b", resp, out_dat);
        print(file, string);
        fail = 0;

        if (resp_wire != exp_resp_wire)
        begin
            $sformat(string, "got response from an unexpected wire. exp=%0d got=%0d", exp_resp_wire, resp_wire);
            print(file, string);
            fail = 1;
        end

        if ( resp != exp_resp )
        begin
            $sformat(string, "response wire from %0d got unexpected response. exp=%0d got=%0d", resp_wire, exp_resp, resp);
            print(file, string);
            fail = 1;
        end

        if ( exp != out_dat )
        begin
            $sformat(string, "got unexpected result from operator. exp=%0d got=%0d (diff: %0d)  r(%0d)", exp, out_dat, $signed(exp - out_dat), resp_wire);
            print(file, string);
            fail = 1;
        end

        if ( fail == 1 )
            passed = 0;
        else
            passed = 1;

    end
endtask

task finish;
    begin
        $sformat(string, "Total tests:  %0d\nTotal passed: %0d\nTotal failed: %0d", totalTests, passedTests, failedTests);
        print(file, string);
    end
endtask

task driver;
    input x1, x2, cmd, inpWire, testName;

    reg[0:31] x1, x2;
    reg[0:3] cmd;
    integer inpWire;
    reg [100*8:0] testName;

    reg[0:1] exp_resp;
    reg [0:63] work;
    reg [0:31] res;

    begin
        totalTests = totalTests + 1;
        $sformat(string, "Test %0d - %0s  r(%0d)", totalTests, testName, inpWire);
        print(file, string);

        resetAll;
        drive2data(inpWire, x1, x2, cmd);
        waitForResp;

        exp_resp = getExpResp(x1, x2, cmd);

        res = resolve(x1, x2, cmd);
        $sformat(string, "resolve: %0d (%0d) %0d = %0d", x1, cmd, x2, res);
        print(file, string);

        checker(res, inpWire, exp_resp);

        if (passed == 1 ) begin
            passedTests = passedTests + 1;
            $sformat(string, "Test %0d Passed.", totalTests);
            print(file, string);
        end
        else begin
            $sformat(string, "Test %0d Failed.", totalTests);
            print(file, string);
            failedTests = failedTests + 1;
        end
        string = "";
        print(file, string);
    end
endtask



task driver2;
    input x11, x12, cmd1, wire1, x21, x22, cmd2, wire2, testName;

    integer wire1, wire2;
    reg [0:3]  cmd1, cmd2;
    reg[0:31] x11, x12, x21, x22;
    reg [100*8:0] testName;
    reg result;

    reg[0:1] exp_resp1, exp_resp2;
    reg [0:63] work;

    begin
        totalTests = totalTests + 1;
        resetAll;
        $sformat(string, "Test %0d - %0s  r(%0d, %0d)", totalTests, testName, wire1, wire2);
        print(file, string);
        drive4data(wire1, wire2, x11, x12, x21, x22, cmd1, cmd2);
        waitForResp;

        exp_resp1 = getExpResp(x11, x12, cmd1);
        exp_resp2 = getExpResp(x21, x22, cmd2);

        result = 1;
        checker(resolve(x11, x12, cmd1), wire1, exp_resp1);
        if (passed == 0)
            result = 0;

        waitForResp;
        checker(resolve(x21, x22, cmd2), wire2, exp_resp2);
        if (passed == 0)
            result = 0;

        if (result == 0) begin
            failedTests = failedTests + 1;
            $sformat(string, "Test %0d Failed.", totalTests);
            print(file, string);
        end
        else begin
            passedTests = passedTests + 1;
            $sformat(string, "Test %0d Passed.", totalTests);
            print(file, string);
        end
        string = "";
        print(file, string);
    end
endtask

task driver3;
    input x11, x12, cmd1, wire1, x21, x22, cmd2, wire2, x31, x32, cmd3, wire3, testName;

    integer wire1, wire2, wire3;
    reg [0:3]  cmd1, cmd2, cmd3;
    reg[0:31] x11, x12, x21, x22, x31, x32;
    reg [100*8:0] testName;
    reg result;

    reg[0:1] exp_resp1, exp_resp2, exp_resp3;
    reg [0:63] work;

    begin
        totalTests = totalTests + 1;
        resetAll;
        $sformat(string, "Test %0d - %0s  r(%0d, %0d, %0d)", totalTests, testName, wire1, wire2, wire3);
        print(file, string);
        drive6data(wire1, wire2, wire3, x11, x12, x21, x22, x31, x32, cmd1, cmd2, cmd3);
        waitForResp;

        exp_resp1 = getExpResp(x11, x12, cmd1);
        exp_resp2 = getExpResp(x21, x22, cmd2);
        exp_resp3 = getExpResp(x31, x32, cmd3);

        result = 1;
        checker(resolve(x11, x12, cmd1), wire1, exp_resp1);
        if (passed == 0)
            result = 0;

        waitForResp;
        checker(resolve(x21, x22, cmd2), wire2, exp_resp2);
        if (passed == 0)
            result = 0;

        waitForResp;
        checker(resolve(x31, x32, cmd3), wire3, exp_resp3);
        if (passed == 0)
            result = 0;

        if (result == 0) begin
            failedTests = failedTests + 1;
            $sformat(string, "Test %0d Failed.", totalTests);
            print(file, string);
        end
        else begin
            passedTests = passedTests + 1;
            $sformat(string, "Test %0d Passed.", totalTests);
            print(file, string);
        end
        string = "";
        print(file, string);
    end
endtask

task driver4;
    input x11, x12, cmd1, wire1, x21, x22, cmd2, wire2, x31, x32, cmd3, wire3, x41, x42, cmd4, wire4, testName;

    integer wire1, wire2, wire3, wire4;
    reg [0:3]  cmd1, cmd2, cmd3, cmd4;
    reg[0:31] x11, x12, x21, x22, x31, x32, x41, x42;
    reg [100*8:0] testName;
    reg result;

    reg[0:1] exp_resp1, exp_resp2, exp_resp3, exp_resp4;
    reg [0:63] work;

    begin
        totalTests = totalTests + 1;
        resetAll;
        $sformat(string, "Test %0d - %0s  r(%0d, %0d, %0d, %0d)", totalTests, testName, wire1, wire2, wire3, wire4);
        print(file, string);
        drive8data(wire1, wire2, wire3, wire4, x11, x12, x21, x22, x31, x32, x41, x42, cmd1, cmd2, cmd3, cmd4);
        waitForResp;

        exp_resp1 = getExpResp(x11, x12, cmd1);
        exp_resp2 = getExpResp(x21, x22, cmd2);
        exp_resp3 = getExpResp(x31, x32, cmd3);
        exp_resp4 = getExpResp(x41, x42, cmd4);

        result = 1;
        checker(resolve(x11, x12, cmd1), wire1, exp_resp1);
        if (passed == 0)
            result = 0;

        waitForResp;
        checker(resolve(x21, x22, cmd2), wire2, exp_resp2);
        if (passed == 0)
            result = 0;

        waitForResp;
        checker(resolve(x31, x32, cmd3), wire3, exp_resp3);
        if (passed == 0)
            result = 0;

        waitForResp;
        checker(resolve(x41, x42, cmd4), wire4, exp_resp4);
        if (passed == 0)
            result = 0;

        if (result == 0) begin
            failedTests = failedTests + 1;
            $sformat(string, "Test %0d Failed.", totalTests);
            print(file, string);
        end
        else begin
            passedTests = passedTests + 1;
            $sformat(string, "Test %0d Passed.", totalTests);
            print(file, string);
        end
        string = "";
        print(file, string);
    end
endtask
function integer mostSigBit(input n);
    reg[0:31] n;
    integer bitpos;
    begin
        bitpos = 0;
        while( n != 0 ) begin
            bitpos = bitpos + 1;
            n = n >> 1;
        end
        mostSigBit = bitpos;
    end
endfunction

function integer leastSigBit(input n);
    reg[0:31] n;
    integer bitpos;
    begin
        bitpos = 0;
        while( n != 0 ) begin
            bitpos = bitpos + 1;
            n = n << 1;
        end
        leastSigBit = (33 - bitpos);
    end
endfunction


function reg[0:1] getExpResp(input x1, x2, cmd);
    reg [0:31] x1, x2;
    reg [0:3] cmd;
    reg [0:63] work;
    reg [0:31] max;
    integer bitpos;

    begin
        case (cmd)
            `ADD:begin
                max = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
                work = x1 + x2;
                if (work > max)
                    getExpResp = 2;
                else
                    getExpResp = 1;
            end
            `SUB:begin
                if (x2 > x1)
                    getExpResp = 2;
                else
                    getExpResp = 1;
            end
            `LEFT:begin
                bitpos = mostSigBit(x1);
                if (x2 > (32 - bitpos) && x2 != 0 && x1 != 0)
                    getExpResp = 2;
                else
                    getExpResp = 1;
            end
            `RIGHT:begin
                bitpos = leastSigBit(x1);
                if (x2 >= bitpos && x2 != 0 && x1 != 0)
                    getExpResp = 2;
                else
                    getExpResp = 1;
            end
            default:begin
                getExpResp = 2;
            end
        endcase
    end
endfunction

function reg[0:31] resolve(input x1, x2, cmd);
    reg [0:31] x1, x2;
    reg[0:3] cmd;
    begin
        case (cmd)
            0:begin
                resolve = 0;
            end
            `ADD:begin
                resolve = x1 + x2;
            end
            `SUB:begin
                resolve = x1 - x2;
            end
            `LEFT:begin
                resolve =  x1 << x2;
            end
            `RIGHT:begin
                resolve =  x1 >> x2;
            end
            default:begin
                resolve = 0;
            end
        endcase
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


task drive2data;
    input inpWire, data1, data2, cmd;
    integer inpWire;
    reg [0:31] data1, data2;
    reg [0:3]  cmd;
    begin
        putOnWire(inpWire, data1, cmd);
        #200;
        putOnWire(inpWire, data2, 0);
    end
endtask

task drive4data;
    input inpWire1, inpWire2, data11, data12, data21, data22, cmd1, cmd2;

    integer inpWire1, inpWire2;
    reg [0:31] data11, data12, data21, data22;
    reg [0:3]  cmd1, cmd2;
    begin
        putOnWire(inpWire1, data11, cmd1);
        putOnWire(inpWire2, data21, cmd2);
        #200;
        putOnWire(inpWire1, data12, 0);
        putOnWire(inpWire2, data22, 0);
    end
endtask

task drive6data;
    input inpWire1, inpWire2, inpWire3, data11, data12, data21, data22, data31, data32, cmd1, cmd2, cmd3;

    integer inpWire1, inpWire2, inpWire3;
    reg [0:31] data11, data12, data21, data22, data31, data32;
    reg [0:3]  cmd1, cmd2, cmd3;
    begin
        putOnWire(inpWire1, data11, cmd1);
        putOnWire(inpWire2, data21, cmd2);
        putOnWire(inpWire3, data31, cmd3);
        #200;
        putOnWire(inpWire1, data12, 0);
        putOnWire(inpWire2, data22, 0);
        putOnWire(inpWire3, data32, 0);
    end
endtask

task drive8data;
    input inpWire1, inpWire2, inpWire3, inpWire4, data11, data12, data21, data22, data31, data32, data41, data42, cmd1, cmd2, cmd3, cmd4;

    integer inpWire1, inpWire2, inpWire3, inpWire4;
    reg [0:31] data11, data12, data21, data22, data31, data32, data41, data42;
    reg [0:3]  cmd1, cmd2, cmd3, cmd4;
    begin
        putOnWire(inpWire1, data11, cmd1);
        putOnWire(inpWire2, data21, cmd2);
        putOnWire(inpWire3, data31, cmd3);
        putOnWire(inpWire4, data41, cmd4);
        #200;
        putOnWire(inpWire1, data12, 0);
        putOnWire(inpWire2, data22, 0);
        putOnWire(inpWire3, data32, 0);
        putOnWire(inpWire4, data42, 0);
    end
endtask


task print;
    input outFile, outString;

    reg[256*8:0] outString;
    integer outFile;

    begin
        $display("%0s", outString);
        $fwrite(file, "%0s\n", outString);
    end
endtask


always
    @ (reset or req1_cmd_in or req1_data_in or req2_cmd_in or req2_data_in or req3_cmd_in or req3_data_in or req4_cmd_in or req4_data_in, out_resp1, out_resp2, out_resp3, out_resp4, resp, resp_wire) begin

    end

    endmodule
