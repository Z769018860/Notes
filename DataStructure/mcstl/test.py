mygrade = [['A','1610302',60,70,70],['B','1610312',50,75,10],['C','1610322',65,70,75],['D','1610332',90,95,90]]
for i in range(len(mygrade)):
    for j in range(3):
        sum = sum + mygrade[i][j+2]
    ave = sum / 3
    mygrade[i].append(ave)
    if ave >= 90:
        mygrade[i].append('A')
    elif ave >= 60:
        mygrade[i].append('B')
    else:
        mygrade[i].append('C')
    ID = list(mygrade[i][1])
    ID1 = ''.join(ID[4:6])
    mygrade[i].append(ID1)
    sum = 0
    ave = 0
print(mygrade)
input()