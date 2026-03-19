%% 煞車曲線
g=9.81;                 % 重力加速度 m/s^2
m=300*g;                % 車身質量 N
h_cog=0.28;             % 重心高度 m
wheelbase=1.55;         % 軸距 m
Rw=0.259;               % 輪胎半徑 m(可改用會隨正向負載改變形式)

index=1;                % 計數器
for i=0:0.1:1.5         % 縱向加速度變化
    a=i;                % 當前縱向加速度
    delta_m=(m*a*h_cog)/wheelbase;  % 計算重量轉移
    mf=(m/2)+delta_m;   % 當前前軸正向負載(假設重心在前後軸中間)
    mr=m-mf;            % 當前後軸正向負載
    tf=mf*i*Rw;         % 前軸軸上煞車力矩
    tr=mr*i*Rw;         % 後軸軸上煞車力矩
    tflog(index)=tf;    % 記錄前軸煞車力矩
    trlog(index)=tr;    % 記錄後軸煞車力矩
    index=index+1;      % 更新計數器
end

ag=0:0.1:1.5;           % 創建加速度數組
br=0.42                 % 設定的煞車比例(如果是前70%後30%，那就是0.3/0.7)
tff=linspace(0,1000,16);% 創建前軸煞車力矩變化
trr=tff.*br;            % 創建固定煞車比例的後軸煞車力矩變換
plot(ag,tflog)          % 繪製前軸扭矩隨加速度變化圖
grid on
plot(ag,trlog)          % 繪製後軸扭矩隨加速度變化圖
grid on
plot(tflog,trlog)       % 繪製前後軸扭矩關係圖(隨加速度變化)
hold on
plot(tff,trr)           % 繪製固定煞車比例的前後軸扭矩關係圖(隨加速度變化)
grid on
legend('最佳','固定比例',Location='southeast')
xlabel('front axis brake torque')
ylabel('rear axis brake torque')
axis equal
