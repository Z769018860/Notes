// 第3次作业-- -

//第5章数组与广义表：5 .1, 5.8, 5.11, 5.12, , 5.15； 5.19, 5.20, 5.25, 5.27, 5.37

//Using ADT_Code Project
//https://github.com/L-F-Z/ADT_Code
//Member of UCAS ADT_Code Group
//https://github.com/AugustusWillisWang
//Compiled by g++ with parameter - std = c++ 11

#include <iostream>
#include <vector>
#include <stack>
#include <string>
#include <utility> //pair
#include <exception>
#include <cstring>
#include <cstdlib>

#include "adt_license.h"
#include "dbg.h"

using namespace std;

//5.19 若矩阵Am×n中的某个元素aij是第i行中的最小值，同时又是第j列中的最大值，则称此元素为该矩阵中的一个马鞍点。假设二维数组存储矩阵Am×n，试编写求出矩阵中所有马鞍点的算法，并分析你的算法在最坏情况下的时间复杂度。

// 复杂度O(m*n)

#include <limits>

#ifndef INT_MAX
#define INT_MAX 2147483647
#endif

std::vector<pair<int, int>> FindPoint(int *array, int m, int n)
{
    // array[a][b] = *(array + m * a + b);
    std::vector<pair<int, int>> result;
    std::vector<pair<int, int>> need_search;
    pair<int, int> point;
    for (int b = 0; b < n; b++)
    {
        int min = INT_MAX;
        int minp = -1;
        for (int a = 0; a < m; a++)
        {
            if (*(array + m * a + b) < min)
            {
                minp = a;
                min = *(array + m * a + b);
                point.first = a;
                point.second = b;
                need_search.push_back(point);
            }
        }
    }
    int c = need_search.size();
    for (int i = c - 1; i >= 0; i--)
    {
        int max = *(array + m * result[i].first + result[i].second);
        for (int p = 0; p < n; p++)
        {
            if ((m * result[i].first + result[i].second) > max)
            {
                result.erase(result.begin() + i);
                break;
            }
        }
    }
    return result;
}

//5.20 类似于以一维数组表示一元多项式，以m维数组：（aj1j2…jm），0≤ji≤n，i=1，2，…，m，表示m元多项式，数组元素ae1e2…em表示多项式中x1e1x2e2…xmem的系数。例如，和二元多项式x2+3xy+4y2-x+2相应的二维数组为：

//试编写一个算法将m维数组表示的m元多项式以常规表示的形式（按降幂顺序）输出。可将其中一项ckx1e1x2e2…xmem印成ckx1Ee1x2Ee2…xmEem（其中m，ck和ej（j = 1，2，…，m）印出它们具体的值），当ck或ej（j = 1，2，…，m）为1时，ck的值或“E”和ej的值可省略不印。
typedef int *Poly; //多项式数组

string alphatable = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; //多项式字母元, 超过26的自己去加吧

int next(int *position, int m, int n) //按降幂取得下一个元素(单项式)
//注意要从(-1)元素开始枚举
//引入:
// position[m - 1]++;
{
    //start from m
    while (1)
    {
        if (position[m] > 0)
        {
            position[m]--;
            return 1; //still have next to go
        }
        else
        {
            if (m == 0) //m can not --;
                return 0;
            position[m] = n + 1;
            --m;
        }
    }
}

int position_to_addr(int *position, int m, int n) //将position数组转化为一维数组下标
{
    int t = 0;
    int result = 0;
    while (t < m)
    {
        result *= m;
        result += position[t];
        ++t;
    }
    return result;
}

int position_next(int *position, int m, int n, int *src) //return 1 if have next, return 0 if finished. //将position移动到下一位
{
    if (next(position, m, n))
    {

        while (!src[position_to_addr(position, m, n)])
        {
            if (next(position, m, n))
            {
                ;
            }
            else
            {
                return 0;
            }
        }
    }
    else
    {
        return 0;
    }
    return 1;
}

int print_term(int *position, int m, int n, int *src) //打印单项式
{
    std::cout << src[position_to_addr(position, m, n)];
    for (int p = 0; p < m; p++)
    {
        if (position[p])
        {
            std::cout << alphatable[p] << position[p];
        }
    }
    std::cout << std::endl;
}

