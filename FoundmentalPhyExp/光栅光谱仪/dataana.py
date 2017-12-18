import scipy as sp
import numpy as np 
import matplotlib.pyplot as plt
import math
import sys

x=[]
y=[]

#Get data
file = open(sys.argv[1])

for line in file:
    sline=line.split()
    x.append(sline[0])
    y.append(sline[1])

x=list(map(float,x))
y=list(map(float,y))

#Analyze data

def max(y):
    temp=-1
    maxfind=0
    i=0
    while (i<len(y)):
        if (float(y[i])> maxfind):
            temp=i;
            maxfind=y[i]

        i=i+1
    return (temp)

maxindex=max(y)

def findhalf(y,maxindex):
    hmax=y[maxindex]/2
    result=[]
    z=list(map(lambda x:abs(x-hmax),y))
    # print(z)
    _find=1000
    get=0
    a=maxindex-1
    while(y[a-1]<y[a] and a-1>0):
        if(z[a]<_find):
            get=a
            _find=z[a]
        a=a-1
    result.append(get)
    
    get=0
    
    _find=1000
    b=maxindex+1
    while(y[b+1]<y[b] and b+1<len(y)):
        if(z[b]<_find):
            get=b
            _find=z[b]
            
        b=b+1
    result.append(get)
        

    difresult=[]
    print(result)
    while(len(result)!=0):
        # print(len(result))
        difresult.append(abs(x[result.pop()]-x[result.pop()]))
    return difresult


print("(x) = ",x[maxindex])
print("(ymax) = ",y[maxindex])

print ("Half peak width:",findhalf(y,maxindex))



#Draw curve
# namex=input("namex?")
# namey=input("namey?")
title=sys.argv[1]

#X-y curve
plt.figure(figsize=(8,4))
plt.plot(x,y,color="black",linewidth=2)
plt.xlabel("wavelength/nm")
plt.ylabel("energy")
plt.title(title)
plt.show()

#Find alpha
d=1.5*10e-3 #m
alpha=list(map(lambda x: math.log(1/(x/100))/d,y))

plt.figure(figsize=(8,4))
plt.plot(x,alpha,color="black",linewidth=2)
plt.xlabel("wavelength/nm")
plt.ylabel("alpha/m^(-1)")
plt.title(title)
plt.show()