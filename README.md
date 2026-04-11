# 煞車計算
只要確定參數之後打入data裡面的csv(excel表格)即可使用matlab計算。
## 1. [前後煞車比評估](brake_ratio/braking_curve.md)
* 需求:車重、車輪x摩擦、軸距

首先初步進行車輛前後煞車比評估，確定理想煞車曲線與極限煞車力。
## 2. [踏板比計算](Pedal_ratio/Pedal_ratio.md)
* 需求:輪端架構

接下來需要配合輪端，決定卡前與碟盤size。除了注意裝配受力，碟盤需要注意一下轉動慣量。
$$I = m(r_i+r_o)^2/4$$
另外根據帕斯卡前後MC與卡鉗活塞面積的比(也就是煞車比)需要盡量與前後煞車比接近，並且盡量放大煞車力。
$$\frac{A_{fcaliper}/A_{fmc}}{A_{rcaliper}/A_{rmc}} = \frac{F_f}{F_r}$$
然後就可以把參數整理好進行踏板比計算[踏板比計算](Pedal_ratio/Pedal_ratio.md)
## 3. [煞車機構確認](pedal_box/pedal_box.md)
建立機構草稿時我們需要先用工具探段，判斷機構運作合不合理。


如果想要看看實際運作可以用以下工具[機構運作](pedal_box/Mechanical_structure_animation.py)，不過其實也可以用cad達成。
## 4. [油管實驗](Brake_hydraulic_pressure/Brake_hydraulic_pressure.md)
* 需求:煞車機構與油管

如果有時間可以進行一下油管實驗，確定油管膨脹的影響。這會造成煞車力量被膨脹吃掉。如果要實驗記得自行改matlab參數。

## [煞車設計報告](md_updater/Braking.md)
可用於產生md檔案報告，主動式的md更新工具，可以搭配其他模組使用