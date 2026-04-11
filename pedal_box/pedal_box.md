# 踏板與感測器幾何運動數學說明
[pedal_box](pedal_box.m)
## 初始點座標
踏板力點：
$$
P_{force} = 
\begin{bmatrix}
r_{pedal} \cdot \sin(\theta_{pedal,i}) \\
r_{pedal} \cdot \cos(\theta_{pedal,i})
\end{bmatrix}
$$

感測器點：
$$
P_{sensor} = 
\begin{bmatrix}
r_{sensor} \cdot \sin(\theta_{sensor,i}) \\
r_{sensor} \cdot \cos(\theta_{sensor,i})
\end{bmatrix}
$$

---

## 旋轉運動
旋轉矩陣（繞 $z$ 軸）：
$$
R(\theta) = 
\begin{bmatrix}
\cos\theta & \sin\theta \\
-\sin\theta & \cos\theta
\end{bmatrix}
$$

旋轉後座標：
$$
P' = R(\theta) \cdot P
$$

---

## 感測器長度
感測器長度定義為感測器軸心與旋轉後感測器點的距離：
$$
L(\theta) = \sqrt{(x_{axis} - x_{sensor}(\theta))^2 + (y_{axis} - y_{sensor}(\theta))^2}
$$

其中 $(x_{axis}, y_{axis})$ 為感測器軸心座標。

---

## 變化量
感測器長度變化：
$$
\Delta L(\theta) = -\frac{d}{d\theta} L(\theta)
$$

踏板 $x$ 位移：
$$
\Delta x_{pedal}(\theta) = x_{pedal}(\theta) - x_{pedal}(0)
$$

---

## 模擬結果
程式透過迴圈計算不同角度下的：
- 踏板力點軌跡 $(x_{pedal}, y_{pedal})$
- 感測器點軌跡 $(x_{sensor}, y_{sensor})$
- 感測器長度 $L(\theta)$
- 感測器長度變化 $\Delta L(\theta)$
- 踏板位移 $\Delta x_{pedal}(\theta)$

---

## 圖形輸出
1. **機構運動圖**：顯示踏板與感測器的初始與最終位置。
2. **踏板角度 vs 感測器長度**：$L(\theta)$ 隨角度變化。
3. **踏板位移 vs 感測器長度**：$L(\theta)$ 與 $\Delta x_{pedal}$ 的關係。
4. **踏板角度 vs 感測器長度變化**：$\Delta L(\theta)$ 隨角度變化。
5. **踏板位移 vs 感測器長度變化**：$\Delta L(\theta)$ 與 $\Delta x_{pedal}$ 的關係。