clear;
clc;close all;

theta=1.4;
%%%%%%%%%%%% 1.�������� %%%%%%%%%%%%%%%

%��ȡ��������,���ֱ𱣴浽x,y,z��, ����4096��õ��ľ����������ٶ�g�ı���
%���ļ��е���������100��������
A=load("��¥.txt");
len_A=length(A);
A_x=A(:,1)/4096;   A_y=A(:,2)/4096;  A_z=A(:,3)/4096;

%���ٶȼƵĲ���Ƶ��Ϊ100Hz,��������Ϊlength(A_x),�����ʱ������
Time=length(A_x)/100;

X_Abscissa=linspace(0,Time,length(A_x)); %���� ʱ��ͼ�ĺ�����
X_Abscissa_f=linspace(0,2*pi,length(A_x));



Acc=sqrt(A_x.^2+A_y.^2+A_z.^2);      %���ٶȵ�ģ��



S=delete_zero(Acc,80,theta);      %�����ٶ�������, �г�������80(0.8��)����С��1.2���������ٶ�,��ɾ��
Time_D=length(S{1})/100;        %ɾ������Ч���Ⱥ��Ӧ��ʱ�䳤��

X_Abscissa_D=linspace(0,Time_D,length(S{1}));     %���� ʱ��ͼ�ĺ�����
X_Abscissa_f_D=linspace(0,2*pi,length(S{1}));     %


figure;  %�������ܼ��ٶȼƵ�ԭʼ����ͼ
    plot(X_Abscissa,A_x,  X_Abscissa,A_y,  X_Abscissa,A_z);
    axis([0,Time,min([A_x;A_y;A_z])-1,max([A_x;A_y;A_z])+1]);
    title("");
    xlabel("time(s)");
    ylabel("���ٶ�\times9.8 m/s^2");
    

figure;  %�����ܼ��ٶ�
    plot(X_Abscissa,Acc);
    axis([0,Time,0,max([A_x;A_y;A_z])+1]);
    title("�ܼ��ٶ�\times9.8m/s^2");
    xlabel("time(s)");

figure %����ɾ����Чֵ��ʱ��ͼ��
    plot(X_Abscissa,S{2});
    xlim([0,Time_D]);
    title("ɾ����Чֵ��ļ��ٶ�ֵ");
    xlabel("time(s)");
%ֱ�ӶԸ������ҵ���ֵ,����
[~,locs]=findpeaks(S{2},X_Abscissa);   %��matlab�Զ��޸�,���ڵ�һ��ֵ����ʹ��,�Ӷ���ռλ������
figure
    %stairs(locs,1:length(locs));  %������ͼ��Ч������,û����ʼ��,���յ�Ҳû���ϳ�
    stairs([0,locs,locs(end)+1],[0,1:length(locs),length(locs)]);  %����ĩβ��1��ͬ����ֵ��Ϊ���ϳ����һ������,�Ҽ���һ����ʼ��(0,0)
    xlim([0,Time+1])
    title("ֱ�Ӷ�δ�����������findpeaks�Ʋ�");
    xlim([0,Time]);
    xlabel("ʱ��(s)");
    ylabel("����")

%%%%%%%%%%%% 1.����������� %%%%%%%%%%%%%%%%

%%%%%%%%%%%%% 2.��һ�ִ����� %%%%%%%%%%%%%%
%�õ�DFT
Z=fft(S{1}); 

%������ͼ
figure
    plot(X_Abscissa_f_D,abs(Z));
    xlim([-0.1,2*pi]);
    title("��Ƶͼ");

Time_D_r=round(Time_D);

%�˲�����,����DFT�зֱ���Ϊ1/T Hz,T�ǲ���ʱ��; ������·��Ƶ����1~3Hz֮��,��ôӦ���˳�����Щ����1Hz��
%����DFT������֮���Ƶ��Ϊ1/THz, 1Hz����T����. ����DFT����pi�Գ�,��һ��Ҳ��Ҫ�˳�
%�˳�����1Hz��Ƶ�ʷ���
Z(1:Time_D_r)=0;  
Z(length(Z)-Time_D_r+2:length(Z))=0;
%�˳�����3.5Hz�ķ���
Z(round(3.5*Time_D)+2:length(Z)-round(3.5*Time_D))=0;
%Z(round(3.5*Time_D_r)+2:length(Z)-round(3.5*Time_D_r))=0;

figure
    plot(X_Abscissa_f_D,abs(Z));
    xlim([-0.1,2*pi]);
    title("��ͨ�˲����Ƶͼ");
figure
    plot(X_Abscissa_D,ifft(Z));
    xlim([0,Time_D]);
    title("��ͨ�˲���ʱ��");

%������ͨ�˲���,�����������,ȥ�������Ƚ�С��Ƶ��
temp=sort(abs(Z));  %��С��������
%Z(temp(length(temp)-2)<abs(Z)<temp(length(temp)-19)); 
Z=Z.*((abs(Z)>temp(length(temp)-9))&(abs(Z)<temp(length(temp))));

figure
    plot(X_Abscissa_f_D,abs(Z));
    xlim([-0.1,2*pi]);
    title("�����˲����Ƶͼ");
figure
    plot(X_Abscissa_D,ifft(Z));
    xlim([0,Time_D]);
    title("�����˲���ʱ��");

%�ָ�ɾ������Ч����,������������
X_bar=connect_signal(ifft(Z),S{3},S{4},len_A);
figure
    plot(X_Abscissa,X_bar);
    xlim([0,Time]);
    title("����ָ��������");
%{
%������Ƶ�ʷ�����ǿ�ȶ�����
temp2=abs(Z);
temp2(temp2==0)=1;
Z=Z./temp2 *sum(abs(Z))/10;  %����10����Ϊ������10������Ƶ��
figure
    plot(X_Abscissa_D,ifft(Z));
    title("����Ƶ��ǿ�Ⱥ������");
%}

[peaks,locs]=findpeaks(X_bar,X_Abscissa);
figure
    stairs([0,locs,locs(end)+1],[0,1:length(locs),length(locs)]); 
    %����ĩβ��1��ͬ����ֵ��Ϊ���ϳ����һ������,�Ҽ���һ����ʼ��(0,0)
    xlim([0,Time+1])
    title("�Ʋ�");
    xlabel("ʱ��(s)");
    ylabel("����")

%{
figure;
plot(abs(Z));
U=ifft(Z);
DU=[U;0]-[0;U]; %���
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