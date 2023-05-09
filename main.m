%coding=<GB 2312>
clear;
clc;close all;

theta=1.4;  %快跑阈值设为1.08,其他设为1.4
%%%%%%%%%%%% 1.初步处理 %%%%%%%%%%%%%%%

%提取三轴数据,并分别保存到x,y,z中, 除以4096后得到的就是重力加速度g的倍数
%且文件中的数据是走100步的数据
A=load("跑步机快跑.txt");
len_A=length(A);
A_x=A(:,1)/4096;   A_y=A(:,2)/4096;  A_z=A(:,3)/4096;

%加速度计的采样频率为100Hz,采样点数为length(A_x),因此总时间如下
Time=length(A_x)/100;

X_Abscissa=linspace(0,Time,length(A_x)); %绘制 时域图的横坐标
X_Abscissa_f=linspace(0,2*pi,length(A_x));



Acc=sqrt(A_x.^2+A_y.^2+A_z.^2);      %加速度的模长
%Acc=Acc-1; 若这里改了,则theta也该减1



S=delete_zero(Acc,80,theta);      %若加速度序列中, 有超过连续80(0.8秒)个点小于1.2个重力加速度,则删除
Time_D=length(S{1})/100;        %删除掉无效长度后对应的时间长度

X_Abscissa_D=linspace(0,Time_D,length(S{1}));     %绘制 删除掉无效长度后 时域图的横坐标
X_Abscissa_f_D=linspace(0,2*pi,length(S{1}));     %绘制 删除掉无效长度后 频域图的横坐标


figure;  %绘制三周加速度计的原始数据图
    plot(X_Abscissa,A_x,  X_Abscissa,A_y,  X_Abscissa,A_z);
    axis([0,Time,min([A_x;A_y;A_z])-1,max([A_x;A_y;A_z])+1]);
    title("");
    xlabel("time(s)");
    ylabel("加速度\times9.8 m/s^2");
    

figure;  %绘制总加速度
    plot(X_Abscissa,Acc);
    axis([0,Time,0,max([A_x;A_y;A_z])+1]);
    title("总加速度\times9.8m/s^2");
    xlabel("time(s)");

figure %绘制删除无效值后时域图像
    plot(X_Abscissa_D,S{1});
    xlim([0,Time_D]);
    title("删除无效值后的加速度值");
    xlabel("time(s)");
%直接对该序列找到峰值,则有
[~,locs]=findpeaks(S{2},X_Abscissa);   %由matlab自动修复,由于第一个值无需使用,从而用占位符代替
figure
    %stairs(locs,1:length(locs));  %这样的图像效果不好,没有起始点,最终点也没有拖长
    stairs([0,locs,locs(end)+1],[0,1:length(locs),length(locs)]);  %这里末尾加1个同样的值是为了拖长最后一个阶梯,且加了一个开始点(0,0)
    xlim([0,Time+1])
    title("直接对未处理的数据用findpeaks计步");
    xlim([0,Time]);
    xlabel("时间(s)");
    ylabel("步数")

%%%%%%%%%%%% 1.初步处理结束 %%%%%%%%%%%%%%%%

%%%%%%%%%%%%% 2.第一种处理方法 %%%%%%%%%%%%%%
%得到DFT
Z=fft(S{1}); 

%绘制谱图
figure
    plot(X_Abscissa_f_D,abs(Z));
    xlim([-0.1,2*pi]);
    title("幅频图");

Time_D_r=round(Time_D);

%滤波处理,由于DFT中分辨率为1/T Hz,T是采样时间; 假设走路的频率在1~3Hz之间,那么应该滤除掉这些低于1Hz的
%由于DFT两个点之间的频率为1/THz, 1Hz对于T个点. 由于DFT关于pi对称,另一侧也需要滤除
%滤除低于1Hz的频率分量
Z(1:Time_D_r)=0;  
Z(length(Z)-Time_D_r+2:length(Z))=0;
%滤除高于3.5Hz的分量
Z(round(3.5*Time_D)+2:length(Z)-round(3.5*Time_D))=0;
%Z(round(3.5*Time_D_r)+2:length(Z)-round(3.5*Time_D_r))=0;

