module DSP48A1_tb ();

reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
reg CLK,CARRYIN;
reg [7:0] OPMODE;
reg RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
reg CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;

wire [17:0] BCOUT;
wire [47:0] PCOUT,P;
wire [35:0] M;
wire CARRYOUT,CARRYOUTF;

DSP48A1 dut (A,B,D,C,
            CLK,CARRYIN,
            OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
            CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,
            PCIN,
            BCOUT,PCOUT,P,M,
            CARRYOUT,CARRYOUTF);

initial begin
    CLK = 0;
    forever 
        #1 CLK = ~CLK;
end

initial begin
    
    // 2.1. Verify Reset Operation
    RSTA = 1; RSTB = 1; RSTM = 1; RSTP = 1; RSTC = 1; RSTD = 1; RSTCARRYIN = 1; RSTOPMODE = 1; 

    repeat (5) begin
        A = $random; B = $random; D = $random; C = $random;
        BCIN = $random; PCIN = $random;
        CARRYIN = $random;
        OPMODE = $random;
        CEA = $random; CEB = $random; CEM = $random; CEP = $random; CEC = $random; CED = $random; CECARRYIN = $random; CEOPMODE = $random;
        
        @(negedge CLK);

        if (P!==0 || M!==0 || BCOUT!==0 || PCOUT!==0 || CARRYOUT!==0 || CARRYOUTF!==0) begin
            $display("Error in Reset");
            $stop;
        end
    end
    
    // 2.2. Verify DSP Path 1
    RSTA = 0; RSTB = 0; RSTM = 0; RSTP = 0; RSTC = 0; RSTD = 0; RSTCARRYIN = 0; RSTOPMODE = 0; 
    CEA = 1; CEB = 1; CEM = 1; CEP = 1; CEC = 1; CED = 1; CECARRYIN = 1; CEOPMODE = 1;
    A = 20; B = 10; D = 25; C = 350;
    OPMODE = 8'b11011101; 

    repeat (5) begin
        BCIN = $random; PCIN = $random;
        CARRYIN = $random;
        
        repeat (4) @(negedge CLK);

        if (P!=='h32 || M!=='h12c || BCOUT!=='hf || PCOUT!=='h32 || CARRYOUT!==0 || CARRYOUTF!==0) begin
            $display("Error in Path 1");
            $stop;
        end
    end
    
    // 2.3. Verify DSP Path 2
    OPMODE = 8'b00010000;

    repeat (5) begin
        BCIN = $random; PCIN = $random;
        CARRYIN = $random;
        
        repeat (3) @(negedge CLK);

        if (P!=='h0 || M!=='h2bc || BCOUT!=='h23 || PCOUT!=='h0 || CARRYOUT!==0 || CARRYOUTF!==0) begin
            $display("Error in Path 2");
            $stop;
        end
    end
    
    // 2.4. Verify DSP Path 3
    OPMODE = 8'b00001010;

    repeat (5) begin
        BCIN = $random; PCIN = $random;
        CARRYIN = $random;
        
        repeat (3) @(negedge CLK);

        if (P!==PCOUT || M!=='hc8 || BCOUT!=='ha || CARRYOUT!==CARRYOUTF) begin
            $display("Error in Path 3");
            $stop;
        end
    end
    
    // 2.5. Verify DSP Path 4
    A = 5; B = 6; D = 25; C = 350;
    PCIN = 3000;
    OPMODE = 8'b10100111;

    repeat (5) begin
        BCIN = $random;
        CARRYIN = $random;
        
        repeat (3) @(negedge CLK);

        if (P!=='hfe6fffec0bb1 || M!=='h1e || BCOUT!=='h6 || PCOUT!=='hfe6fffec0bb1 || CARRYOUT!== 1 || CARRYOUTF!==1) begin
            $display("Error in Path 4");
            $stop;
        end
    end
    $display("All Tests Passed");
    $stop;
end

endmodule