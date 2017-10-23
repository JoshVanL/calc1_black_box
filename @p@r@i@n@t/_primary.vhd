library verilog;
use verilog.vl_types.all;
entity PRINT is
    port(
        outFile         : inout  integer;
        outString       : inout  vl_logic_vector(2048 downto 0)
    );
end PRINT;