figure
    plot(X_Abscissa_f_D,abs(Z));
    xlim([-0.1,2*pi]);
    title("带通滤波后幅频图");
    xlabel("\omega");
    ylabel("|X(e^j^\omega)|")

figure
    plot(X_Abscissa_D,ifft(Z));
    xlim([0,Time_D]);
    title("带通滤波后时域");
    xlabel("时间(s)");

%经过带通滤波后,将其进行排序,去除掉幅度较小的频率
temp=sort(abs(Z),'descend');
Z=Z.*(abs(Z)>temp(10));
%{
temp=sort(abs(Z));  %从小到大排序
%Z(temp(length(temp)-2)<abs(Z)<temp(length(temp)-19)); 
Z=Z.*((abs(Z)>temp(length(temp)-9))&(abs(Z)<temp(length(temp))));
%}
figure
    plot(X_Abscissa_f_D,abs(Z));
    xlim([-0.1,2*pi]);
    title("排序滤波后幅频图");
    xlabel("\omega");
    ylabel("|X(e^j^\omega)|")

figure
    plot(X_Abscissa_D,ifft(Z));
    xlim([0,Time_D]);
    title("排序滤波后时域");

%恢复删除的无效序列,并将他们置零
X_bar=connect_signal(ifft(Z),S{3},S{4},len_A);
figure
    plot(X_Abscissa,X_bar);
    xlim([0,Time]);
    title("加零恢复后的序列");
    xlabel("time(s)");
%{
%将各个频率分量的强度都均分
temp2=abs(Z);
temp2(temp2==0)=1;
Z=Z./temp2 *sum(abs(Z))/10;  %除以10是因为保留了10个最大的频率
figure
    plot(X_Abscissa_D,ifft(Z));
    title("均分频域强度后的序列");
%}

[peaks,locs]=findpeaks(X_bar,X_Abscissa);
figure
    stairs([0,locs,locs(end)+1],[0,1:length(locs),length(locs)]); 
    %这里末尾加1个同样的值是为了拖长最后一个阶梯,且加了一个开始点(0,0)
    xlim([0,Time+1])
    title("计步");
    xlabel("时间(s)");
    ylabel("步数")

%{
figure;
plot(abs(Z));
U=ifft(Z);
DU=[U;0]-[0;U]; %差分
figure;
plot(U);

figure;
plot(DU);

DU=DU/sum(DU)*length(DU);
DU(DU<0)=0;
figure;
plot(DU.^2);


figure;
plot(U.^4);

U=U/sum(U)*length(U);
U(U<0)=0;
figure;
plot(U.^4);
%}

%%%%%%%%%%%%%%%%%%%%%%
%{
    Z(1:50)=0;Z(length(Z)-48:length(Z))=0;
Z(202:length(Z)-200)=0;
Z(abs(Z)<20)=0;
Z(abs(Z)<30)=0;
temp=sort(abs(Z));
Z(temp(length(temp)-2)<abs(Z)<temp(length(temp)-19));


figure
plot(abs(Z));
U=ifft(Z);
DU=[U;0]-[0;U];
figure
plot(U);

figure
plot(DU);



DU=DU/sum(DU)*length(DU);
DU(DU<0)=0;
figure
plot(DU.^2);


figure
plot(U.^4);

U=U/sum(U)*length(U);
U(U<0)=0;
figure
plot(U.^4);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%


%{
    K=fft(X);
Z=abs(K);

Zup=Z<400;
Zdown=Z>100;
Kout=K.*Zup.*Zdown;

figure
plot(linspace(0,2*pi,length(Z)),Z);
%plot(0:len_A+1,len_A*abs(fft(Y)));
figure
plot(x,ifft(Kout));
%}