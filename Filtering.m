function [] = Filtering()
clc;
clear;
close all;

m=100;                                    %������100
dt=0.002;                                 %ʱ��������0.002
N=2^nextpow2(m);                          %ȡ����m��С��2���ݴ�
df=1/( N * dt );                          %�ռ���
%% 
[wavelet,~] = Ricker_zero(25,dt,m,3);     %����Ƶ��25Hz���Ӳ����r=3
wavelet(m+1:N) = 0;                       %����

fft_wavelet=fft(wavelet);                 %����ɢ������Ӳ����п��ٸ��ϱ任
amplitude_wavelet=abs(fft_wavelet);       %�������

%% ��Ƶ�ͨ�˲���,��Ƶ��Ϊ25Hz���źŽ����˲�,�˵�����62.5HzƵ�ʳɷ�
f = 62.5;
startFilter = f / df;
endFilter = N - startFilter;
%�����˲���
for i = 1 : N
    value(i) = 1;
end
for i = startFilter + 1 : endFilter - 1
    value(i) = 0;
end
%��б���˲���
for i = 1 : N
    value_slope(i)=1;
end
for i = (startFilter + 8) : (endFilter - 8)
    value_slope(i)=0;
end
for i = startFilter : startFilter + 8
    value_slope(i) = -1/8 * i + 1 + 1/8 * startFilter;
end
for i = endFilter - 8 : endFilter
    value_slope(i) = 1/8 * i + 1 -1/8 * endFilter;
end

%Ƶ�����˲�
for i = 1 : N
    freq_ideal(i) = value(i)*fft_wavelet(i);
    freq_slope(i) = value_slope(i)*fft_wavelet(i);
end
%���任��ʱ����
ifft_wavelet_ideal=ifft(freq_ideal);
ifft_wavelet_slope=ifft(freq_slope);

%% ��ͼ
x=1:N;
figure,
subplot(2,3,1)
plot(x,wavelet,'k','LineWidth',2.0)                    %����ʱ�����Ӳ�
title('ʱ�����׿��Ӳ�'),xlabel('Time(ms)'),ylabel('Amplitude'),axis([-inf inf -inf inf]),legend('��Ƶ25Hz,�Ӳ����3');

subplot(2,3,4)
plot(x,amplitude_wavelet,'k','LineWidth',2.0)          %����Ƶ���������
title('Ƶ���������'),xlabel('Frequency(Hz)'),ylabel('Amplitude'),legend('��Ƶ25Hz');
set(gca,'XLim',[0 N]);

subplot(2,3,2)
plot(x,value,'k',x,value_slope,'b','LineWidth',1.5)    %�����˲���
axis([-inf,inf,0,1.5]),title('��ͨ�˲���'),xlabel('Frequency(Hz)'),legend('�����˲���','��б���˲���');
grid on
 
subplot(2,3,5)                                         %�����˲��������
plot(x,freq_ideal,'k',x,freq_slope,'b--','LineWidth',2.0)  
title('�˲��������'),xlabel('Frequency(Hz)'),ylabel('Amplitude'),legend('�����˲���','��б���˲���'),axis([-inf inf -inf inf])
grid on

subplot(2,3,3)                                         %�����˲���ʱ�����ź�
plot(x,wavelet,'k',x,real(ifft_wavelet_ideal),'b-','LineWidth',2.0)
title('�����˲���'),legend('Origin Signal','After Filtering'),xlabel('Time(ms)'),ylabel('Amplitude'),axis([0 m -inf inf])
subplot(2,3,6)
plot(x,wavelet,'k',x,real(ifft_wavelet_slope),'r-','LineWidth',2.0)
title('��б���˲���'),legend('Origin Signal','After Filtering'),xlabel('Time(ms)'),ylabel('Amplitude'),axis([0 m -inf inf])
end

function [wavelet_zero,time]=Ricker_zero(freqs,dt,nt,r)
% freqs:��Ƶ 
% dt:����ʱ����
% nt:��������
% r: �Ӳ����
tmin=0;
tmax=dt*nt;
time=tmin:dt:tmax;
wavelet_zero=exp(-(2*pi*freqs/r)^2*time.^2).*cos(2*pi*freqs.*time);
end




