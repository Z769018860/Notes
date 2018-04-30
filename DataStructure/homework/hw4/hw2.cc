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

//3 - 17 试写一个算法，识别一次读入的一个以 @为结束符的字符序列是否为形如‘序列1 &序列2’模式的字符序列。其中序列1和序列2中都不含字符‘&’，且序列2是序列1的逆序列。例如，‘a + b &b + a’是属该模式的字符序列，而‘1 + 3 & 3 - 1’则不是。
//a_3_17
bool IsString3_17()
{
    using namespace std;
    string s;
    cin >> s;
    stack<char> stack;
    int i = 0;
    while (s[i] != 0 && s[i] != '@')
    {
        stack.push(s[i]);
        i++;
    }
    if (s[i] != '@')
        return false; //字符串不合规格
    i++;              //skip@
    while (s[i] != 0)
    {
        if (stack.empty() || s[i] != stack.top())
            return false;
        stack.pop();
        i++;
    }
    return true;
}

bool IsString3_17(char *s)
{
    using namespace std;
    stack<char> stack;
    int i = 0;
    while (s[i] != 0 && s[i] != '@')
    {
        stack.push(s[i]);
        i++;
    }
    if (s[i] != '@')
        return false; //字符串不合规格
    i++;              //skip@
    while (s[i] != 0)
    {
        if (stack.empty() || s[i] != stack.top())
            return false;
        stack.pop();
        i++;
    }
    return true;
}

//3-18 试写一个判别表达式中开、闭括号是否配对出现的算法
//a_3_18

bool BracketsIsPaired()
{
    using namespace std;
    string s;
    cin >> s;

    stack<char> c;
    int i = 0;
    while (s[i] != 0)
    {
        switch (s[i])
        {
        case '(':
            c.push(s[i]);
            break;
        case '[':
            c.push(s[i]);
            break;
        case '{':
            c.push(s[i]);
            break;
        case ')':
            if (!c.empty() && c.top() == '(')
            {
                c.pop();
                break;
            }
            else
                return false;
        case ']':
            if (!c.empty() && c.top() == '[')
            {
                c.pop();
                break;
            }
            else
                return false;
        case '}':
            if (!c.empty() && c.top() == '{')
            {
                c.pop();
                break;
            }
            else
                return false;
        default:
            break;
        }
        i++;
    }
    return true;
}

//3-20 假设以二维数组g(1…m, 1…n)表示一个图像区域，g[i,j]表示该区域中点(i,j)所具颜色，其值为从0到k的整数。编写算法置换点(i0,j0)所在区域的颜色。约定和(i0,j0)同色的上、下、左、右的邻接点为同色区域的点。
//a_3_20

//Remark:
//为了方便起见, 这里将(1....m)-->(0.....m-1)以与cpp中数组定义呼应
//(todo)

int direction[4][2] = {
    // {1, 1},
    // {1, -1},
    // {-1, 1},
    // {-1, -1},
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1}};

bool IsInArray(int a, int b, std::pair<int, int> point)
{
    return point.first < a && point.first >= 0 && point.first < b && point.second >= 0;
}

bool ChangeColor(int *array, int a, int b, int k, std::pair<int, int> point, int change_to_color)
{
    using namespace std;
    if (!array || change_to_color < 0 || change_to_color > k)
        return false;
    stack<pair<int, int>> todo_list;

    if (IsInArray(a, b, point))
    {
        todo_list.push(point);
    }
    else
    {
        return false;
    }

    int color = array[point.first * b + point.second];
    while (!todo_list.empty())
    {
        auto x = todo_list.top();
        array[x.first * b + x.second] = change_to_color;
        todo_list.pop();
        for (int i = 0; i < 4; i++)
        {
            pair<int, int> tpoint = {x.first + direction[i][0],
                                     x.second + direction[i][1]};
            if (IsInArray(a, b, tpoint) && array[tpoint.first * b + tpoint.second] == color)
            {
                todo_list.push(tpoint);
            }
        }
    }
    return true;
}

//3-21 假设表达式有单字母变量和双目四则运算符构成。试写一个算法，将一个通常书写形式且书写正确的表达式转换为逆波兰表达式
//a_3_21

bool is_op(char c)
{
    return (c == '+' || c == '-' || c == '*' || c == '/');
}

std::string ConvertToRPN(std::string S)
{
    using namespace std;
    string result;
    stack<char> OP;
    int i = 0;
    while (S[i] != 0)
    {
        if (is_op(S[i]))
        {
            if (OP.empty())
            {
                OP.push(S[i++]);
                continue;
            }
            else if (S[i] == '*' || S[i] == '/') //只有*/两种最高优先级的运算
            {
                if (OP.top() == '+' || OP.top() == '-')
                {
                    OP.push(S[i++]);
                }
                else
                {
                    result += (OP.top());
                    OP.pop();
                    OP.push(S[i++]);
                }
            }
            if (S[i] == '+' || S[i] == '-') //只有+-两种最低优先级的运算
            {
                result += (OP.top());
                OP.pop();
                OP.push(S[i++]);
            }
        } //if (is_op(S[i]))
        else
        {
            result += S[i];
            ++i;
        }
    }
    while (!OP.empty())
    {
        result += OP.top();
        OP.pop();
    }
    return result;
}

