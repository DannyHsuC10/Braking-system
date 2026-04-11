from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from md_updater import update_md

base_dir = Path(__file__).parent
# =========================================================(主要內容)
# 基本參數設定

g = 9.81

m = 284.5                # kg
l = 1.571                # m
l_f = 0.7855
l_r = 0.7855
h_cog = 0.279359
r_w = 0.259

r_disc_o = 0.21
d_gap = 0.02
mu_pad = 0.55
mu_w = 1.6

D_mc_f = 12e-3           # m
D_mc_r = 14e-3           # m
D_caliper_f = 34e-3
D_caliper_r = 34e-3

F_driver = 500           # N

balance_bar = 0.7        # 7:3

# =========================
# 最大減速度
a_max = mu_w * g

# 靜態正向力
Nf_static = m * g * l_r / l
Nr_static = m * g * l_f / l

Delta_m = m * a_max * h_cog / l

# 正向力
N_f = Nf_static + Delta_m
N_r = Nr_static - Delta_m
# =========================
# 最大摩擦力
f_f_max = mu_w * N_f
f_r_max = mu_w * N_r

# 軸上扭矩
M_fa = f_f_max * r_w
M_ra = f_r_max * r_w

# 單輪煞車扭矩
M_fw = M_fa / 2
M_rw = M_ra / 2

print(f"N_f = {N_f:.1f} N (front wheel)")
print(f"N_r = {N_r:.1f} N (rear wheel)")

print(f"f_f_max = {f_f_max:.1f} N (front wheel)")
print(f"f_r_max = {f_r_max:.1f} N (rear wheel)")

print(f"M_fw = {M_fw:.1f} Nm (front wheel)")
print(f"M_rw = {M_rw:.1f} Nm (rear wheel)")
# =========================
# 煞車比例
brake_ratio_f = (M_fw / (M_fw + M_rw))
brake_ratio_r = (M_rw / (M_fw + M_rw))

# Pedal Ratio 計算
# =========================
r_disc = r_disc_o / 2 - d_gap

# 碟盤力
F_disc_f = M_fw / r_disc
F_disc_r = M_rw / r_disc

# 卡鉗力
F_caliper_f = F_disc_f / (2 * mu_pad)
F_caliper_r = F_disc_r / (2 * mu_pad)

# 卡鉗面積
A_caliper_f = np.pi * (D_caliper_f / 2) ** 2
A_caliper_r = np.pi * (D_caliper_r / 2) ** 2

# 管路壓力
P_f = F_caliper_f / A_caliper_f
P_r = F_caliper_r / A_caliper_r

A_mc_f = np.pi * (D_mc_f / 2) ** 2
A_mc_r = np.pi * (D_mc_r / 2) ** 2

# 主缸力
F_mc_f = P_f * A_mc_f
F_mc_r = P_r * A_mc_r

# Pedal Ratio
PR = (F_mc_f + F_mc_r) / F_driver

# =========================
# 結果表格

A_ratio_f = A_caliper_f / A_mc_f
A_ratio_r = A_caliper_r / A_mc_r

table = pd.DataFrame({
    "Wheel": ["Front", "Rear"],
    "Caliper Area / MC Area": [
        A_ratio_f,
        A_ratio_r
    ],
    "Caliper Force [N]": [
        F_caliper_f,
        F_caliper_r
    ],
    "Line Pressure [Pa]": [
        P_f,
        P_r
    ]
})

print(table)
print(f"\nPedal Ratio PR = {PR:.2f}")

# =========================
# 不同減速度下的煞車扭矩需求計算

a_array = np.linspace(0.01, a_max, 200)

def brake_torque_vsacceleration(a_array):
    M_f_list = []
    M_r_list = []

    for a in a_array:
        Delta_m = m * a * h_cog / l

        N_f = m * g / 2 + Delta_m
        N_r = m * g / 2 - Delta_m

        # 等效摩擦係數 = a/g
        F_f = N_f * (a / g)
        F_r = N_r * (a / g)

        M_f = F_f * r_w
        M_r = F_r * r_w

        M_f_list.append(M_f)
        M_r_list.append(M_r)
    return M_f_list, M_r_list

