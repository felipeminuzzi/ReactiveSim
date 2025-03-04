import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

raw_file = sys.argv[1]

f = open(raw_file, 'r')
content = f.readlines()

n = int(content[2][18:21])

if not n%3 == 0:
    m = n//3 + 1
else:
    m = n//3

if not n%5 == 0:
    p = n//5 + 1
else:
    p = n//5

def get_data(list_r):
    free_r = []

    for i in range(len(list_r)):
        tmp = list_r[i].split()
        for j in range(len(tmp)):
            free_r.append(tmp[j])

    try:
        final_r = np.array(free_r).astype(float)
    except:
        tmp_lst = []
        for k in range(len(free_r)):
            try:
                aux = float(free_r[k])
                tmp_lst.append(aux)
            except:
                aux = 0
                tmp_lst.append(aux)
        
        final_r = np.array(tmp_lst).astype(float)

    return final_r

df = pd.DataFrame()

idn    = m+4
id_low = m+5
id_up  = id_low + p
name   = content[idn].split()[0]
x_data = content[id_low:id_up] 
r = get_data(x_data)
df[name] = r

for _ in range(41):
    idn    = id_up+p
    id_low = id_up+p+1
    id_up  = id_low + p
    name   = content[idn].split()[0]
    x_data = content[id_low:id_up] 
    r = get_data(x_data)
    df[name] = r

inp_var = input('Type a list with variables to plot: ')
var     = inp_var.split()

plt.figure(1)
for i in range(len(var)):

    plt.subplot(2,2,i+1)
    plt.plot(df['r('], df[var[i]], '-', label=var[i])
    plt.ylabel(var[i])
    plt.xlabel('r(cm)')
    plt.legend()
plt.show()


    