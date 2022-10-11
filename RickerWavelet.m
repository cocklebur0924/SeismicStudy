%% Ricker Wavelet
function []=RickerWavelet()
clear;
clc;

[wavelet_zero1,timez1] = Ricker_zero(20,0.002,100,3); %����Ƶ��20Hz,�Ӳ����r=3
[wavelet_zero2,timez2] = Ricker_zero(10,0.002,100,3); %����Ƶ��10Hz,�Ӳ����r=3
[wavelet_zero3,timez3] = Ricker_zero(20,0.002,100,5);  %����Ƶ��20Hz,�Ӳ����r=5

[wavelet_min1,timem1] = Ricker_minimum(20,0.002,100,3); %����Ƶ��20Hz,�Ӳ����r=3
[wavelet_min2,timem2] = Ricker_minimum(10,0.002,100,3); %����Ƶ��10Hz,�Ӳ����r=3
[wavelet_min3,timem3] = Ricker_minimum(20,0.002,100,5); %����Ƶ��20Hz,�Ӳ����r=5
figure(1)
%��ͬ��Ƶ��Ricker Wavelet������λ���Ա�
subplot(1,2,1)
plot(timez1,wavelet_zero1,'b',timez2,wavelet_zero2,'r-','linewidth',2);
set(gca,'XLim',[0 0.15],'YLim',[-1.0 1.0],'FontSize',13)
legend('��Ƶ20Hz,�Ӳ����r=3','��Ƶ10Hz,�Ӳ����r=3'),title('Ricker Wavelet(zero-phase)'),xlabel('Time(s)'),ylabel('Amplitude')
%��ͬ��Ƶ��Ricker Wavelet����С��λ���Ա�
subplot(1,2,2)
plot(timem1,wavelet_min1,'b',timem2,wavelet_min2,'r-','linewidth',2);
set(gca,'XLim',[0 0.15],'YLim',[-1.0 1.0],'FontSize',13)
set(gcf,'unit','normalized','position',[0.2,0.2,0.7,0.5]);
legend('��Ƶ20Hz,�Ӳ����r=3','��Ƶ10Hz,�Ӳ����r=3'),title('Ricker Wavelet(minimum-phase)'),xlabel('Time(s)'),ylabel('Amplitude')
hold on

figure(2)
%��ͬ�Ӳ���ȵ�Ricker Wavelet������λ���Ա� 
subplot(1,2,1)
plot(timez1,wavelet_zero1,'b',timez3,wavelet_zero3,'r-','linewidth',2);
set(gca,'XLim',[0 0.15],'YLim',[-1.0 1.0],'FontSize',13)
legend('��Ƶ20Hz,�Ӳ����r=3','��Ƶ20Hz,�Ӳ����r=5'),title('Ricker Wavelet(zero-phase)'),xlabel('Time(s)'),ylabel('Amplitude')
%��ͬ�Ӳ���ȵ�Ricker Wavelet����С��λ���Ա� 
subplot(1,2,2)
plot(timem1,wavelet_min1,'b',timem3,wavelet_min3,'r-','linewidth',2);
set(gca,'XLim',[0 0.15],'YLim',[-1.0 1.0],'FontSize',13)
set(gcf,'unit','normalized','position',[0.2,0.2,0.7,0.5]);
legend('��Ƶ20Hz,�Ӳ����r=3','��Ƶ20Hz,�Ӳ����r=5'),title('Ricker Wavelet(minimum-phase)'),xlabel('Time(s)'),ylabel('Amplitude')

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

function [wavelet_min,time]=Ricker_minimum(freqs,dt,nt,r)
% freqs:��Ƶ 
% dt:����ʱ����
% nt:��������
% r: �Ӳ����
tmin=0;
tmax=dt*nt;
time=tmin:dt:tmax;
wavelet_min=exp(-(2*pi*freqs/r)^2*time.^2).*sin(2*pi*freqs.*time);
end

end