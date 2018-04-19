// 第3次作业-- -
//     第4章串 : 4.3,
//     4.4, 4.8； 4.BLOCKLENGTH, 4.11, 4.16, 4.17, , 4.23, 4.29, 4.30 第5章数组与广义表：5 .1, 5.8, 5.11, 5.12, , 5.15； 5.19, 5.20, 5.25, 5.27, 5.37

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

//在编写4 .BLOCKLENGTH至4.14题的算法时，请采用StringType数据类型：
//
//    StringType是串的一个抽象数据类型，它包含以下五种基本操作：
//
//    void
//    StrAssign(StringType &t, StringType s);
//　 //将s的值赋给t。s的实际参数可以是串变量或者串常量（如：‘abcd’）。
//
//    int
//    StrCompare(StringType s, StringType t);
//　　 //比较s和t。若s>t，返回值>0；若s=t，返回值=0；若s<t，返回值<0。
//
//    int
//    StrLength(StringType s);
//　　　　　　　　　　 //返回s中的元素个数，即该串的长度。
//
//    StringType
//    Concat(StringType s, StringType t); //返回由s和t联接而成的新串。
//
//StringType SubString(StringType s, int start, int len); //当1≤start≤StrLength(s)且0≤len≤StrLength(s)-start+1时，返回s中第start个字符起长度为len的子串，否则返回空串。

typedef char *StringType;

int StrLength(StringType s) //返回s中的元素个数，即该串的长度。
{
    int i = 0;
    while (s[i])
        i++;
    return i;
}

int StrLength(const char *s) //返回s中的元素个数，即该串的长度。
{
    int i = 0;
    while (s[i])
        i++;
    return i;
}

void StrAssign(StringType &t, StringType s) //将s的值赋给t。s的实际参数可以是串变量或者串常量（如：‘abcd’）。
{
    int l = StrLength(s);
    t = new char[sizeof(char) * (l + 1)];
    std::memcpy(t, s, l + 1);
}

void StrAssign(StringType &t, const char *s) //将s的值赋给t。s的实际参数可以是串变量或者串常量（如：‘abcd’）。
{
    int l = StrLength(s);
    t = new char[sizeof(char) * (l + 1)];
    std::memcpy(t, s, l + 1);
}

int StrCompare(StringType s, StringType t) //比较s和t。若s>t，返回值>0；若s=t，返回值=0；若s<t，返回值<0。
{
    int i = 0;
    while (s[i] != 0 && t[i] != 0)
    {
        if (s[i] != t[i])
            return s[i] - t[i];
        ++i;
    }
    return 0;
}

StringType Concat(StringType s, StringType t) //返回由s和t联接而成的新串。
{
    int ls = StrLength(s);
    int lt = StrLength(t);
    int i = ls + lt;
    char *s0 = s;
    s = new char[ls + lt + 1];
    std::memcpy(s, s0, ls);
    std::memcpy(s + ls, t, lt + 1);
    return s;
}

//函数定义已被修改
StringType SubString(StringType s, int start, int len) //当1≤start≤StrLength(s)且0≤len≤StrLength(s)-start+1时，返回s中第start个字符起长度为len的子串，否则返回空串。
{
    int lens = StrLength(s);
    if (start > (lens - len))
        return nullptr;
    StringType t = new char[len + 1];
    t[len] = 0;
    std::memcpy(t, s + start, len);
    return t;
}

//4.BLOCKLENGTH 编写对串求逆的递推算法。
int Reverse(StringType &s)
{
    int l = StrLength(s);
    int k = (l - 1) / 2;
    char t;
    for (int i = 0; i <= k; i++)
    {
        t = s[i];
        s[i] = s[l - 1 - i];
        s[l - 1 - i] = t;
    }
    return 0;
}

#include <cstdio>

ostream &operator<<(ostream &o, StringType a)
{
    std::printf("%s", a);
    return o;
}

