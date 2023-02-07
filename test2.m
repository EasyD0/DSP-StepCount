clear;
close all;
t=0:0.001:1.024-.001; 
N=1024; 

% 得到Chirp 信号, 信号初始频率为0Hz,并随时间线性增加频率,在时间为1时频率达到350Hz
y=chirp(t,0,1,350);
figure;
    plot(t,y);

% 求两个Chirp 信号和的短时傅里叶变换；


[S,F,T]=specgram(y,128,1000,hanning(128),127); 
figure;
surf(T,F,abs(S).^2);
view(-80,30);
shading flat;
colormap(cool);
xlabel('Time');
ylabel('Frequency');
zlabel('spectrogram');