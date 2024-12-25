//----------控制物-------------------------------------------
module divfreq(input CLK, output reg CLK_div); 
	reg [24:0] Count; 
	always @(posedge CLK) 
		begin 
			if(Count > 7500000) 
				begin Count <= 25'b0; CLK_div <= ~CLK_div; end 
			else 
				Count <= Count + 1'b1; 	
		end 
endmodule 

//----------藍色掉落物------------------------------------
module divfreq2(input CLK, output reg CLK_div);
	reg [24:0] Count; 
	always @(posedge CLK) 
		begin 
			if(Count > 2500000) 
				begin 
					Count <= 25'b0; CLK_div <= ~CLK_div; 
				end 
			else 
				Count <= Count + 1'b1; 
		end 
endmodule 

//----------綠色掉落物--------------------------------------
module divfreq4(input CLK, output reg CLK_div); 
	reg [24:0] Count; 
	always @(posedge CLK) 
		begin 
			if(Count > 2000000) 
				begin Count <= 25'b0; CLK_div <= ~CLK_div; end 
			else 
				Count <= Count + 1'b1; 
		end 
endmodule 

//----------快速切換---------------------------------------------
module divfreq3(input CLK, output reg CLK_div); 
	reg [24:0] Count; 
	always @(posedge CLK) 
		begin 
			if(Count > 50000) 
				begin Count <= 25'b0; CLK_div <= ~CLK_div; end 
			else 
				Count <= Count + 1'b1; 
		end 
endmodule 


//-----------random_藍---------------------------------------
module divfreq5(input CLK, output reg CLK_div); 
	reg [24:0] Count; 
	always @(posedge CLK) 
		begin 
			if(Count > 123456) 
				begin Count <= 25'b0; CLK_div <= ~CLK_div; end 
			else 
				Count <= Count + 1'b1; 
		end 
endmodule 

//----------random_綠----------------------------------------
module divfreq6(input CLK, output reg CLK_div); 
	reg [24:0] Count; 
	always @(posedge CLK) 
		begin 
			if(Count > 654321) 
				begin Count <= 25'b0; CLK_div <= ~CLK_div; end 
			else 
				Count <= Count + 1'b1; 
		end
endmodule 



//---------計時器------------------------------------------
module divfreq7(input CLK, output reg CLK_div);
  reg [29:0] Count;
  always @(posedge CLK)
    begin
		if(Count > 55000000)
			begin	Count <= 30'b0; CLK_div <= ~CLK_div; end
		else
			Count <= Count + 1'b1;
    end
endmodule