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
typedef int *Poly;

int Printpoly(Poly src, int m, int n)
{
    int position[m];
    for (int i = 0; i < m; i++)
    {
        position[i] = n;
    }
    //start
    if (position_next())
    {
        print_term(position);
    }
    else
    {
        std::cout << "0" << std::endl;
    }
    while (position_next(position))
    {
        std::cout << "+";
        print_term(position);
    }
}

int position_next()
{
    
}

    //5.25 若将稀疏矩阵A的非零元素以行序为主序的顺序存于一维数组V中，并用二维数组B表示A中的相应元素是否为零元素（以0和1分别表示零元素和非零元素）。例如，

    // 可用V = (15, 22, -6, 9)和表示。

    // 试写一算法，实现在上述表示法中实现矩阵相加的运算。并分析你算法的时间复杂度。

    //5.27 试按教科书5.3.2节中定义的十字链表存储表示编写将稀疏矩阵B加到稀疏矩阵A上的算法

    //5.37 试编写递归算法，删除广义表中所有值等于x的原子项。