// 4.11
// 编写算法，求得所有包含在串s中而不包含在串t中的字符（s中重复的字符只选一个）构成的新串r，以及r中每个字符在s中第一次出现的位置
struct result4_11
{
    StringType R;
    vector<int> a;
};

// #include<queue>
#include <set>
struct result4_11 A_4_11(StringType s, StringType t)
{
    vector<char> res;
    vector<int> array;
    for (int a = 0; s[a]; a++)
    {
        for (int b = 0; t[b]; b++)
        {
            if (s[a] == t[b])
                goto end;
        }
        for (int c = 0; c < res.size(); c++)
        {
            if (s[a] == res[c])
                goto end;
        }
        res.push_back(s[a]);
        array.push_back(a);

    end:;
    }
    res.push_back(0);
    struct result4_11 result;
    result.R = new char[res.size()];
    for (int c = 0; c < res.size(); c++)
    {
        result.R[c] = res[c];
    }
    result.a = array;
    return result;

}

//4.16
//编写算法，实现串的基本操作StrCompare(S, T)。

//int StrCompare(StringType s, StringType t) //比较s和t。若s>t，返回值>0；若s=t，返回值=0；若s<t，返回值<0。
//{
//    int i = 0;
//    while (s[i] != 0 && t[i] != 0)
//    {
//        if (s[i] != t[i])
//            return s[i] - t[i];
//        ++i;
//    }
//    return 0;
//}

//4.17
//编写算法，实现串的基本操作Replace(&S, T, V)。

int
CompareChar(StringType S, StringType T)
{
    int t = 0;
    while (T[t])
    {
        if (S[t] != T[t] && S[t])
            return 0;
        t++;
    }
    return t;
}

int Find_Trival(StringType S, StringType T)
{
    int ls = StrLength(S);
    int lt = StrLength(T);
    for (int a = 0; a < ls; a++)
    {
        if (CompareChar(S + a, T))
            return a;
    }
    return -1;
}

int Repalce(StringType &S, StringType T, StringType V)
{
    int place = Find_Trival(S, T);
    int ls = StrLength(S);
    int lt = StrLength(T);
    int lv = StrLength(V);
    if (place == -1)
        return -1;
    StringType Q = S;
    S = new char[ls - lt + lv + 1];
    memcpy(S, Q, ls);
    memcpy(S + place, V, lv);
    memcpy(S + place + lv, Q + place + lt, ls - lt - place + 1);
}

    //4.23
    //假设以块链结构作串的存储结构。试编写判别给定串是否具有对称性的算法，并要求算法的时间复杂度为O(StrLength(S))。

#define BLOCKLENGTH 10

typedef struct BlockString
{
    char data[BLOCKLENGTH];
    struct BlockString *next;
} * BS, nBS;

BS SetupBS(const char *src)
{
    BS result = new nBS;
    BS current = result;
    int cnt = 0;
    int blkcnt = 0;
    while (src[cnt])
    {
        if (blkcnt == BLOCKLENGTH)
        {
            blkcnt = 0;
            current->next = new nBS;
            current = current->next;
        }
        current->data[blkcnt] = src[cnt];
        ++blkcnt;
        ++cnt;
    }
    {
        if (blkcnt == BLOCKLENGTH)
        {
            blkcnt = 0;
            current->next = new nBS;
            current = current->next;
        }
        current->data[blkcnt] = src[cnt];
        ++blkcnt;
        ++cnt;
    }

    return result;
}

int ShowBS(BS src)
{
    int cnt = 0;
    char r;
    while (1)
    {
        if (cnt == BLOCKLENGTH)
        {
            cnt = 0;
            src = src->next;
        }
        r = src->data[cnt];
        if (!r)
            return 0;
        printf("%c", r);
        cnt++;
    }
}

#include <list>

