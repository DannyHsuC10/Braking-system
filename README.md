# 煞車系統

## [煞車力計算](Braking.md)
由重心轉移與煞車力量的關係，計算所需放大比例和balance bar。

## [踏板箱機構設計](Pedal_Sensor_Kinematic_Analysis.md)
分析踏板機構的線性程度，盡可能讓踏板成線性關係方便車手操作。

## [踏板機構運作](pedal_box/Mechanical_structure_animation.py)
用連桿座標位置產生機構動畫，看看實際上機構運作狀況。

***

## 通用 Markdown 更新工具

這個工具用於 **將 Excel 參數套用到 Markdown 範本**，並自動生成更新後的 `.md` 文件。

### 功能概述

1. **讀取 Excel 參數**
   - 從 Excel 檔案中讀取 `name` 與 `value` 欄位
   - 轉換為字典格式，方便後續替換

2. **渲染 Markdown 範本**
   - 將範本中的 `:::VAR:::` 變數替換為 Excel 中的對應值
   - 若範本中使用了未定義的變數，會拋出錯誤

3. **更新 Markdown 文件**
   - 將渲染後的內容輸出到指定路徑
   - 自動完成範本到正式文件的更新流程

### 注意事項
- Excel 必須包含 `name` 與 `value` 欄位
- Markdown 範本中的變數格式必須為 `:::變數名:::`
- 若範本中使用了未定義的變數，程式會拋出錯誤提示
