import numpy as np
import matplotlib.pyplot as plt
import math

T=[1,2,3,4,5]*507.52*9.8
f=[23.3,33.8,40.7,47.5,53.3]

logt=log(T)
logf=log(f)

z1 = np.polyfit(logt, logf, 1)  #一次多项式拟合，相当于线性拟合
p1 = np.poly1d(z1)

plt.plot(logt,logf,z1)