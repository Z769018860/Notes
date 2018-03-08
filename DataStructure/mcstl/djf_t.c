#include <stdio.h>
#include <stdlib.h>
#define TRUE        1
#define FALSE       0
#define OK          1
#define ERROR       0
#define INFEASIBLE -1
#define OVERFLOW   -2

typedef int Status;
typedef int ElemType;
typedef ElemType *Triplet;


Status InitTriplet(Triplet* pT, ElemType v1, ElemType v2, ElemType v3)
{
    *pT=(ElemType *)malloc(3*sizeof(ElemType));
    printf("*T=%d, T=%p\n", *pT, pT);
    if(!(*pT))
        exit(OVERFLOW);
    (*pT)[0]=v1;
    (*pT)[1]=v2;
    (*pT)[2]=v3;
    printf("%d %d %d\n", (*pT)[0], (*pT)[1], (*pT)[2]);
    return OK;
}

Status DestroyTriplet(Triplet T)
{
    free(T);
    T=NULL;
    return OK;
}

Status Get(Triplet T, int i, ElemType *e)
{
    if(i<1 || i>3)
        return ERROR;
    *e=T[i-1];
    return OK;
}

Status Put(Triplet T, int i, ElemType e)
{
    if(i<1 || i>3)
        return ERROR;
    T[i-1]=e;
    return OK;
}

Status IsAscending(Triplet T)
{
    return (T[0]<=T[1])&&(T[1]<=T[2]);
}

Status IsDescending(Triplet T)
{
    return (T[0]>=T[1])&&(T[1]>=T[2]);
}

Status MAX(Triplet T, ElemType *e)
{
    *e=(T[0]>=T[1])?((T[0]>=T[2])?T[0]:T[2]):((T[1]>=T[2])?T[1]:T[2]);
    return OK;
}

Status MIN(Triplet T, ElemType *e)
{
    *e=(T[0]<=T[1])?((T[0]<=T[2])?T[0]:T[2]):((T[1]<=T[2])?T[1]:T[2]);
    return OK;
}
int main()
{
    Triplet T;
    printf("*T=%d, T=%p\n", *T, T);
    ElemType e;
    InitTriplet(&T, 233, 45, 888);
    printf("%d %d %d\n", T[0], T[1], T[2]);
    printf("Get(T, 2, &e): %d, %d\n", Get(T, 2, &e), e);
    printf("Put(T, 2, 666): %d, %d\n", Put(T, 2, 666), T[2]);
    printf("IsAscending(T):%d\n", IsAscending(T));
    printf("IsDescending(T):%d\n", IsDescending(T));
    printf("MAX(T, &e):%d, %d\n", MAX(T, &e), e);
    printf("MIN(T, &e):%d, %d\n", MIN(T, &e), e);
    DestroyTriplet(T);
    return 0;
}