int Printpoly(Poly src, int m, int n) //主函数
{
    int position[m];
    for (int i = 0; i < m; i++)
    {
        position[i] = n + 1;
    }
    //start
    position[m - 1]++;
    if (position_next(position, m, n, src)) //取得下一个非空多项式
    {
        print_term(position, m, n, src); //打印
    }
    else
    {
        std::cout << "0" << std::endl; //若所有单项式均为空
    }
    while (position_next(position, m, n, src))
    {
        std::cout << "+"; //以后每一个非空多项式之前+'+';
        print_term(position, m, n, src);
    }
}
//5.25 若将稀疏矩阵A的非零元素以行序为主序的顺序存于一维数组V中，并用二维数组B表示A中的相应元素是否为零元素（以0和1分别表示零元素和非零元素）。例如，

// 可用V = (15, 22, -6, 9)和表示。
// 试写一算法，实现在上述表示法中实现矩阵相加的运算。并分析你算法的时间复杂度。

//对于m*n matrix 复杂度为O(m*n)
typedef struct Mmatrix
{
    int m;
    int n;
    int *mark;
    vector<int> data; //在纯c中可用链表或一个大数组实现, 其可以在末尾以O(1)添加元素
} * pmmatrix;

// #include <cstdlib>
pmmatrix MmatrixAdd(pmmatrix A, pmmatrix B)
{
    pmmatrix r = new struct Mmatrix;
    r->m = A->m;
    r->n = A->n;
    int size = r->m * r->n;
    r->mark = new int[size];
    int Acnt = 0;
    int Bcnt = 0;
    for (int i = 0; i < size; i++)
    {
        if (A->mark[i])
        {
            r->mark[i] = 1;
            if (B->mark[i])
            {
                r->data.push_back(A->data[Acnt++] + B->data[Bcnt++]);
            }
            else
            {
                r->data.push_back(A->data[Acnt++]);
            }
        }
        else if (B->mark[i])
        {
            r->mark[i] = 1;
            r->data.push_back(B->data[Bcnt++]);
        }
        else
        {
            r->mark[i] = 0;
            //pass
        }
    }
}

//5.27 试按教科书5.3.2节中定义的十字链表存储表示编写将稀疏矩阵B加到稀疏矩阵A上的算法

//0 1 2 3 4 5 n
//1
//2
//m

typedef struct CLTMnode
{
    int data;
    int m;
    int n;
    struct CLTMnode *mnext;
    struct CLTMnode *nnext;
} node, *pnode;

typedef struct CrossLinkTableMatrix
{
    int m;
    int n;
    pnode *mstart; //-->nnext
    pnode *nstart; //-->mnext
} matrix, *pmatrix;

int AddElement(pmatrix A, int data, int m, int n) //添加单个元素
{
    pnode t;
    if (A->mstart[m])
    {
        t = A->mstart[m];
        while (t->n < n && t->nnext != 0)
        {
            t = t->nnext;
        }
        if (t->nnext && t->nnext->n == n)
        {
            t->nnext->data += data;
            return 0;
        }
        else
        {
            pnode p = t->nnext;
            t->nnext = new node;
            t = t->nnext;
            t->nnext = p;
            t->data = data;
            t->m = m;
            t->n = n;
        }
    }
    else
    {
        A->mstart[m] = new node;
        A->mstart[m]->nnext = 0;
        A->mstart[m]->data = data;
        A->mstart[m]->m = m;
        A->mstart[m]->n = n;
        t = A->mstart[m];
    }
    //add t into nlink;
    if (A->nstart[n])
    {
        pnode l = A->mstart[m];
        while (l->m < m && t->mnext != 0)
        {
            l = l->mnext;
        }
        if (l->mnext && t->mnext->m == m)
        {
            return 1; //sth may be error
        }
        else
        {
            pnode p = l->mnext;
            l->mnext = t;
            l->mnext->mnext = p;
        }
    }
    else
    {
        A->nstart[n] = t;
        return 0;
    }
}

int MatrixAdd(pmatrix A, pmatrix B, int m, int n) //全部添加
{
    for (int l = 0; l < m; l++)
    {
        auto k = B->mstart[m];
        while (k)
        {
            AddElement(A, k->data, k->m, k->n);
            k = k->nnext;
        }
    }
}

//5.37 试编写递归算法，删除广义表中所有值等于x的原子项。

enum nodetype
{
    data,
    sub
};

typedef struct glist
{
    struct glist *next;
    union {
        struct glist *sub;
        int data;
    };
    enum nodetype type;
} glist, *pglist;

int GlistDelete(pglist tgt, int x)
//We suppose that each glist has a head node
//In this function, delete work will be done recursively
{
    while (tgt->next)
    {
        if (tgt->next->type == data)
        {
            if (data == x)
            {
                pglist t = tgt->next->next;
                delete tgt->next;
                tgt->next = t;
            }
        }
        else
        {
            GlistDelete(tgt->next->sub, x);
        }
        tgt = tgt->next;
    }
    return 0;
}

int main()
{
}