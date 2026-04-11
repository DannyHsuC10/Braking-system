# 理想前後煞車配比
[brake_ratio](brake_ratio.m)
## 程式目的
此程式用於計算並繪製車輛在不同減速度下的**理想前後煞車力分配**，並透過線性回歸找出等效的煞車比例桿。

## 減速度範圍
程式設定減速度範圍為：
$$a_g = \text{linspace}(0.1, \mu, 10)$$
其中 $a = a_g \cdot g$

---

## 煞車力計算
總煞車力：
$$F_b = m \cdot a$$

載重轉移：
$$\Delta W = \frac{m \cdot a \cdot h}{L}$$

前後軸理想煞車力：
$$F_{bf} = \frac{W_f + \Delta W}{W_f + W_r} \cdot F_b$$
$$F_{br} = \frac{W_r - \Delta W}{W_f + W_r} \cdot F_b$$

---

## 作圖：Brake Force Diagram
程式繪製 $F_{bf}$ 與 $F_{br}$ 的關係曲線，並在圖上標記不同減速度 $a_g$ 的位置。

- $x$ 軸：前軸煞車力 $F_{bf}$
- $y$ 軸：後軸煞車力 $F_{br}$

---

## 線性回
由於物理上 $F=0$ 時必須通過原點，因此採用無截距回歸：

回歸斜率：
$$k = \frac{\sum (F_{bf} \cdot F_{br})}{\sum (F_{bf}^2)}$$

回歸線：
$$F_{br} = k \cdot F_{bf}$$

---

## 等效前後比例
由回歸斜率 $k$ 可得等效比例：

$$\text{bias ratio} = \frac{1}{k}$$

前軸比例：
$$\text{bias}_{f} = \frac{\text{bias ratio}}{\text{bias ratio} + 1}$$

後軸比例：
$$\text{bias}_{r} = \frac{1}{\text{bias ratio} + 1}$$

輸出結果：
```
等效前後比例 Fbf:Fbr = x : y
```

---

## 圖例
- **藍線**：理想煞車曲線  
- **紅虛線**：線性回歸

