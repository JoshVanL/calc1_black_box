`uselib lib=calc1_black_box


module TEST(exp, exp_resp_wire, exp_resp, resp_wire, resp, out_data, testNum);

input exp;
input exp_resp_wire;
input exp_resp;
input resp_wire;
input resp;
input out_data;
input testNum;



//reg[0:31] exp;
//integer exp_resp_wire;
//reg[0:1] exp_resp;
//integer resp_wire;
//reg [0:1] resp;
//reg [0:31] out_data;

wire exp;
wire exp_resp_wire;
wire exp_resp;
wire resp_wire;
wire resp;
wire out_data;
wire testNum;

reg fail;
initial
begin
    $display("responce: %0d - out_data: %b", resp, out_data);
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

    if ( exp != out_data )
    begin
        $display("got unexpected result from operator. exp=%0d got=%0d", exp, out_data);
        fail = 1;
    end

    if ( fail == 1 )
    begin
        $display("Test %0d Failed.\n", testNum);
    end
    else
    begin
        $display("Test %0d Passed.\n", testNum);
    end

end
endmodule
