module final_01(
	output reg [7:0]position_R, position_B, position_G, 
	output reg [2:0]S,
	//output reg touch, 				//是否碰到	(蜂鳴器)
	output reg A,B,C,D,E,F,G,		//計時器		(七段顯示器)
	output reg [7:0]b,				//血條  		(LED)
	output reg COM1,COM2,			//個位,十位	(七段顯示器)
	input CLK, Clear, pause, right, left 
	);
	
	wire [7:0]p1;					//控制物(red)位置y
	wire [2:0]S1;					//x
	wire [7:0]p2;					//綠色掉落位置y
	wire [2:0]S2;					//x
	wire [7:0]p3;					//藍色掉落位置y
	wire [2:0]S3;					//x
	reg [1:0] count;				//沒GG時(控制物、藍綠掉落物輪流SHOW)
	reg [3:0] count2;				//GAME_OVER(8*8顯示器 8列圖案選擇)
   reg [3:0] ti;					//有幾個已達底部的掉落物
   reg [3:0] s;
   reg touch;
	//reg x;
	reg [4:0] hp;					//血條
	reg [3:0] A_count,B_count;	//個位,十位數字
	reg [0:3] a;					//計時器數字tmp
	reg COM;							//七段個位十位切換
	
	divfreq  C1(CLK, CLK_div);		 //控制物(red)
	divfreq2 C2(CLK, CLK_div2);	 //藍色掉落
	divfreq3 C3(CLK, CLK_div3);	 //快速切換
	divfreq4 C4(CLK, CLK_div4);	 //綠色掉落
	divfreq5 C5(CLK, CLK_div5);	 //藍_速度
	divfreq6 C6(CLK, CLK_div6);	 //綠_速度
	//divfreq7 C7(CLK, CLK_div7);	 
	//divfreq8 C8(CLK, CLK_div8);	 
	divfreq9 C9(CLK, CLK_div9); 	 //計時器
	
	moveobject M1(CLK_div, Clear, right, left, p1, S1);
   fallingobject  F1(CLK_div2, CLK_div5, Clear, touch, p2, S2, get1);
	fallingobject2 F2(CLK_div4, CLK_div6, Clear, p3, S3, get2);

   initial 
	begin
		touch = 0;
		b = 8'b11111111; //血條LED顯示狀態
		s=0;
		//x=1;
	end
	
