clear
close all
clc
%% 低膨脹係數標準計算
cl=[1080,1380,2000];
pl=[6.9,10.3,20];
nl=polyfit(pl,cl,2);
pl_fit=0:0.1:20;
cl_fit=polyval(nl,pl_fit);
polyval(nl,5.67)
%% 畫圖
figure
plot(pl,cl)
hold on
plot(pl_fit,cl_fit)
title('低膨脹係數標準')
xlabel('油管內壓力 Mpa')
ylabel('膨脹係數 mm^3/m')

%% 高膨脹係數標準計算
ch=[2170,2590,4000];
ph=[6.9,10.3,20];
nh=polyfit(ph,ch,2);
ph_fit=0:0.1:20;
ch_fit=polyval(nh,ph_fit);
polyval(nh,5.67)
%% 畫圖
figure
plot(ph,ch)
hold on
plot(ph_fit,ch_fit)
title('高膨脹係數標準')
xlabel('油管內壓力 Mpa')
ylabel('膨脹係數 mm^3/m')
