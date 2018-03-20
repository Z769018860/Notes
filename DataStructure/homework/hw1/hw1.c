//Data Structure HW1 by AW

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include "lazy.h"

#define SUCCEED 1
#define ERROR 0

int swap(int *a, int *b)
{
    int t = *a;
    *a = *b;
    *b = t;
    return SUCCEED;
}

int aswap(int *array, int a, int b)
{
    int t = array[a];
    array[a] = array[b];
    array[b] = t;
    return SUCCEED;
}

int mqsort(int *array, int start, int end)
{
    if (start >= end)
        return SUCCEED;
    int mid = (start + end) / 2;
    aswap(array, start, mid);
    int p = start + 1;
    int s = start + 1;
    while (s <= end)
    {
        if (array[s] > array[start])
        {
            aswap(array, s, p);
            p++;
            s++;
        }
        else
        {
            s++;
        }
    }
    aswap(array, start, p - 1);
    mqsort(array, start, mid - 1);
    mqsort(array, mid + 1, end);
    return SUCCEED;
}

int a_1_16()
{
    int a[3];
    scanf("%d%d%d", &a[0], &a[1], &a[2]);
    mqsort(a, 0, 2);
    printf("%d %d %d/n", a[0], a[1], a[2]);
    return SUCCEED;
}

int a_1_17(int k, int m)
{
    if (k <= 0 || m < 0)
        return -1; //ERROR
    if (m < k)
        return 0;
    int t[m + 1];
    // int *t = (int *)malloc(sizeof(int) * (m + 1));
    for (int i = 0; i < (k - 1); i++)
        t[i] = 0;
    t[k - 1] = 1;

    int p = k;
    while (p <= m)
    {
        t[p] = 0;
        for (int i = 1; i <= k; i++)
        {
            t[p] += t[p - i];
        }
        p++;
    }
    SHOWALL(t, "int");
    return t[m];
}

int a_1_18()
{

#define MALE 1
#define FEMALE 2

    int num = 0;
    puts("Input length plz:");
    scanf("%d", &num);
    if (num < 1)
        return ERROR;

    // char temp[20];

    typedef struct record
    {
        char name[30];
        int sex;
        char school[30];
        int time;
        int score;
    } Record;

    typedef struct srecord
    {
        char school[30];
        int fscore;
        int mscore;
    } SRecord;

    Record *table = (Record *)malloc(sizeof(Record) * num);
    SRecord *stable = (SRecord *)calloc(num, sizeof(SRecord));

    while (num--)
    {
        puts("Input gamename gender(male:1, female:2) schoolname time score");
        scanf("%s", &table[num].name);
        scanf("%d", &table[num].sex);
        scanf("%s", &table[num].school);
        scanf("%d", &table[num].time);
        scanf("%d", &table[num].score);

        // huaji 1 ucas 10 20
        // dahuaji 1 thu 10 21
        // feichanghuaji 1 ucas 10 22

        int p = 0;
        while (strcmp(table[num].school, stable[p].school) && strcmp(stable[p].school, "")) //if not match or not empty
        {
            p++;
        }
        if (!strcmp(stable[p].school, "")) //this school not in the list
        {
            strcpy(stable[p].school, table[num].school);
        }
        if (table[num].sex == MALE)
            stable[p].mscore += table[num].score;
        else
            stable[p].fscore += table[num].score;
    }

    int p = 0;
    printf("\n----------------------\nschool\tmscore\tfscore\tscore\n");
    while (strcmp(stable[p].school, "")) //not empty
    {
        printf("%s\t%d\t%d\t%d\n", stable[p].school, stable[p].mscore, stable[p].fscore, stable[p].fscore + stable[p].mscore);
        p++;
    }
    free(table);
    free(stable);
}

int a_1_19(int *array, int size)
{
#define MAXINT unknown
    //return -1 means invalid parameter, return 0 means succeed, return positive number means overflow at this position
    if (!array || size < 1)
        return -1;
    int ret = 0;
    int f = 1;
    int p = 1;
    while (ret < size)
    {
        array[ret] = f * p;
        ret++;
        int temp = f * p;
        f *= ret;
        p *= 2;
        if (f*p<=temp)//means overflow occurred   todo
            return ret;
    }
    if (ret >= size)
        return ret;
    return 0;
}

//no dug yet

double a_1_20()
{
    int term = 0;
    double x = 0;
    puts("Input number of terms, x:");
    scanf("%d%lf", &term, &x);
    if (term <= 0)
    {
        puts("error\n");
        return 0;
    }
    double sum = 0;
    double a, b;
    for (int i = 0; i < term; i++)
    {
        puts("Input a and pow:");
        scanf("%lf%lf", &a, &b);
        sum += a * pow(x, b); //run term times
    }
    printf("Result is:%lf\n", sum);
    return sum;
}

