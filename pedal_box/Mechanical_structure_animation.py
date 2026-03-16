from vpython import *
import numpy as np

# 工具
def rotate(point, center, theta):
    R = np.array([
        [np.cos(theta), -np.sin(theta), 0],
        [np.sin(theta),  np.cos(theta), 0],
        [0,              0,             1]])
    return center + R @ (point - center)

# =========================(場景設定)
scene = canvas(title="Triangular Pedal with Linear Sensor",
               width=900, height=600,
               center=vector(0,120,0),
               background=color.white)

# =========================(幾何定義)
P0 = np.array([0, 0, 0])          # 踏板旋轉中心
P1_0 = np.array([0, 220, 0])      # 腳踩點
P2_0 = np.array([60, 160, 0])     # Sensor 接點

sensor_base = np.array([80, 40, 0])

# =========================(視覺物件)
pivot = sphere(pos=vector(*P0), radius=6, color=color.black)

pedal_01 = cylinder(radius=4, color=color.blue)
pedal_12 = cylinder(radius=4, color=color.blue)
pedal_20 = cylinder(radius=4, color=color.blue)

foot_point = sphere(radius=6, color=color.red)
sensor_tip = sphere(radius=5, color=color.green)

sensor_base_vis = sphere(pos=vector(*sensor_base), radius=5, color=color.black)
sensor_rod = cylinder(radius=3, color=color.green)

# =========================(動畫)
theta = np.deg2rad(0)
theta_max = np.deg2rad(12)

while True:
    rate(30)

    theta += np.deg2rad(0.25)
    if theta > theta_max:
        theta = 0

    # 旋轉踏板三角形
    P1 = rotate(P1_0, P0, -theta)
    P2 = rotate(P2_0, P0, -theta)

    # 更新踏板邊
    pedal_01.pos = vector(*P0)
    pedal_01.axis = vector(*(P1 - P0))

    pedal_12.pos = vector(*P1)
    pedal_12.axis = vector(*(P2 - P1))

    pedal_20.pos = vector(*P2)
    pedal_20.axis = vector(*(P0 - P2))

    # 腳踩點
    foot_point.pos = vector(*P1)

    # Sensor
    sensor_vec = P2 - sensor_base
    sensor_rod.pos = vector(*sensor_base)
    sensor_rod.axis = vector(*sensor_vec)
    sensor_tip.pos = vector(*P2)