//----------計時器--------------------------------------------------------
//**********補充：'b二進，1'd十進，'h十六進*********************************
	always @(posedge CLK_div9, posedge Clear)
		begin 
			if(Clear) 	
				begin
					A_count <= 4'b0000;
					B_count <= 4'b0000;
				end
			else if (pause)
				begin
					A_count<=A_count;
					B_count<=B_count;
				end
			else if(hp<9)	//如果還活著的話
				begin
					if(A_count<4'b1001) 	//小於9［A(個位)+1］
						A_count <= A_count + 1'd1; 
					else		//個位數大於9進位［A(個位)清0，B(十位)+1］
						begin
							A_count<=4'b0000;
							B_count<=B_count+1'd1;
						end
				end
		end
		
//視覺暫留，七段顯示兩位不同數字
	always@(posedge CLK_div3)
   begin
	   COM<=~COM;	//0->1->0...切換
		if(COM) //顯示個位數
			begin
				a[0:3]<=A_count;
				COM1<=1; COM2<=0;
			end
		else	 //顯示十位數
			begin
				a[0:3]<=B_count;
				COM1<=0; COM2<=1;
			end
			//--------轉7seg
		    A = ~(a[0]&~a[1]&~a[2] | ~a[0]&a[2] | ~a[1]&~a[2]&~a[3] | ~a[0]&a[1]&a[3]);
	       B = ~(~a[0]&~a[1] | ~a[1]&~a[2] | ~a[0]&~a[2]&~a[3] | ~a[0]&a[2]&a[3]);
			 C = ~(~a[0]&a[1] | ~a[1]&~a[2] | ~a[0]&a[3]);
			 D = ~(a[0]&~a[1]&~a[2] | ~a[0]&~a[1]&a[2] | ~a[0]&a[2]&~a[3] | ~a[0]&a[1]&~a[2]&a[3] | ~a[1]&~a[2]&~a[3]);
			 E = ~(~a[1]&~a[2]&~a[3] | ~a[0]&a[2]&~a[3]);
			 F = ~(~a[0]&a[1]&~a[2] | ~a[0]&a[1]&~a[3] | a[0]&~a[1]&~a[2] | ~a[1]&~a[2]&~a[3]);
			 G = ~(a[0]&~a[1]&~a[2] | ~a[0]&~a[1]&a[2] | ~a[0]&a[1]&~a[2] | ~a[0]&a[2]&~a[3]);
   end
	
//------------------------------------------------------------------------------------------------------------------
//-----------碰到掉落物(扣血)-----------------------------------------------------------------------------------------
	always@(posedge touch,posedge Clear)
		begin
		   if(Clear)
				hp <= 0;
		   else if(hp<=9)
				hp <= hp+1;
		end
		
//-----------血條顯示-----------------------------------------------------------------------------------------------
//-----------控制物與掉落物快速切換顯示-------------------------------------------------------------------------------
	always@(posedge CLK_div3,posedge Clear)
	begin
	//--8*8 LED(控制物、藍綠掉落物輪流快速SHOW)---------------------------------
	   if(Clear)
			begin
				count <= count+1;
				b<=8'b11111111;
				if(count>2)
					count<=0;
				if(count==0) 		//控制物
					begin
						position_R<=p1;
						position_G<=8'b11111111;
						position_B<=8'b11111111;
						S<=S1;	
					end
				else if(count==1)	//掉落物_藍
					begin
						position_R<=8'b11111111;
						position_G<=8'b11111111;
						position_B<=~p2;
						S<=S2;
						if(get1)
							s<= s+1;
						
					end
				else if(count==2)	//掉落物_綠
					 begin
						position_R<=8'b11111111;
						position_B<=8'b11111111;
						position_G<=~p3;
						S<=S3;
						if(get2)
							s<=s+1;
					 end			
			end
	//--暫停--------------------------------------------------------
		else if(pause)
			begin
				count2 <= count2+1;
				b<=8'b00000000;
				if(count2>7)
					count2<=0;
				if(count2==2)
					begin
						position_B<=8'b00000000;
						S<=2;
					end
				else if(count2==4)
					begin
						position_B<=8'b00000000;
						S<=4;
					end
			end	
		
	//--8*8 LED(控制物、藍綠掉落物輪流快速SHOW)-----------------------------------------
		else if(hp<9)
			begin
				count <= count+1;
				if(count>2)
					count<=0;
				if(count==0)
					begin
						position_R<=p1;
						position_G<=8'b11111111;
						position_B<=8'b11111111;
						S<=S1;		
					end
				else if(count==1)
					begin
						position_R<=8'b11111111;
						position_G<=8'b11111111;
						position_B<=~p2;
						S<=S2;
						if(get1)
							s<= s+1;	
					end
				else if(count==2)
					 begin
						position_R<=8'b11111111;
						position_B<=8'b11111111;
						position_G<=~p3;
						S<=S3;
						if(get2)
							s<=s+1;
					 end
			//
				if(((p1==((~p2)+2'b11))&&(S1==S2))||((p1==((~p3)-1'b1))&&(S1==S3)))
					touch <=1;
				else
					touch <=0;
			//--計算有幾個已達底部的掉落物-------------------------------------------
				if(get1)
					ti<=ti+1;
				if(get2)
					ti<=ti+1;
			//--hp顯示-------------------------------------------------------------
				if(hp==0)
					b<=8'b11111111;
				else if(hp==1)
					b<=8'b11111110;
				else if(hp==2)
					b<=8'b11111100;
				else if(hp==3)
					b<=8'b11111000;
				else if(hp==4)
					b<=8'b11110000;
				else if(hp==5)
					b<=8'b11100000;
				else if(hp==6)
					b<=8'b11000000;
				else if(hp==7)
					b<=8'b10000000;
				else if(hp==8)
					b<=8'b00000000;
			end
			
	//---GAME OVER---------------------------------------------------------
	//***8*8 led 顯示切換，視覺暫留不同顏色&形狀(8列000~111)
		else if(hp >= 9)
			begin
				count2 <= count2+1;
				b<=8'b00000000;
				if(count2>7)
					count2<=0;
				if(count2==0)
					begin
						position_R<=8'b00011111;
						position_G<=8'b11100000;
						position_B<=8'b11111111;
						S<=0;
					end
				else if(count2==1)
					begin
						position_R<=8'b01011111;
						position_G<=8'b11101010;
						position_B<=8'b11111111;
						S<=1;
						
					end
				else if(count2==2)
					begin
						position_R<=8'b01011111;
						position_G<=8'b11101010;
						position_B<=8'b11111111;
						S<=2;
					end
				else if(count2==3)
					begin
						position_R<=8'b00011111;
						position_G<=8'b11101010;
						position_B<=8'b11111111;
						S<=3;
					end
				else if(count2==4)
					begin
						position_R<=8'b11100000;
						position_G<=8'b11111111;
						position_B<=8'b00100000;
						S<=4;
					end
				else if(count2==5)
					begin
						position_R<=8'b11101011;
						position_G<=8'b11111111;
						position_B<=8'b11001011;
						S<=5;
					end
				else if(count2==6)
					begin
						position_R<=8'b11101001;
						position_G<=8'b11111111;
						position_B<=8'b11001001;
						S<=6;
					end
				else if(count2==7)
					begin
						position_R<=8'b11110110;
						position_G<=8'b11111111;
						position_B<=8'b00110110;
						S<=7;
					end	
			end	
	end
endmodule

//---------控制物移動---------------------------------------------------------------------------------
module moveobject(
	input CLK_div, Clear, right, left, 
	output reg [7:0]position, 
	output reg [2:0]S
	); 
	always@(posedge CLK_div, posedge Clear)
		begin
			if(Clear)	
				begin
					S<=4;
					position<=~(8'b00000011);
				end
			else if(left)	//往左移
				begin
					if(S==0)	//如果已經在最左邊，則維持不動
						begin
							S<=S;
							position<=~(8'b00000011);
						end
					else		//否則目前位置-1
						begin
							S<=S-1;
							position<=~(8'b00000011);
						end
				end
			else if(right) //往右移
				begin
					if(S==7)	//如果已經在最右邊，則維持不動
						begin
							S<=S;
							position<=~(8'b00000011);
						end
					else		//否則目前位置+1
						begin
							S<=S+1;
							position<=~(8'b00000011);
						end
				end
		end
endmodule

//-----------------------------------------------------------------------------------------------------------------------------
//-----------藍掉落物從上而下隨機掉落--------------------------------------------------------------------------------------------
module fallingobject(
	input CLK_div2, CLK_div5,touch,Clear, 
	output reg [7:0]position_B,
	output reg [2:0]SS,
	output reg get
	);
	reg[24:0]cnt;
   reg restart;

	always @(posedge CLK_div5) 
		begin
			if(cnt > 250000)
				cnt <= 25'd0; 		
			else
		     cnt <= cnt + 1'b1;
		end
	initial
		begin
			position_B = 8'b11000000;
			SS =cnt%8;
			restart = 0;
			get=0;	//還沒到底部
		end	
	always @(posedge CLK_div2)
		begin
			
				if(restart)	//上一個掉到底部後，更新x丟新的
					begin
						position_B <= 8'b11000000;	
						SS <=cnt%8;		//x
						restart = 0;
					end
			   else			//否則繼續往下移動一格，直到掉到底部
					begin
						position_B = position_B >> 1;
						if(position_B == 8'b00000000)
						begin
							restart = 1;
							get =1; //已達底部
						end
					end
				
		end

endmodule

//-----------------------------------------------------------------------------------------------------------------------------
//------------綠掉落物從上而下隨機掉落--------------------------------------------------------------------------------------------
module fallingobject2(
	input CLK_div4, CLK_div6, Clear,
	output reg [7:0]position_G,
	output reg [2:0]SS,
	output reg get
	);
	reg[24:0]cnt;
	reg restart;
	always @(posedge CLK_div6) 
		begin
			if(cnt > 250000)
				cnt <= 25'd0; 		
			else
				cnt <= cnt + 1'b1;	  
		end 	
		
	initial 					//set 起始addr
		begin
			position_G = 8'b10000000;
			SS = cnt%8; 	//x
			restart = 0;
			get=0;
		end		
	always @(posedge CLK_div4)
		begin
			if(restart) //上一個掉到底部後，更新x丟新的
				begin
					position_G <= 8'b10000000;	
					SS <=cnt%8;
					restart = 0;
				end
			else 			//否則繼續往下移動一格，直到掉到底部
				begin	
					position_G = position_G >> 1;
					if(position_G == 8'b00000000)
						begin restart = 1; get = 1; end
				end
		end	
endmodule