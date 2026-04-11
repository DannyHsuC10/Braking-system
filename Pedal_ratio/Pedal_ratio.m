%% 煞車放大比與力量計算

clc; clear; close all;
addpath('data');
load_data('data.csv')
g = 9.81;
function [M_f_list, M_r_list] = brake_torque_vsacceleration(a_array, m, g, h_cog, l, r_w)

M_f_list = zeros(size(a_array));
M_r_list = zeros(size(a_array));

for i = 1:length(a_array)
    a = a_array(i);

    Delta_m = m * a * h_cog / l;

    N_f = m * g / 2 + Delta_m;
    N_r = m * g / 2 - Delta_m;

    % 等效摩擦係數 = a/g
    F_f = N_f * (a / g);
    F_r = N_r * (a / g);

    M_f_list(i) = F_f * r_w;
    M_r_list(i) = F_r * r_w;
end

end

%% =========================
% 最大減速度
a_max = mu_w * g;

% 靜態正向力
Nf_static = m * g * rr;
Nr_static = m * g * rf;

Delta_m = m * a_max * h / L;

% 正向力
N_f = Nf_static + Delta_m;
N_r = Nr_static - Delta_m;

%% =========================
% 最大摩擦力
f_f_max = mu_w * N_f;
f_r_max = mu_w * N_r;

% 軸上扭矩
M_fa = f_f_max * r_w;
M_ra = f_r_max * r_w;

% 單輪煞車扭矩
M_fw = M_fa / 2;
M_rw = M_ra / 2;

fprintf("N_f = %.1f N (front wheel)\n", N_f);
fprintf("N_r = %.1f N (rear wheel)\n", N_r);

fprintf("f_f_max = %.1f N (front wheel)\n", f_f_max);
fprintf("f_r_max = %.1f N (rear wheel)\n", f_r_max);

fprintf("M_fw = %.1f Nm (front wheel)\n", M_fw);
fprintf("M_rw = %.1f Nm (rear wheel)\n", M_rw);

%% =========================
% 煞車比例
brake_ratio_f = M_fw / (M_fw + M_rw);
brake_ratio_r = M_rw / (M_fw + M_rw);

%% =========================
% Pedal Ratio 計算

r_disc = r_disc_o / 2 - d_gap;

% 碟盤力
F_disc_f = M_fw / r_disc;
F_disc_r = M_rw / r_disc;

% 卡鉗力
F_caliper_f = F_disc_f / (2 * mu_pad);
F_caliper_r = F_disc_r / (2 * mu_pad);

% 卡鉗面積
A_caliper_f = pi * (D_caliper_f / 2)^2;
A_caliper_r = pi * (D_caliper_r / 2)^2;

% 管路壓力
P_f = F_caliper_f / A_caliper_f;
P_r = F_caliper_r / A_caliper_r;

% 主缸面積
A_mc_f = pi * (D_mc_f / 2)^2;
A_mc_r = pi * (D_mc_r / 2)^2;

% 主缸力
F_mc_f = P_f * A_mc_f;
F_mc_r = P_r * A_mc_r;

% Pedal Ratio
PR = (F_mc_f + F_mc_r) / F_driver;

%% =========================
% 結果表格

A_ratio_f = A_caliper_f / A_mc_f;
A_ratio_r = A_caliper_r / A_mc_r;

Wheel = ["Front"; "Rear"];
AreaRatio = [A_ratio_f; A_ratio_r];
CaliperForce = [F_caliper_f; F_caliper_r];
LinePressure = [P_f; P_r];

T = table(Wheel, AreaRatio, CaliperForce, LinePressure);
disp(T);

fprintf("\nPedal Ratio PR = %.2f\n", PR);

%% =========================
% 不同減速度下的煞車扭矩需求

a_array = linspace(0.01, a_max, 200);

[M_f_list, M_r_list] = brake_torque_vsacceleration(a_array, m, g, h, L, r_w);

%% =========================
% 作圖：Torque vs deceleration
figure;
plot(a_array, M_f_list, 'DisplayName', 'Front axle torque (demand)');
hold on;
plot(a_array, M_r_list, 'DisplayName', 'Rear axle torque (demand)');
xlabel("Deceleration a [m/s^2]");
ylabel("Brake Torque [Nm]");
legend;
grid on;

%% =========================
% 煞車分配比較

M_f_real_list = (M_f_list + M_r_list) * balance_bar;
M_r_real_list = (M_f_list + M_r_list) * (1 - balance_bar);

figure;
plot(M_f_list, M_r_list, 'DisplayName', 'Ideal brake torque distribution');
hold on;
plot(M_f_real_list, M_r_real_list, '--', 'DisplayName', 'Set brake torque distribution');
xlabel("Front axle torque [Nm]");
ylabel("Rear axle torque [Nm]");
legend;
grid on;
