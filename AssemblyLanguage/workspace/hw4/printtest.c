#include <stdio.h>

int a[10] = {6,
             -5,
             3,
             1,
             -8,
             7,
             0,
             2,
             4,
             9};

void sort()
{

    int i;

    int j, tmp;

    for (i = 1; i < 10; i++)

    {

        tmp = a[i];

        j = i - 1;

        while (j >= 0 && a[j] > tmp)

        {

            a[j + 1] = a[j];

            j--;
        }

        a[j + 1] = tmp;
    }
}
int main()
{
    // int a[10]={1,2,3,4,5,6,7,8,9,0};
    // for (int i = 0; i < 10;i++)
    // {
    //     printf("%d", a[i]);
    // }

    sort();
    
}