int IsMirrorBS(BS src)
{
    list<char> l;
    int cnt = 0;
    char r;
    while (1)
    {
        if (cnt == BLOCKLENGTH)
        {
            cnt = 0;
            src = src->next;
        }
        r = src->data[cnt];
        if (!r)
            break;
        l.push_back(r);
        cnt++;
    }

    //judge
    while ((!l.empty()) && (l.size() != 1))
    {
        // cout << l.front() << l.back() <<"poi" <<endl;
        if (l.front() != l.back())
            return 0;
        l.pop_back();
        l.pop_front();
    }
    return 1;
}

//4.28
//假设以结点大小为1（带头结点）的链表结构表示串，则在利用next函数值进行串匹配时，在每个结点中需设三个域：数据域chdata、指针域succ和指针域next。其中chdata域存放一个字符；succ域存放指向同一链表中后继结点的指针；next域在主串中存放指向同一链表中前驱结点的指针；在模式串中，存放指向当该结点的字符与主串中的字符不等时，在模式串中下一个应进行比较的字符结点（即与该字符的next函数值相对应的字符结点）的指针，若该节点字符的next函数值为0，则其next域的值应指向头结点。试按上述定义的结构改写求模式串的next函数值的算法。

typedef struct KmpLinkStringNode
{
    struct KmpLinkStringNode *next;
    struct KmpLinkStringNode *kmp_next;
    char data;
} * KLS, nKLS;

KLS InitKLS(const char *src)
{
    KLS result = new nKLS;
    KLS current_point = result;
    int i = 0;
    while (src[i])
    {
        current_point->next = new nKLS;
        current_point = current_point->next;
        current_point->data = src[i];
        i++;
    }
    current_point->next = new nKLS;
    current_point = current_point->next;
    current_point->data = 0;
    current_point->next = 0;
    return result;
}

int ShowKLS(KLS src)
{
    if (src && src->next)
    {
        src = src->next;

        while (src)
        {
            printf("%c", src->data);
            src = src->next;
        }
        printf("\n");
        return 0;
    }
    return -1;
}

int InitNext(KLS src)
{
    KLS i, j;
    if (!i)
        return -1;
    i = src->next;
    j = src;
    while (i)
    {
        if (j == src || j->data == i->data)
        {
            i = i->next;
            j = j->next;
            if (j->data == i->data)
            {
                i->kmp_next = j->kmp_next;
            }
            else
            {
                i->kmp_next = j;
            }
        }
        else
        {
            j = j->kmp_next;
        }
    }
}

//4.29
//试按4.28题定义的结构改写串匹配的改进算法（KMP算法）。
int LengthKLS(KLS src)
{
    int cnt = 0;
    while (src->next)
        cnt++;
    return cnt;
}

int KLSkmp_rint(KLS src, KLS sub)
{
    int lensub = LengthKLS(sub);
    int cnt = 0;
    KLS i = src->next;
    KLS j = sub;
    while(i!=nullptr)
    {
        if(j==sub||i->data==j->data)
        {
            i=i->next;
            ++cnt;
            j = j->next;
            if(j->data==0)
                return cnt - lensub;
        }else{
            j = j->next;
        }
    }
    return -1;
}

//4.30
//假设以定长顺序存储结构表示串，试设计一个算法，求串s中出现的第一个最长重复子串及其（第一次出现的）位置，并分析你的算法的时间复杂度。

struct result_4_30
{
    int posi;
    char *str;
};

struct result_4_30 A_4_30_trival(char* src)
{
    int len = strlen(src);
    
}

int
main()
{
    StringType a;
    StrAssign(a, "123444456789999");
    cout << StrLength(a) << endl
         << Reverse(a) << endl
         << a << endl;

    StringType b;
    StrAssign(b, "23456");
    auto result = A_4_11(a, b);
    cout << result.R << endl;
    for (int i = 0; i < result.a.size(); i++)
    {
        cout << result.a[i] << endl;
    }

    BS p = SetupBS("1234567890123456789012345678901");
    ShowBS(p);
    BS p2 = SetupBS("1234567890987654321");
    ShowBS(p2);
    cout << endl
         << IsMirrorBS(p) << endl
         << IsMirrorBS(p2) << endl;
}
