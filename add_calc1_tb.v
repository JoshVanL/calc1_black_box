`uselib lib=calc1_black_box

module add_calc1_tb;

wire [0:31]   out_data1, out_data2, out_data3, out_data4;
wire [0:1]    out_resp1, out_resp2, out_resp3, out_resp4;

reg 	         c_clk;
reg [0:3] 	 req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
reg [0:31]    req1_data_in, req2_data_in, req3_data_in, req4_data_in;
reg [1:7] 	 reset;

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

    // First drive reset. Driving bit 1 is enough to reset the design.

    reset[1] = 1;
    #800
    reset[1] = 0;

    // TEST 1: 1h + 1FF_FFFFh = 200_0000 ?

    #400

    req1_cmd_in = 1;
    req1_data_in = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
    req2_cmd_in = 0;
    req2_data_in = 0;
    req3_cmd_in = 0;
    req3_data_in = 0;
    req4_cmd_in = 0;
    req4_data_in = 0;

    #200

    req1_cmd_in = 0;
    req1_data_in = 32'b0001_1111_1111_1111_1111_1111_1111_1111;

    #200

    waitForResp1;
    test(out_data1, 32'b0010_0000_0000_0000_0000_0000_0000_0000, 1);

//    if ( out_data1 == 32'b0010_0000_0000_0000_0000_0000_0000_0000)
//        $display("\n Test 1 passed \n\n");
//    else
//        $display("\n Test 1 didn't passed \nexp: %d\nact: %d \n\n", 32'b0010_0000_0000_0000_0000_0000_0000_0000, out_data1);
//
    $display ("%t: r:%b \n 1c:%d,1d:%d \n 2c:%d,2d:%d \n 3c:%d,3d:%d \n 4c:%d,4d:%d \n 1r:%d,1d:%d \n 2r:%d,2d:%d \n 3r:%d,3d:%d \n 4r:%d,4d:%d \n\n", $time, reset[1], req1_cmd_in, req1_data_in, req2_cmd_in, req2_data_in, req3_cmd_in, req3_data_in, req4_cmd_in, req4_data_in, out_resp1, out_data1, out_resp2, out_data2, out_resp3, out_data3, out_resp4, out_data4);

    //$display("cmd in:\n1: %d\n2: %d\n3: %d\n4: %d\ndata in:\n1: %d\n2: %d\n3: %d\n4: %d\n\nresp out:\n1: %d\n2: %d\n3: %d\n4: %d\nout data:\n1: %d\n2: %d\n3: %d\n4: %d\n\n", req1_cmd_in, req2_cmd_in,req3_cmd_in,req4_cmd_in, req1_data_in, req2_data_in, req3_data_in, req4_data_in, out_resp1, out_data1, out_resp3, out_data2, out_resp3, out_data3, out_resp4, out_data4);

    $stop;

end // initial begin

always
    @ (reset or req1_cmd_in or req1_data_in or req2_cmd_in or req2_data_in or req3_cmd_in or req3_data_in or req4_cmd_in or req4_data_in) begin





    end

    task waitForResp1;
        fork : f
            begin
                #2000
                $display("%t : timeout", $time);
                disable f;
            end
            begin
                // Wait on signal
                @(posedge out_resp1);
                $display("%t : posedge signal", $time);
                disable f;
            end
        join
    endtask

    task test;
        input act, exp, n;
        if ( exp == act)
            $display("\n Test %d passed \n\n", n);
        else
            $display("\n Test %d didn't passed \nexp: %d\nact: %d \n\n", exp, act, n);

    endtask

endmodule // add_calc1_tb