int a_2_11(int *array, int size, int elem, int num)
{
    int i;
    if (elem >= size)
        return ERROR;
    while (num < array[i] && i < elem)
    {
        i++;
    }
    //i is the place to add new elem in
    for (int b = elem; b > i; b--)
    {
        array[b] = array[b - 1];
    }
    array[i] = num;
    return 0;
}

int a_2_12(int *a, int *b, int maxsize)
{
    int i = 0;
    while (*a == *b && i < maxsize)
    {
        a++;
        b++;
        i++;
    }
    if (*a == 0 && *b == 0)
        return 0;
    else if (*a == 0)
        return -1; //<
    else if (*b == 0)
        return 1; //>
    if (*a < *b)
        return -1; //<
    else if (*a > *b)
        return 1; //>
}

#include "linklist.c"

pLnode a_2_15(pLnode h1, pLnode h2, int l1, int l2)
//O(min(m,n)+1), head node is empty node
{
    if (!h1 || !h2 || l1 < 0 || l2 < 0)
        return NULL;
    pLnode h3;
    if (l1 > l2)
        ;
    else
    {
        h3 = h2;
        h1 = h2;
        h2 = h3;
    }
    h3 = h1;
    while(h3->next) { h3 = h3->next; }
    h3->next = h2->next;
    free(h2);
    return h3;
}

typedef struct hw1_NHeadLinklistNode
{
    int data;
    struct hw1_NHeadLinklistNode *next;
} hw1_nhln, *phw1_nhln;

int a_2_18(phw1_nhln L, int i)
//the difference is the initial value of cnt;
{
    int cnt = 1;
    while (cnt < (i - 1) && L->next)
        cnt++;
    L = L->next;

    if (i == (cnt - 1))
    {
        if (L->next)
        {
            free(L->next);
            L->next = 0;
            return SUCCEED;
        }
        return ERROR;
    }
    return ERROR;
}

int a_2_19(pLnode L, int mink, int maxk)
{

    pLnode p;
    pLnode t;
    while (L->next->data <= mink && L->next)
    {
        L = L->next;
    }
    p = L;                       //l->next may e deleted
    L = L->next;                 //cut down the number used for --->next
    while (L->data <= maxk && L) //will be deleted
    {
        t = L;
        L = L->next;
        free(t);
    }
    p->next = L;
    return SUCCEED;
}

int a_2_22(pLnode L)
{
    LinklistTranspose(L);
}

int a_2_29(int *a, int *b, int *c, int la, int lb, int lc)
{
    //return new size for a
    if (la < 1 || lb < 1 || lc < 1)
        return -1;                              //error
    int *mark = (int *)calloc(la, sizeof(int)); //mark if a position is empty
    int pa, pb, pc = 0;                         //point at current position in list;
    // px = lx means it is already done;
    for (pa = 0; pa < la; pa++)
    {
        if (pa == la || pb == lb || pc == lc)
            break;
        while (b[pb] < a[pa] && pb < lb)
            pb++;
        while (c[pc] < a[pa] && pc < lc)
            pc++;
        //b[pb],c[pc] no less ta=han a[pa]
        if (a[pa] == b[pb] && a[pa] == c[pc])
            mark[pa] = 1;
    }
    int pd = 0;
    pa = 0;
    for (; pa < la; pa++)
    {
        while (mark[pd] && pd < la)
            pd++;
        if (pd == la)
            break;
        a[pa++] = a[pd++];
    }
    return pa;
}

#include"a_2_38.h"

int a_2_38()
{
    
}

struct PolyTerm
{
    int coefficient;
    int exponent;
};

typedef struct PolyNode
{
    struct PolyTerm data;
    struct PolyNode *next;
} PolyNode, *PolyLink;

typedef PolyLink LinkedPoly;

int _delnodecir(PolyLink before, PolyLink current)
{
    if (before || current == 0)
        return ERROR;
    before->next = current->next;
    free(current);
    return SUCCEED;
}

PolyLink a_2_41(LinkedPoly poly)
{
    PolyLink start = poly;
    PolyLink before = poly;
    PolyLink current = poly->next;
    do
    {
        poly->data.coefficient *= poly->data.exponent;
        poly->data.coefficient--;
        if (poly->data.coefficient)
        {
            before = current;
            current = current->next;
        }
        else // 0 term
        {
            _delnodecir(before, current);
            current = before->next;
        }
    } while (current != start);
    {
        poly->data.coefficient *= poly->data.exponent;
        poly->data.coefficient--;
        if (poly->data.coefficient)
        {
            before = current;
            current = current->next;
        }
        else // 0 term
        {
            _delnodecir(before, current);
            current = before->next;
        }
    }
    return current;
}

int main()
{
    int a[] = {1, 7, 3, 9, 2};
    mqsort(a, 0, 4);
    printf("%d %d %d\n", a[0], a[1], a[2]);

    printf("%d\n", a_1_17(2, 5));

    a_1_18();
    int *b = (int *)malloc(sizeof(int) * 100);
    a_1_19(b, 100);
    a_1_20();
    return 0;
}
