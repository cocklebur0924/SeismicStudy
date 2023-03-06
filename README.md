# SeismicStudy

一些学习地震时编写的小程序。

RickerWavelet.m ：雷克子波的显示

SyntheticSeismic.m ：一维合成地震记录（根据雷克子波和反射系数）

Filtering.m ：低通滤波器，滤掉高频成分（以雷克子波为例）

Seismic2D_Forward.cpp :二维声波方程有限差分正演，时间精度2阶，空间精度2-16阶，无吸收边界条件

Seismic2D_Forward_ABC.cpp：二维声波方程有限差分正演，时间精度2阶，空间精度2-16阶，两种吸收边界条件：Sponge海绵吸收边界、PML完全匹配层吸收边界
