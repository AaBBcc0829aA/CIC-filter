import numpy as np
import math
import matplotlib.pyplot as plt

R=128
M=32

n=10000

f=np.array(range(1,n))/n
A=np.array(range(1,n))

for k in range(0,n-1):
    H=math.sin(math.pi*M*f[k])/math.sin(math.pi*f[k]/R)
    A[k]=10*math.log(abs(H))

AA=A[0]
for k in range(0,n-1):
    A[k]=A[k]-AA
    if A[k]<-60:
        A[k]=-60
    
plt.plot(50*f,A,'r')
plt.title('Amplitude - Frequency Characteristics');
plt.xlabel('frequency(kHz)');
plt.ylabel('amplitude response(dB)');
plt.grid()
plt.show()




