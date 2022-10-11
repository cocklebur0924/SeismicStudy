%% Ricker Wavelet
function []=RickerWavelet()
clear;
clc;

[wavelet_zero1,timez1] = Ricker_zero(20,0.002,100,3); %中心频率20Hz,子波宽度r=3
[wavelet_zero2,timez2] = Ricker_zero(10,0.002,100,3); %中心频率10Hz,子波宽度r=3
[wavelet_zero3,timez3] = Ricker_zero(20,0.002,100,5);  %中心频率20Hz,子波宽度r=5

[wavelet_min1,timem1] = Ricker_minimum(20,0.002,100,3); %中心频率20Hz,子波宽度r=3
[wavelet_min2,timem2] = Ricker_minimum(10,0.002,100,3); %中心频率10Hz,子波宽度r=3
[wavelet_min3,timem3] = Ricker_minimum(20,0.002,100,5); %中心频率20Hz,子波宽度r=5
figure(1)
%不同主频的Ricker Wavelet（零相位）对比
subplot(1,2,1)
plot(timez1,wavelet_zero1,'b',timez2,wavelet_zero2,'r-','linewidth',2);
set(gca,'XLim',[0 0.15],'YLim',[-1.0 1.0],'FontSize',13)
legend('主频20Hz,子波宽度r=3','主频10Hz,子波宽度r=3'),title('Ricker Wavelet(zero-phase)'),xlabel('Time(s)'),ylabel('Amplitude')
%不同主频的Ricker Wavelet（最小相位）对比
subplot(1,2,2)
plot(timem1,wavelet_min1,'b',timem2,wavelet_min2,'r-','linewidth',2);
set(gca,'XLim',[0 0.15],'YLim',[-1.0 1.0],'FontSize',13)
set(gcf,'unit','normalized','position',[0.2,0.2,0.7,0.5]);
legend('主频20Hz,子波宽度r=3','主频10Hz,子波宽度r=3'),title('Ricker Wavelet(minimum-phase)'),xlabel('Time(s)'),ylabel('Amplitude')
hold on

figure(2)
%不同子波宽度的Ricker Wavelet（零相位）对比 
subplot(1,2,1)
plot(timez1,wavelet_zero1,'b',timez3,wavelet_zero3,'r-','linewidth',2);
set(gca,'XLim',[0 0.15],'YLim',[-1.0 1.0],'FontSize',13)
legend('主频20Hz,子波宽度r=3','主频20Hz,子波宽度r=5'),title('Ricker Wavelet(zero-phase)'),xlabel('Time(s)'),ylabel('Amplitude')
%不同子波宽度的Ricker Wavelet（最小相位）对比 
subplot(1,2,2)
plot(timem1,wavelet_min1,'b',timem3,wavelet_min3,'r-','linewidth',2);
set(gca,'XLim',[0 0.15],'YLim',[-1.0 1.0],'FontSize',13)
set(gcf,'unit','normalized','position',[0.2,0.2,0.7,0.5]);
legend('主频20Hz,子波宽度r=3','主频20Hz,子波宽度r=5'),title('Ricker Wavelet(minimum-phase)'),xlabel('Time(s)'),ylabel('Amplitude')

function [wavelet_zero,time]=Ricker_zero(freqs,dt,nt,r)
% freqs:主频 
% dt:采样时间间隔
% nt:采样点数
% r: 子波宽度
tmin=0;
tmax=dt*nt;
time=tmin:dt:tmax;
wavelet_zero=exp(-(2*pi*freqs/r)^2*time.^2).*cos(2*pi*freqs.*time);
end

function [wavelet_min,time]=Ricker_minimum(freqs,dt,nt,r)
% freqs:主频 
% dt:采样时间间隔
% nt:采样点数
% r: 子波宽度
tmin=0;
tmax=dt*nt;
time=tmin:dt:tmax;
wavelet_min=exp(-(2*pi*freqs/r)^2*time.^2).*sin(2*pi*freqs.*time);
end

end