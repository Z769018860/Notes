//Using ADT_Code Project
//https://github.com/L-F-Z/ADT_Code
//Member of UCAS ADT_Code Group
//https://github.com/AugustusWillisWang
//Compiled by g++ with parameter - std = c++ 11

//都写了ADT了我也就不客气了, 直接上STL, 嗯喵.

#include <iostream>
#include <vector>
#include <stack>
#include <string>
#include <utility> //pair
#include <exception>

#include "adt_license.h"
#include "dbg.h"

// 第6章树和二叉树： 6.2, 6.5, 6.18, 6.20, 6.31；
// 6.33, 6.34, 6.37, 6.43, 6.48, 6.49, 6.51, 6.58, 6.65, 6.71

// 6.33 假定用两个一维数组L [n + 1] 和R[n + 1] 作为有n个结点的二叉树的存储结构，L[i] 和r[i] 分别指示结点i（i = 1, 2,…, n）的左孩子和右孩子，0表示空。试写一个算法判别结点u是否为结点v的子孙。

template <class T, int size>
class Bintree33
{
    T data[size];
    int L[size];
    int R[size];
    int P[size];
};
//-1 means have no link

template <class T, int size>
bool IsSon(Bintree33<T, size> src, int u, int v) //u is v's son
{
    if (src.L[v] == u || src.R[v] == u)
    {
        return true;
    }
    else
    {
        return false;
    }
}

// 6.34 同6.33题的条件。先由L和R建立一维数组T[n + 1] ，使T中第i（i = 1,2,…, n）个分量指示结点i的双亲，然后写判别结点u是否为结点v的子孙的算法。

template <class T, int size>
bool SetupParent(Bintree33<T, size> src, int u, int v) //u is v's son
{
    for (int i = 0; i < size; i++)
    {
        src.P[i] = -1; //-1 means not exist;
    }
    for (int i = 0; i < size; i++)
    {
        if (src.L[i] != -1)
            src.P[src.L[i]] = i;
        if (src.R[i] != -1)
            src.P[src.R[i]] = i;
    }
}

template <class T, int size>
bool IsSon2(Bintree33<T, size> src, int u, int v) //u is v's son
{
    if (src.P[u] == v)
        return true;
    return false;
}

// 在以下6.36至6.38和6.41至6.53题中，均以二叉链表作为二叉树的存储结构。

// 二叉树的二叉链表

typedef struct bintreenode
{
    int data;
    struct bintreenode *left;
    struct bintreenode *right;
    struct bintreenode *parent; //may not be used

    char type; //for 6.51 type==0(num) '+-*/'
} bnode, *pbnode;

// 6.37 试利用栈的基本操作写出先序遍历的非递归形式的算法。

#include <stack>
int traverse37(pbnode tgt, void func(int data))
{
    using namespace std;
    stack<pbnode> s;
    s.push(tgt);
    while (!s.empty())
    {
        func(s.top()->data);
        auto t = s.top();
        s.pop();
        if (t->left)
            s.push(t->left);
        if (t->right)
            s.push(t->right);
    }
    return 0;
}

// 6.43 编写递归算法，将二叉树中所有结点的左、右子树相互交换。

//使用后序遍历

int Algo_6_43(pbnode tgt)
{
    auto t = tgt;
    if (t->left)
        Algo_6_43(t->left);
    if (t->right)
        Algo_6_43(t->right);

    auto t2 = t->left;
    t->left = t->right;
    t->right = t2;

    return 0;
}

// 6.48 已知在二叉树中，*root为根结点，*p和*q为二叉树中两个结点，试编写求距离它们最近的共同祖先的算法。

// 单独查找比较简单
//多数据查找使用Tarjin算法, 其利用了后序遍历本身的性质.

int SetParent(pbnode tgt, pbnode parent = 0)
{
    tgt->parent = parent;
    if (tgt->left)
        SetParent(tgt->left, tgt);
    if (tgt->right)
        SetParent(tgt->right, tgt);
}

#include <queue>
pbnode FindAnscester(pbnode root, pbnode p, pbnode q)
{
    using namespace std;
    SetParent(root);
    vector<pbnode> pf;
    vector<pbnode> qf;
    while (p)
    {
        pf.push_back(p);
        p = p->parent;
    }
    while (q)
    {
        qf.push_back(q);
        q = q->parent;
    }
    int sp = pf.size();
    int sq = qf.size();
    for (int i = 0; i++; i < sp)
    {
        for (int j = 0; j++; j < sq)
        {
            if (pf[i] == qf[j])
            {
                return pf[i];
            }
        }
    }
}

// 6.49 编写算法判别给定二叉树是否为完全二叉树。

int Nodecnt(pbnode tgt)
{
    if (tgt)
    {
        int res = 1;
        if (tgt->left)
        {
            res += Nodecnt(tgt->left);
        }
        if (tgt->right)
        {
            res += Nodecnt(tgt->right);
        }
        return res;
    }
    return 0;
}