std::string ConvertToRPN()
{
    using namespace std;
    string S;
    cin >> S;
    string result;
    stack<char> OP;
    int i = 0;
    while (S[i] != 0)
    {
        if (is_op(S[i]))
        {
            if (OP.empty())
            {
                OP.push(S[i++]);
                continue;
            }
            else if (S[i] == '*' || S[i] == '/') //只有*/两种最高优先级的运算
            {
                if (OP.top() == '+' || OP.top() == '-')
                {
                    OP.push(S[i++]);
                }
                else
                {
                    result += (OP.top());
                    OP.pop();
                    OP.push(S[i++]);
                }
            }
            if (S[i] == '+' || S[i] == '-') //只有+-两种最低优先级的运算
            {
                result += (OP.top());
                OP.pop();
                OP.push(S[i++]);
            }
        } //if (is_op(S[i]))
        else
        {
            result += S[i];
            ++i;
        }
    }
    while (!OP.empty())
    {
        result += OP.top();
        OP.pop();
    }
    return result;
}

//3-24 试编写如下定义的递归函数的递归算法，并根据算法画出求g(5, 2)时栈的变化过程。
//a_3_24
int g(int m, int n)
{
    std::cout << "Add to stack: m=" << m << "  n=" << n << std::endl;
    if (n < 0)
        throw "n<0";
    if (m == 0)
        return 0;
    if (m > 0)
        return g(m - 1, 2 * n);
    throw "m<0";
}

// Add to stack: m=5  n=2
// Add to stack: m=4  n=4
// Add to stack: m=3  n=8
// Add to stack: m=2  n=16
// Add to stack: m=1  n=32
// Add to stack: m=0  n=64
// 0

//3-25 试写出求递归函数F(n)的递归算法，并消除递归：
//a_3_25
int F(int n)
{
    if (n == 0)
        return 1;
    if (n > 0)
        return n - F(n / 2);
    throw std::domain_error("n<0");
}

int F2(int n)
{
    std::vector<int> v;
    v.push_back(1);
    int i = 1;
    while (i <= n)
    {
        v.push_back(i - v[i / 2]);
        ++i;
    }
    return v[n];
}

//3-28 假设以带头结点的循环链表表示队列，并且只设一个指针指向队尾元素结点（注意不设头指针），试编写相应的队列初始化、入队列和出队列的算法。
//a_3_28
struct Node
{
    struct Node *next;
    int data;
};

class CircledQueue
{
  public:
    CircledQueue()
    {
        end = nullptr;
    }
    ~CircledQueue()
    {
        struct Node *t = end->next;
        do
        {
            struct Node *k = t->next;
            delete t;
            t = k;
        } while (t != end);
    }
    int Enqueue(int data)
    {
        if (end)
        {
            struct Node *t = end->next;
            end->next = new struct Node;
            end = end->next;
            end->next = t;
            end->data = data;
        }
        else
        {
            end = new struct Node;
            end->next = end;
            end->data = data;
        }
    }
    int Dequeue()
    {
        if (!end)
            throw std::domain_error("no element left");
        if (end->next == end)
        {
            int t = end->data;
            delete end;
            return t;
        }
        struct Node *p = end->next;
        int t = end->next->data;
        end->next = p->next;
        delete p;
        return t;
    };

  private:
    struct Node *end;
};

//3-31 判断回文序列
//a_3_31
bool IsReversalString(std::string S)
{
    int b = 0;
    while(S[b]!=0&&S[b]!='@'){
        b++;
    };
    --b;
    int a = 0;
    while((b-a)>0){
        if(S[a]!=S[b]){
            return false;
        }
        ++a;
        --b;
    }
    return true;
}

bool IsReversalString()
{
    std::string S;
    std::cin >> S;
    return IsReversalString(S);
}

int main()
{
    LICENSE;
    using namespace std;
    // stack<char> poi;
    // cout << poi.top()==0;

    cout << "a_3_17" << endl;
    cout << IsString3_17() << endl;

    cout << "a_3_18" << endl;
    cout << BracketsIsPaired() << endl;

    int array[3][3] = {
        {1, 1, 1},
        {2, 1, 3},
        {1, 1, 5}};
    cout << "a_3_20" << endl;
    cout << "3x3 array:" << endl;
    for (int i = 0; i < 9; i++)
        cout << array[i / 3][i % 3] << " ";
    cout << endl
         << ChangeColor((int *)array, 3, 3, 8, std::pair<int, int>(1, 1), 4) << endl;
    for (int i = 0; i < 9; i++)
        cout << array[i / 3][i % 3] << " ";

    cout << endl;
    cout << "a_3_21" << endl;
    cout << ConvertToRPN() << endl;

    cout << "a_3_24" << endl;
    cout << g(5, 2) << endl;

    cout << "a_3_25" << endl;
    cout << F(6) << endl;
    cout << F2(6) << endl;

    cout << "a_3_28" << endl;
    CircledQueue C;
    C.Enqueue(1);
    C.Enqueue(2);
    cout << C.Dequeue() << endl;
    cout << C.Dequeue() << endl;

    cout << "a_3_31" << endl;
    cout << IsReversalString() << endl;
}