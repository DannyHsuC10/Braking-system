from pathlib import Path
import pandas as pd
import re

# -----------------------------
# 讀取 Excel 參數
# -----------------------------
def load_params_from_excel(excel_path: Path) -> dict:
    if not excel_path.exists():
        raise FileNotFoundError(f"找不到 Excel 檔案：{excel_path}")

    df = pd.read_excel(excel_path)

    if "name" not in df.columns or "value" not in df.columns:
        raise ValueError("Excel 必須包含 'name' 與 'value' 欄位")

    return dict(zip(df["name"], df["value"]))


# -----------------------------
# 取代 :::VAR:::
# -----------------------------
def render_md_template(template_text: str, params: dict) -> str:
    pattern = r":::(.*?):::"

    def replace(match):
        key = match.group(1)
        if key not in params:
            raise KeyError(f"Markdown 中使用了未定義的變數：{key}")
        return str(params[key])

    return re.sub(pattern, replace, template_text)


# =========================
# 通用 md 更新工具
# =========================
def update_md(template_path: Path, excel_path: Path, output_path: Path):
    # 讀取參數
    params = load_params_from_excel(excel_path)

    # 讀取 md 範本
    template_text = template_path.read_text(encoding="utf-8")

    # 渲染
    rendered_text = render_md_template(template_text, params)

    # 輸出
    output_path.write_text(rendered_text, encoding="utf-8")
    print(f"{output_path.name} 已更新！")

# =========================
# 主程式範例 更新 Braking.md
# =========================
if __name__ == "__main__":
    base_dir = Path(__file__).parent
    upper_dir = Path(__file__).parent.parent

    template_path = base_dir / "Braking_template.md"
    excel_path    = base_dir / "brake_design_parameters.xlsx"
    output_path   = upper_dir / "Braking.md"

    # 呼叫通用工具更新 md
    update_md(template_path, excel_path, output_path)