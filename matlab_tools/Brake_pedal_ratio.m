clear
close all
clc
%% 定義變數
BrakePadelAxis=[0;0;1];                                                     %踏板旋轉軸點
MCAxis=[73;0;1];                                                            %MC 旋轉軸點
BrakePadelForcePoint = [220*sind(-15); 220*cosd(-15); 1];                   %腳踩在踏板上的點
BrakePadelMCPoint = [192.0666*sind(-3.84705); 192.06667*cosd(-3.84705); 1]; %MC接在踏板上的點

PedalPushTheta=14.74*pi/180;        %踏板旋轉角
MCLengthchange=[0,0,0];              %用來記錄等一下循環內需要的值，要初始化
%% 計算機構變化
ind=1;  %計數器
for i=0:0.01:1 %用比例下去算目前轉了幾%，極限就是PedalPushTheta=11.89*pi/180
    
    %目前轉了幾度
    PedalPushThetaNow=PedalPushTheta*i;

    % 創建旋轉矩陣(踩踏板時踏板轉動的角度)
    BrakePadelLocalation = [cos(PedalPushThetaNow) sin(PedalPushThetaNow) 0;
        -sin(PedalPushThetaNow) cos(PedalPushThetaNow) 0;
        0 0 1]; 

    %用旋轉矩陣去算出BrakePadelForcePoint旋轉時會跑去哪
    BrakePadelForcePointNow = BrakePadelLocalation * BrakePadelForcePoint;
    
    %用旋轉矩陣去算出BrakePadelMCPoint旋轉時會跑去哪
    BrakePadelMCPointNow = BrakePadelLocalation * BrakePadelMCPoint;

    %求當下MC的長度
    MClength = sqrt((MCAxis(1) - BrakePadelMCPointNow(1))^2 + (MCAxis(2) - BrakePadelMCPointNow(2))^2);

    MCLengthchange(ind,1)=PedalPushThetaNow*180/pi;         %紀錄轉角
    MCLengthchange(ind,2)=MClength;                         %紀錄MC長
    MCLengthchange(ind,3)=BrakePadelForcePointNow(1);       %紀錄施力點x軸的移動量

    BrakePadelMCPoint_x(ind,1)=BrakePadelMCPointNow(1);     %紀錄施力點x軸的移動量
    BrakePadelMCPoint_y(ind,1)=BrakePadelMCPointNow(2);     %紀錄施力點y軸的移動量

    BrakePadelForcePoint_x(ind,1)=BrakePadelForcePointNow(1);       %紀錄腳踩在踏板上的點x值
    BrakePadelForcePoint_y(ind,1)=BrakePadelForcePointNow(2);       %紀錄腳踩在踏板上的點y值
    ind=ind+1;  %更新計數器
end
%% 計算Pedal Ratio變化
ind=1;% 重置計數器
for i=1:101
    BrakePadelMCPoint_Now = [ BrakePadelMCPoint_x(i), BrakePadelMCPoint_y(i)];

    % 計算直線 MCAxis 的垂直距離到點 BrakePadelAxis 的公式
    numerator = abs((BrakePadelMCPoint_Now(2) - MCAxis(2)) * BrakePadelAxis(1) - (BrakePadelMCPoint_Now(1) - MCAxis(1)) * BrakePadelAxis(2) + BrakePadelMCPoint_Now(1) * MCAxis(2) - BrakePadelMCPoint_Now(2) * MCAxis(1));
    denominator = sqrt((BrakePadelMCPoint_Now(2) - MCAxis(2))^2 + (BrakePadelMCPoint_Now(1) - MCAxis(1))^2);

    % 距離計算
    distance = numerator / denominator;
    PedalRatio(ind,1)= BrakePadelForcePoint_y(i)/distance;
    ind=ind+1;
end
%% 畫圖
figure
plot(MCLengthchange(:,1),PedalRatio)
title('踏板轉角與PedalRatio變化關係')
xlabel('踏板轉角 deg')
ylabel('Pedal Ratio')

figure
plot(MCLengthchange(:,3)-MCLengthchange(1,3),PedalRatio)
title('施力點x軸位移與PedalRatio變化關係')
xlabel('施力點x軸位移 mm')
ylabel('Pedal Ratio')
