library verilog;
use verilog.vl_types.all;
entity TEST is
    port(
        exp             : in     vl_logic;
        exp_resp_wire   : in     vl_logic;
        exp_resp        : in     vl_logic;
        resp_wire       : in     vl_logic;
        resp            : in     vl_logic;
        out_data        : in     vl_logic;
        testNum         : in     vl_logic
    );
end TEST;
