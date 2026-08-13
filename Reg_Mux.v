module reg_mux (in,out,clk,en,rst);

parameter WIDTH = 18;
parameter REG = 0;
parameter RSTTYPE = "SYNC";

input clk,en,rst;
input [WIDTH-1:0] in;
output reg [WIDTH-1:0] out;

generate
    if (REG) begin
        if (RSTTYPE == "SYNC") begin
            always @(posedge clk) begin
                if (rst)
                    out <= 0;
                else if (en) begin
                    out <= in;
                end
            end
        end
        
        else if (RSTTYPE == "ASYNC") begin
            always @(posedge clk or posedge rst) begin
                if (rst)
                    out <= 0;
                else if (en) begin
                    out <= in;
                end
            end
        end
    end

    else begin
        always @(*) begin
                out = in;
        end
    end

endgenerate

endmodule