M_f_list, M_r_list = brake_torque_vsacceleration(a_array)

# 作圖
# =========================
plt.figure()# plot brake torque vs deceleration
plt.plot(a_array, M_f_list, label="Front axle torque (demand)")
plt.plot(a_array, M_r_list, label="Rear axle torque (demand)")
plt.xlabel("Deceleration a [m/s²]")
plt.ylabel("Brake Torque [Nm]")
plt.legend()
plt.grid()

fig1_path = base_dir / "brake_torque_vs_deceleration.png"
plt.savefig(fig1_path, dpi=300, bbox_inches="tight")

plt.show()

M_f_real_list = [(a + b)*balance_bar for a, b in zip(M_f_list, M_r_list)]
M_r_real_list = [(a + b)*(1 - balance_bar) for a, b in zip(M_f_list, M_r_list)]

plt.figure()# plot brake torque ratio
plt.plot(M_f_list, M_r_list, label="Ideal brake torque distribution")
plt.plot(M_f_real_list, M_r_real_list, label="Set brake torque distribution", linestyle='--')
plt.xlabel("Front axle torque [Nm]")
plt.ylabel("Rear axle torque [Nm]")
plt.legend()
plt.grid()

fig2_path = base_dir / "brake_bias_comparison.png"
plt.savefig(fig2_path, dpi=300, bbox_inches="tight")

plt.show()

# ==========================================================================(資料庫)
# 匯出設計參數到 Excel
param_table = pd.DataFrame([

    # 基本參數設定
    ["車重", "m", m],
    ["軸距", "l", l],
    ["前軸距", "l_f", l_f],
    ["後軸距", "l_r", l_r],
    ["重心高度", "h_cog", h_cog],
    ["車輪半徑", "r_w", r_w],

    ["碟盤外徑", "r_disc_o", r_disc_o],
    ["來令片間隙", "d_gap", d_gap],
    ["來令片摩擦係數", "mu_pad", mu_pad],
    ["輪胎摩擦係數", "mu_w", mu_w],

    ["前總泵直徑", "D_mc_f", D_mc_f],
    ["後總泵直徑", "D_mc_r", D_mc_r],
    ["前卡鉗直徑", "D_caliper_f", D_caliper_f],
    ["後卡鉗直徑", "D_caliper_r", D_caliper_r],

    ["車手施力", "F_driver", F_driver],
    ["Balance bar 比例", "balance_bar", balance_bar],

    # 計算結果
    ["前輪正向力", "N_f", N_f],
    ["後輪正向力", "N_r", N_r],

    ["前輪最大摩擦力", "f_f_max", f_f_max],
    ["後輪最大摩擦力", "f_r_max", f_r_max],

    ["前面積比", "A_ratio_f", A_ratio_f],
    ["後面積比", "A_ratio_r", A_ratio_r],

    ["前輪單輪煞車扭矩", "M_fw", M_fw],
    ["後輪單輪煞車扭矩", "M_rw", M_rw],

    ["前煞車比例", "brake_ratio_f", brake_ratio_f],
    ["後煞車比例", "brake_ratio_r", brake_ratio_r],

    ["前卡鉗力", "F_caliper_f", F_caliper_f],
    ["後卡鉗力", "F_caliper_r", F_caliper_r],

    ["前管路壓力", "P_f", P_f],
    ["後管路壓力", "P_r", P_r],

    ["Pedal Ratio", "PR", PR],

], columns=["content", "name", "value"])

# 對數值四捨五入到小數點第3位
param_table["value"] = param_table["value"].round(3)

excel_path = base_dir / "brake_design_parameters.xlsx"

param_table.to_excel(excel_path, index=False)

# 產生md
template_path = base_dir / "Braking_template.md"
excel_path    = base_dir / "brake_design_parameters.xlsx"
output_path   = base_dir / "Braking.md"

update_md(template_path, excel_path, output_path)