# Braking

>本文件展示如何簡單分析車上煞車結果。
文件中所有圖表與數據皆由 Python 模擬腳本 **自動生成**。

## 參數設定

* 車重 : $m = 284.5 \ \mathrm{kg}$
* 軸距 : $l = 1.571 \ \mathrm{m}$
* 重心到前後輪距離 : $l_f = 0.786 \ \mathrm{m},\; l_r = 0.786 \ \mathrm{m}$
* 重心高度 : $h_{cog} = 0.279 \ \mathrm{m}$
* 車輪半徑 : $r_w = 0.259 \ \mathrm{m}$

* 碟盤外徑 : $r_{disc_o} = 0.21 \ \mathrm{m}$
* 來令片與碟盤外徑距離 : $d_{gap} = 0.02 \ \mathrm{m}$
* 來令片摩擦係數 : $\mu_{pad} = 0.55$
* 車輪摩擦係數 : $\mu_w = 1.6$

* 前總泵直徑 : $D_{mc_f} = 0.012 \ \mathrm{m}$
* 後總泵直徑 : $D_{mc_r} = 0.014 \ \mathrm{m}$
* 前煞車卡鉗直徑 : $D_{caliper_f} = 0.034 \ \mathrm{m}$
* 後煞車卡鉗直徑 : $D_{caliper_r} = 0.034 \ \mathrm{m}$

* 車手出力 : $F_{driver} = 500.0 \ \mathrm{N}$
* Balance bar 比例 : $0.7$


## 力平衡

$$\sum F_y = 0$$

$$mg = N_{f}+N_{r}$$

$$\sum M = 0$$

$$l_fmg = lN_{f_s}$$

$$\Delta_m = mah_{cog}/l$$

$$N_f = N_{f_s}+\Delta_m = 2189.541$$

$$N_r = N_{r_s}+\Delta_m = 601.404$$

## 摩擦力

$$f = \mu N$$

$$F_{max} = ma_{max} = f_{f_{max}}+f_{r_{max}}$$

$$ma_{max} = \mu_w N = \mu_w mg$$

$$a_{max} = \mu_w g$$

$$f_{f_{max}} = \mu_wN_f = 3503.265$$

$$f_{r_{max}} = \mu_wN_r = 962.247$$

$$M_{a} = fr_w$$

$$M_{fw} = M_{fa}/2 = 453.673$$

$$M_{rw} = M_{ra}/2 = 124.611$$

## 計算煞車比

$$M_{fw}/(M_{fw}+M_{rw}) = 0.785$$

$$M_{rw}/(M_{fw}+M_{rw}) = 0.215$$

## 計算 Pedal ratio ( $PR$ )

$$r_{disc}  = r_{disc_o}/2-d_{gap}$$

$$M_{w} = r_{disc}F_{disc}$$

因為來令片左右兩側對夾所以摩擦力乘以2
$$F_{disc} = 2\mu_{pad}F_{caliper}$$

$$F_{caliper} = F_{disc}/(2\mu_{pad})$$

$$P = F_{caliper}/A_{caliper}$$

$$A = \pi (D/2)^2$$

計算完成後我們可以得出以下結果

| 輪胎 |  卡鉗面積:總泵面積   | 卡鉗活塞力 | 油管壓力 |
| ---- | :---: | :--------: | :--------: |
| 前輪 | 8.028    | 4852.116         | 5344208.889         |
| 後輪 | 8.028    | 1332.738     | 1467901.906     |

$$F_{mc} = PA_{mc}$$

$$PR = (F_{mc_f}+F_{mc_r})/F_{driver} = 1.661$$

## balance bar

### 前後軸煞車扭矩需求

用0~最大加速度和所需的前後煞車扭矩作圖，畫出兩條曲線，觀察前後煞車扭矩變化

![](brake_force/brake_torque_vs_deceleration.png)

### 煞車比例比較（Ideal vs Balance Bar）

並將0~最大加速度時前後的煞車比與選用的balance bar比例進行比較作圖，從此分析選用比例是否合適。

![](brake_force/brake_bias_comparison.png)
