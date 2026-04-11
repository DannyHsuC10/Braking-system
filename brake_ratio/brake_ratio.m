%% 理想前後煞車配比
% 前後軸因為煞車力量分配的比例計算

clc; clear; close all;
addpath('data');
load_data('data.csv')

%% ===== 車輛參數 =====

g = 9.81;         % m/s^2


Wf = rf * m * g;  % 前軸靜態載重
Wr = rr * m * g;  % 後軸靜態載重

%% ===== 減速度範圍 =====
a_g = linspace(0.1, mu, 10); % 單位 g
a = a_g * g;

%% ===== 計算 =====
Fb = m .* a;                  % 總煞車力
dW = m .* a .* h ./ L;        % 載重轉移

% 理想前後軸煞車力
Fbf = (Wf + dW) ./ (Wf + Wr) .* Fb;
Fbr = (Wr - dW) ./ (Wf + Wr) .* Fb;

%% ===== 作圖：Brake Force Diagram =====
figure; hold on; grid on;

% 理想煞車曲線
plot(Fbf, Fbr, 'b-', 'LineWidth', 2);

%% ===== 加上減速度標記 =====
for i = 1:length(a_g)
    text(Fbf(i), Fbr(i), sprintf('%.1fg', a_g(i)));
end

%% ===== 圖形設定 =====
xlabel('前軸煞車力 F_{bf} (N)');
ylabel('後軸煞車力 F_{br} (N)');
title('理想煞車曲線 + 煞車力分配 (Brake Force Diagram)');
%% 
% 線性回歸曲線，找出等效 balance bar

%% ===== 線性回歸（強制通過原點）=====
% 因為物理上 F=0 時應該通過原點，所以用無截距回歸

k = sum(Fbf .* Fbr) / sum(Fbf.^2);  % 最小平方解（through origin）

% 回歸線
Fbf_fit = linspace(0, max(Fbf), 100);
Fbr_fit = k * Fbf_fit;

% 畫出來
plot(Fbf_fit, Fbr_fit, 'r--', 'LineWidth', 2);

%% ===== 顯示結果 =====
bias_ratio = 1 / k;

bias_ratio_f = bias_ratio/(bias_ratio+1);

bias_ratio_r = 1/(bias_ratio+1);

fprintf('等效前後比例 Fbf:Fbr = %.1f : %.1f\n', bias_ratio_f,bias_ratio_r);

legend('理想煞車曲線','線性回歸 (等效 balance bar)');