#ifndef _A_2_38_H
#define _A_2_38_H

typedef struct doublelinklist
{
    int data;
    int freq;
    struct doublelinklist *next;
    struct doublelinklist *before;
} dllist, *pdllist;

pdllist DoubleLinklistInit(int data)
// return the first point with data
{
    pdllist result = (pdllist)malloc(sizeof(dllist));
    if (!result)
        return 0;
    result->freq = 0;
    result->next = result;
    result->before = result;
    result->data = data;
    return result;
}

int DoubleLinklistAdd(pdllist head, int data)
{
    if (head)
    {
        pdllist t = (pdllist)malloc(sizeof(dllist));
        if (!t)
            return ERROR;
        t->data = data;
        t->next = head;
        t->before = head->before;

        head->before->next = t;
        head->before = t;

        return SUCCEED;
    }
    return ERROR;
}

int DoubleLinklistLocate(pdllist head, int data)
{
    if (!head)
        return ERROR;
    pdllist t = head;

    int cur = 0;
    do
    {
        if (t->data == data)
        {
            t->freq++;
            return cur;
        }
        t = t->next;
        cur++;
    } while (t != head);
    return -1;
}

int DoubleLinklistSelect(pdllist head, int position)
{
    if (!head)
        return ERROR;
    pdllist t = head;
    int cur = 0;
    do
    {
        if (cur == position)
        {
            t->freq++;
            return t->data;
        }
    } while (t != head);
    return -1;
}

int DoubleLinklistShowall(pdllist head)
{
    if (!head)
        return ERROR;
    pdllist t = head;
    do
    {
        printf("data:%d  freq:%d\n", t->data, t->freq);
        t = t->next;
    } while (t != head);

    return SUCCEED;
}

#endif