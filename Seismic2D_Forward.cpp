// 2D FDM Seismic Forward (without Absorting Boundary)
// Spatial accuracy: N = 2 - 16 (even number)
// Author：Cocklebur
// 2023 

#include<stdio.h>
#include<math.h>
#include<stdlib.h> 
#include <vector>
#include <iostream>
using namespace std;
#pragma warning(disable : 4996)

// Define Constant 
#define PI 3.14159265359
#define nx 400                                  //网格点x(m)；
#define nz 400                                  //网格点z(m)；
#define dh 4                                    //空间步长dh(m)；
#define dt 0.00025                              //时间步长dt(s)；
#define Sx 200                                  //震源位置x(m)；
#define Sz 100                                  //震源位置z(m)；
#define F 20                                    //震源主频f(Hz)：15-25Hz；
#define R 3                                     //震源Lamda取值范围2-4；
#define Kmax 1000                               //时间循环次数；

// 建 立 二 维 动 态 数 组 函 数 
double**dimension2(int x, int y)
{
	int i;
	double **m;
	m = (double**)malloc(x * sizeof(double*));
	for (i = 0; i < x; i++)
	{
		m[i] = (double*)malloc(y*sizeof(double));
	}
	return m;
}

// 矩 阵 交 换 赋 值 函 数 
void exchange(double **u1, double **u2, double **u3)  
{
	int i, j;
	for (i = 0; i<nx; i++)
		for (j = 0; j<nz; j++)
			u1[i][j] = u2[i][j];
	for (i = 0; i<nx; i++)
		for (j = 0; j<nz; j++)
			u2[i][j] = u3[i][j];
}

// ************** Main Program Start **************
int main()
{
// 定 义 变 量 
	FILE *fp1, *fp2;                               // fp1存放波场值，fp2存放地震记录
	int i, j, k, delta, N;                         // N为空间精度；delta函数控制是否加载震源项
	double v;                                      // 速度模型v；
	double** u1, ** u2, ** u3, s[Kmax], ** rec;    // 波场值u1(past),u2(now),u3(future)；震源函数s；地震记录rec；
	double t1, t2, A;
	u1 = dimension2(nx,nz);
	u2 = dimension2(nx,nz);
	u3 = dimension2(nx,nz);
	rec = dimension2(nx, Kmax);

// 选 择 声 波 方 程 空 间 阶 数 
	printf("Please enter the accuracy(support：2-16 even number):\n");
	scanf("%d", &N);
// 选 择 想 要 输 出 波 场 值 的 时 刻
	printf("Which moments(ms) wavefield you want to output?\n");
	//scanf("%d", &wave);
	vector < int > wave;
	int  p = 0;
	do {
		cin >> p;
		wave.push_back(p);
	} while (getchar() != '\n');
	cout << "---The wave field will be output :---" << endl;
	for (int p = 0; p < wave.size(); p++)
	{
		cout << "when time = " << wave.at(p) << endl;
	}

// 波 场 值 赋 初 值
	for (i = 0; i < nx; i++)
		for (j = 0; j < nz; j++)
		{
			u1[i][j] = 0;
			u2[i][j] = 0;
			u3[i][j] = 0;
		}

	for (i = 0; i < nx; i++)
		for (int k = 0; k < Kmax; k++) 
		{
			rec[i][k] = 0;
		}

// 震 源 函 数
	for (k = 0; k < Kmax; k++)                       
	{
		s[k] = exp(-pow(2*PI*F/R, 2)*pow(k*dt, 2))*cos(2*PI*F*k*dt);
	}
	
// 定 义 速 度 模 型
	for (i = 0; i < nx; i++)
		for (j = 0; j < nz; j++) 
		{
			if (j < 200)                            
				v = 2000;
			else
				v = 2500;
		}

// N 阶 空 间 精 度 波 场 值 计 算
	
	for (k = 0; k < Kmax; k++)
	{
		for (i = N/2; i < nx - N/2; i++)
		{
			for (j = N/2; j < nz - N/2; j++)
			{

				if (i == Sx && j == Sz)
					delta = 1;
				else
					delta = 0;

				//空间精度2-16阶的系数矩阵
				double c[8][8] = 
				{ 
					{1.0},
					{4/3.0,-1/12.0},
					{3/2.0,-3/20.0,1/90.0},
					{8/5.0,-1/5.0,8/315.0,-1/560.0},
					{5/3.0,-5/21.0,5/126.0,-5/1008.0,1/3150.0},
					{12/7.0,-15/56.0,10/189.0,-1/112.0,2/1925.0,-1/16632.0},
					{7/4.0,-7/24.0,7/108.0,-7/528.0,7/3300.0,-7/30888.0,1/84084.0},
					{16/9.0,-14/45.0,112/1485.0,-7/396.0,112/32175.0,2/3861.0,16/315315.0,-1/411840.0},
				};

				A = 0;
				for (int p = 1; p <= N/2; p++)
				{
					t1 = c[N/2-1][p-1] * (u2[i + p][j] + u2[i - p][j] - 2 * u2[i][j]);
					t2 = c[N/2-1][p-1] * (u2[i][j +p] + u2[i][j-p] - 2 * u2[i][j]);
					A += t1 + t2;
				}
				 
				u3[i][j] = 2 * u2[i][j] - u1[i][j] + pow(v * dt / dh, 2) * A + s[k] * delta;

				if (j == Sz)
					rec[i][k] = u3[i][Sz];                  // 输出地震记录；
			}

		}


		for (int p = 0; p < wave.size(); p++)
		{

			if ((k + 1) == wave.at(p))                                      // K = wave 时波场值输出；
			{
				char filename[20];
					sprintf(filename, "wavefront_%d.dat", wave.at(p));

					if (fp1 = fopen(filename, "w"))
					{
						for (i = 0; i < nx; i++)
							for (j = 0; j < nz; j++)
							{
								fprintf(fp1, "%lf\t", u3[i][j]);
									if (j == nz - 1)
										fprintf(fp1, "\n");
							}
						fclose(fp1);
					}
			}
		}

		exchange(u1, u2, u3);
		if ((k + 1) % 100 == 0)
		{
			printf("No.%d has been completed!\n", k+1);
		}
	}

	if (fp2 = fopen("record.dat", "w"))
	{
		for (i = 0; i < nx; i++)
			for (j = 0; j < Kmax; j++)
			{
				fprintf(fp2,"%lf\t", rec[i][j]);
				if (j == Kmax - 1)
					fprintf(fp2, "\n");
			}
		fclose(fp2);
	}

	for (i = 0; i < nx; i++) 
	{
		free(u1[i]);
		free(u2[i]);
		free(u3[i]);
	}
	return 0;
}
