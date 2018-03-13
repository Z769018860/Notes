// MCSTL: My C Standard Template Libray, created for data structure class

// Author: Huaqiang Wang
// Created: 2018.3.9

// stack.c

#define _UNITTEST_STACK_C

#ifndef _STACK_C
#define _STACK_C

#define ERROR -1
#define OVERFLOW -2

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include "lazy.h"

// typedef int DatatypeStack;
#define DatatypeStack int

typedef struct StackByArray
{
    DatatypeStack *array;
    int top;
    int size;
} SBA, *pSBA;

pSBA StackInit(int maxsize)
{
    pSBA res;
    res->array = (DatatypeStack *)malloc(sizeof(DatatypeStack) * maxsize);
    res->top = 0;
    res->size = maxsize;
    if (res->array)
        return res;
    return NULL;
}

int StackFree(pSBA pstack)
{
    if (pstack)
    {
        free(pstack->array);
        pstack->size = 0;
    }
    return ERROR;
}

int StackClear(pSBA pstack)
{
    if (pstack)
    {
        pstack->top = 0;
    }
    return ERROR;
}

DatatypeStack* StackExtern(pSBA pstack, int addsize)
{
    if (addsize < 0)
        return NULL;
    return (DatatypeStack*) realloc(pstack->array, addsize * sizeof(DatatypeStack));
}

int StackPush(pSBA pstack, DatatypeStack data)
{
    if (pstack)
    {
        if (pstack->size > pstack->top)
        {
            pstack->array[pstack->top] = data;
            pstack->top++;
            return 0;
        }
        else
        {
            if (StackExtern(pstack, 100) == 0)
            {
                pstack->array[pstack->top] = data;
                pstack->top++;
                return 0;
            }
            return OVERFLOW;
        }
        return ERROR;
    }
    return ERROR;
}

int StackPop(pSBA pstack,DatatypeStack* pdata)
{
    if(!pstack)
        return ERROR;
    if (pstack->top > 0)
    {
        pstack->top--;
        *pdata = pstack->array[pstack->top];
        return 0;
    }
    return OVERFLOW;
}

DatatypeStack StackPop_nsq(pSBA pstack)
{
    if (pstack->top > 0)
    {
        pstack->top--;
        return pstack->array[pstack->top];
    }
}

#ifdef _UNITTEST_STACK_C

int main()
{
}

#endif
#endif