bool IsFullBintree(pbnode tgt)
{
    using namespace std;
    queue<pbnode> s;
    int power = 1;
    int cnt = 0;
    s.push(tgt);
    while (!s.empty())
    {
        for (int i = 0; i < power; i++)
        {
            if (s.front())
            {
                s.push(s.front()->left);
                s.push(s.front()->right);
                s.pop();
                cnt++;
            }
            else
            {
                break;
            }
        }
        power *= 2;
    }
    return Nodecnt(tgt) == cnt;
}

// 6.51 编写一个算法，输出以二叉树表示的算术表达式，若该表达式中含有括号，则在输出时应添上。

std::string operators = "+-*/";
//数字: 无需()
//左子树, 同级: 无需()
//左子树, 高级: 无需()
//左子树, 低级: ()
//右子树, 高级: 无需()
//右子树, 同级: ()
//右子树, 低级: ()
int OperatorCompare(char a, char b)
{
    if (a == '+' || a == '-')
    {
        if (b == '+' || b == '-')
        {
            return 0; //a=b
        }
        else
        {
            return -1; //a<b
        }
    }
    else
    {
        // (a=='*'||a=='/')
        if (b == '+' || b == '-')
        {
            return 1; //a>b
        }
        else
        {
            return 0; //a=b
        }
    }
}

int PrintExp(pbnode src)
{
    //use data as char
    using namespace std;
    //中序遍历
    if (src)
    {
        if (src->type == 0)
        {
            cout << src->data;
            return 0;
        }
        //left
        if (src->left)
        {
            if (src->left->type == 0) //number
            {
                cout << src->left->data;
            }
            else //exp
            {
                if (OperatorCompare(src->left->type, src->type) == -1)
                {
                    cout << "(";
                    PrintExp(src->left);
                    cout << ")";
                }
                else
                {
                    PrintExp(src->left);
                }
            }
        }
        //middle
        printf("%c", src->type);
        //right
        if (src->right)
        {
            if (src->right->type == 0) //number
            {
                cout << src->right->data;
            }
            else //exp
            {
                if (OperatorCompare(src->right->type, src->type) == 1)
                {
                    PrintExp(src->right);
                }
                else
                {
                    cout << "(";
                    PrintExp(src->right);
                    cout << ")";
                }
            }
        }
    }
    else
    {
        return 0;
    }
}

    // 6.58 试写一个算法，在中序全线索二叉树的结点*p之下，插入一棵以结点*x为根、只有左子树的中序全线索二叉树，使*x为根的二叉树称为*p的左子树。若*p原来有左子树，则令它为*x的右子树。完成插入之后的二叉树应保持全线索化特性。

    //todo: review 线索二叉树

#define LINK 0
#define NODE 1

typedef struct TraceBintree
{
    int data;
    struct TraceBintree *left;
    struct TraceBintree *right;
    int lefttype;
    int righttype;
} TBtree, *pTBtree;

pTBtree FindEnd(pTBtree x)
{
    while(x->righttype!=LINK){
        x = x->right;
    }
    return x;
}

int Algo_6_58(pTBtree p, pTBtree x)
{
    if (p->lefttype == NODE)
    {
        if (p->left)
        {
            auto t = p->left;
            p->left = x;
            FindEnd(x)->righttype = NODE;
            FindEnd(x)->right = t;
        }
        else
        {
            //不可能出现, 为了robust性而加入
            p->left = x;
            FindEnd(x)->righttype = NODE;
            FindEnd(x)->right = p;
        }
    }
    else
    {
        p->lefttype = NODE;
        auto t = p->left;
        p->left = x;
        FindEnd(x)->righttype = NODE;
        FindEnd(x)->right = p;
    }
}

// 6.65 已知一棵二叉树的前序序列和中序序列分别存于两个一维数组中，试编写算法建立该二叉树的二叉链表。

// typedef struct bintreenode
// {
//     int data;
//     struct bintreenode *left;
//     struct bintreenode *right;
//     struct bintreenode *parent; //may not be used

//     char type; //for 6.51 type==0(num) '+-*/'
// } bnode, *pbnode;

int Find(int x, int* array)
{
    int i = 0;
    while (x != array[i])
        i++;
    return i;
}

pbnode RecoverTree(int* f,int* m, int size)
{
    if(size<=0)
        return nullptr;
    int root = f[0];
    int p=Find(root,m);
    pbnode res=new bnode;
    res->data=root;
    res->left = RecoverTree(f, m, p);
    res->right = RecoverTree(f+p+1, m+p+1, size - p - 1);
}

// 6.71 假设树上每个结点所含的数据元素为一个字母，并且以孩子-兄弟链表为树的存储结构，试写一个按凹入表方式打印一棵树的算法。例如：左下所示树印为右下形状。

typedef struct Tree
{
    char data;
    struct Tree *bro;
    struct Tree *son;
} tree, *ptree;

int space(int x)
{
    while (x-- > 0)
        std::cout << "  ";
}

int PrintTree(ptree src, int depth = 0)
{
    //先序遍历
    if (!src)
        return 0;
    space(depth);
    printf("%c\n", src->data);
    if (src->son)
    {
        PrintTree(src->son, depth + 1);
    }
    if (src->bro)
    {
        PrintTree(src->bro, depth);
    }
    return 0;
}

//unit test

int main()
{
}