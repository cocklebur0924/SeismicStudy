%% Synthetic Seismic Record
function [] = SyntheticSeismic()
clc;
clear;
close all;
%% Reflection Coefficient
ref=zeros(1,500);
ref(100)=0.5;
ref(200)=-0.6;
ref(300)=0.7;
ref(400)=0.3;
ref(500)=0.4;

%% Ricker Wavele
[wavelet_zero,~] = Ricker_zero(20,0.002,100,3); %中心频率20Hz,子波宽度r=3
[wavelet_min,~] = Ricker_minimum(20,0.002,100,3); %中心频率20Hz,子波宽度r=3

%%
SeisRecord_zero = conv(ref,wavelet_zero);
SeisRecord_min = conv(ref,wavelet_min);

x1=1:length(ref)+length(wavelet_zero)-1;
x2=1:length(ref)+length(wavelet_min)-1;
subplot(2,1,1)
plot(x1,SeisRecord_zero,'b',x2,SeisRecord_min,'r:','linewidth',2.0);
title('Seismic Record','FontSize',14);
legend('Ricker-zero','Ricker-minimum');
set(gca,'FontSize',12,'YLim',[-1.0 1.0]);
xlabel('sampling sequence'),ylabel('Amplitude')
hold on
subplot(2,1,2)
x3=1:length(ref);
stem(x3,ref,'k');xlabel('depth'),ylabel('value')
title('Reflection Coefficient','FontSize',14);
axis([-inf inf -1,1]);
set(gca,'FontSize',12);
grid on;
set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.7]);
%%
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