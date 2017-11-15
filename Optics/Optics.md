# 光学公式整理

王华强

Last edited: 2017.10.22

---

## 基础，反射与折射

### 光强

$$I=\frac{n}{2cu_0}E_0^2$$

比较两种介质中的光强时

$$I=nE_0^2$$

### 简谐波的数学表达

一维波

$$U=Acos(\omega (t-\frac{x}{v}+\varphi))$$

$$U=Acos(\omega t-kx+\varphi)$$

平面波

$$U=Acos(\omega t-\vec{k} \vec{r})$$
球面波(发散)

$$U=\frac{A}{r}cos(\omega t-kr)$$

### 复振幅

球面波的复振幅：相因子正负代表聚散

### 波前函数

波前上的复振幅分布

### 偏振度

$$P=\frac{I_{max}-I_{min}}{I_{max}+I_{min}}$$

Tips：某一方向上的偏振光可以沿两轴分解

### 费马原理

$$n=\frac{c}{v}$$

$$$$

$$L=\int_a^b nds$$

### 折射定律

$$n_1sin(in)=n_2sin(t)$$

### 菲涅尔公式

$$\hat{r}_s=-\frac{sin(i1-i2)}{sin(i1+i2)}=\frac{\hat{E}_{s1}}{\hat{E}_{s2}}$$

$$ $$

$$\hat{r}_p=\frac{tan(i1-i2)}{tan(i1+i2)}=\frac{\hat{E}_{p1}}{\hat{E}_{p2}}$$

$$ $$

$$\hat{t}_s=-\frac{2cos(i1)sin(i2)}{sin(i1+i2)}=\frac{\hat{E}_{s1}}{\hat{E}_{s1t}}$$

$$ $$

$$\hat{t}_p=-\frac{2n_1cos(i1)}{n_2cos(i1)+n_1cos(i2)}=\frac{\hat{E}_{p1}}{\hat{E}_{p1t}}$$

反射率随入射角变化的曲线：

* 随入射角增大总反射率增大
* $r_p$ 在$i_b$处取得0

### 不同种反射率之间的关系

光强反射率=振幅反射率$^2$

光强透射率=$\frac{n2}{n1}$振幅反射率$^2$

光功率反射率=光强反射率 (由于光截面大小相同)

光功率折射率=$\frac{cos(n2)}{cos(n1)}$光强反射率 (折射导致了光截面的大小变化,光截面的大小之比为$\frac{cos(n2)}{cos(n1)}$)

### 斯托克斯倒逆关系

$$\hat{r}^2+\hat{t}\hat{t}`=1$$

$$\hat{r}=-\hat{r}`$$

两种反射情形相差-，说明两边必有一边存在相位$\pi$的突变.

反射相位突变只有在n1<n2的反射时同时对ps两向发生

### 布儒斯特角

$$i_B=arctan\frac{n2}{n1}$$

在此处p光相位突变, s光不受影响

### 全反射角

$$i_c=arcsin\frac{n2}{n1}$$

角度大于此角后开始全反射, 伴随角度的变化发生相位变化(从0到$\pi$).

### 反射光的相位变换

* 当某一方向的反射率出现复数时,意味着发生了0-$\pi$之间的相位变化

### 隐失波

Todo: 隐失波分析

### 基础部分补充

* 入射面：指入射光线，法线，反射光线与折射光线所在的平面
* 振动方位角：光矢量与入射面之间的夹角，实质上是光矢量与p轴的夹角

## 几何光学部分

Todo: 几何光学



## 干涉部分

$$A^2=A_1^2+A_2^2+2A_1A_2cos\phi$$

其中$\phi$为相位角

$$I=I_1+I_2+2\sqrt{I_1I_2}cos\phi$$

在非干涉条件下:

$$\overline{I}=I_1+I_2$$

干涉衬比度定义为:

$$P=\frac{I_{max}-I_{min}}{I_{max}+I_{min}}$$

### 分波前干涉--杨氏干涉

$\Delta$为光程差,d为孔间距,D为孔到光屏距离, x为条纹位置:

$$\Delta=\frac{dx}{D}$$

得条纹间距为:

$$\Delta x=\frac{\lambda D}{d}$$

### 非对称杨氏干涉

$$\frac{\Delta_R}{d}=\frac{p}{R}$$

$$ $$

$$\frac{\Delta_D}{d}=\frac{x}{D}$$

$$\Delta=\Delta_r+\Delta_d$$

条纹间距仍为:

$$\Delta x=\frac{\lambda D}{d}$$

确定中心点位置的时候,令$\Delta$=0:

$$pD=-xR$$

干涉填平补齐时,满足:光源宽度引起的中心点位移=条纹间距

$$\frac{\lambda D}{d}=\frac{Dp}{R}$$

其中p为从中心点开始的光源宽度.

### 分振幅干涉--薄膜干涉

光程差:

$$\Delta=2nhcos(r)+\frac{\lambda}{2}$$

薄膜干涉时的定域问题.

### 等倾干涉

光程差:

$$\Delta=2hcos(r)-\frac{\lambda}{2}$$

亮纹:

$$\Delta=k\lambda$$

暗纹:

$$\Delta=(k+\frac{1}{2})\lambda$$

干涉条纹的间距:

对光程差公式两边求导,命$d\Delta$=$\lambda$,所解得dr即为间距:

$$dr=-\frac{\lambda}{2nhsin(r)}$$

### 等厚干涉

$$\Delta=2nh\underline{+}\frac{\lambda}{2}$$

牛顿环光程差:

$$\Delta=2h-\frac{\lambda}{2}$$

由几何关系得:

$$\frac{r}{R}=\frac{2h}{r}$$

代入可由曲率半径求得圆环半径.

曲率半径可由下式求得:

$$R=\frac{r_{k+m}^2-r_{k}^2}{m\lambda}$$
