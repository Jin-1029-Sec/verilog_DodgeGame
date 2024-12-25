## 💫遊戲與功能說明
1. ✅從頂端隨機位置掉落方塊(藍色與綠色)
2. ✅玩家控制底部方塊(紅色)左右移動進行躲閃
3. ✅被方塊砸中後會扣血(原始有9條命)
4. ✅會顯示目前存活的時長
5. ✅會顯示目前的血條
6. ✅遊戲結束或遊戲過程中可重新開始，重新開始後HP與時間重新計
7. ⬜遊戲暫停時，畫面顯示暫停符號，並且時間暫停，~~繼續後遊戲會恢復成暫停前~~
8. ✅死亡後(HP歸零)畫面會顯示OVER的畫面，並且停止計時
9. ⬜遊戲結束後會計算目前的分數，~~並將最終分數顯示於畫面~~
10. ⬜~~玩家觸碰到掉落物時蜂鳴器會叫~~

## 💫使用的元件與功能
| No. | 使用元件 | 功能 |
| :---: |:---:| :---|
| 1 |8x8 RGB LED 顯示器 | 顯示遊戲畫面 |
| 2 |七段顯示器          | 顯示存活時間 |
| 3 |LED               | 顯示目前剩餘血條|
| 4 |4 BITS SW    | 控制玩家左右移動|
| 5 |16 BITS DIPSW     | 重新開始、暫停、<br>8*8LED en(alway 1)|

## 💫Input、Output與Pin腳
#### Input
|No.| NAME | PIN | 備註 |
| :---: |:---:| :---: |:---: |
|1| clock | PIN_22 | FPGA內建clk|
|2| left  | PIN_79 |4 BITS SW IN1|
|3| right | PIN_80 |4 BITS SW IN2|
|4| Clear | PIN_111 |16 BITS DIPSW 1.st |
|5| pause | PIN_112 |16 BITS DIPSW 2.nd |
#### Output
|No.| NAME | PIN | 備註 |
| :---: |:---:| :---: |:---|
|1| A~G            | PIN_51 ~ PIN_55<br>PIN_58 ~ PIN_59                                |七段顯示器A~G|
|2| COM1、COM2     | PIN_72、PIN_73                                                   |七段顯示器COM|
|3| [0:7]b         | PIN_38 ~ PIN_39<br> PIN_42 ~ PIN_44<br> PIN_46<br>PIN_49 ~ PIN_50|LED燈前8顆|
|4| [2:0]S         | PIN_119 ~ PIN_121                                               | 8X8LED矩陣 S2~S0|
|5| [7:0]position_R| PIN_64 ~ PIN_71                                                  | 8X8LED矩陣 紅燈 |
|6| [7:0]position_G| PIN_135 ~ PIN_138<br>PIN_141 ~ PIN_144                          | 8X8LED矩陣 綠燈 |
|7| [7:0]position_B| PIN_124 ~ PIN_129<br>PIN_132 ~ PIN_133                          | 8X8LED矩陣 藍燈 |

![image](https://github.com/Jin-1029-Sec/verilog_DodgeGame/blob/main/%E8%AA%AA%E6%98%8Eimg/pin01.png)
![image](https://github.com/Jin-1029-Sec/verilog_DodgeGame/blob/main/%E8%AA%AA%E6%98%8Eimg/pin02.png)
## 💫實作影片

