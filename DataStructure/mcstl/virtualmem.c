// MCSTL: My C Standard Template Libray, created for data structure class

// Author: Huaqiang Wang
// Created: 2018.3.8

// virtualmem.c

// #define _UNITTEST_VIRTUALMEM_C

#ifndef _VIRTUALMEM_C
#define _VIRTUALMEM_C

#define ERROR -1
#define OVERFLOW -2
#define NULL 0

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <limits.h>
#include "lazy.h"

// typedef int Datatype;
#define Virtualmemtype int

typedef struct Virtualmemunit
{
    Virtualmemtype data;
    int next;
} VMunit, *pVMunit;

typedef struct Virtualmemhead
{
    pVMunit head;
    int end;
    int empty;
    int size;
    int used;
} VMhead, *pVMhead;

pVMhead VirtualmemInit(int size)
{
    pVMhead res = (pVMhead)malloc(sizeof(VMhead));
    if (size < 1)
        return NULL;
    if (size > INT_MAX)
        return NULL;
    int i = 0;
    pVMunit p = (pVMunit)malloc(sizeof(VMunit) * size);
    if (!p)
        return NULL;
    res->head = p;
    res->end = 0;
    res->empty = 0;
    res->size = size;
    res->used = 1;
    while (i < (size - 1))
    {
        p[i].next = i + 1;
        i++;
    }
    p[i].next = 0;
    return res;
}

int VirtualmemGet(pVMhead vm, int position)
{
    if (!vm)
        return ERROR;
    if (position < 0 || position > vm->size)
        return OVERFLOW;

    int i = 0;
    int cnt = 0;
    pVMunit p = vm->head;

    while (cnt < position)
    {
        i = p[i].next;
        cnt++;
    }
    return i;
}

int VirtualmemNext(pVMhead vm, int position)
{
    if (!vm)
        return ERROR;
    if (position < 0 || position > vm->size)
        return OVERFLOW;

    int i = 0;
    int cnt = 0;
    pVMunit p = vm->head;
    
    while (cnt <= position)
    {
        i = p[i].next;
        cnt++;
    }
    return i;
}

// pVMunit VirtualmemMalloc(pVMhead hnode,int nsize)
// {
//     if (!hnode)
//         return NULL;
//     if ((nsize+hnode->used)>hnode->size||nsize<=0)
//         return NULL;
//     int i=0;
//     int p=hnode->empty;
//     int e = hnode->end;
//     pVMunit res;
// }

int VirtualmemMalloc(pVMhead hnode)
{
    if (!hnode)
        return ERROR;
    if ((1 + hnode->used) > hnode->size)
        return OVERFLOW;
    int empty = hnode->empty;
    int end = hnode->end;
    hnode->end = empty;                              //update end
    hnode->empty = (hnode->head)[hnode->empty].next; //update empty
    (hnode->head)[end].next = empty;
    (hnode->head)[empty].next = 0;
    hnode->used++;
    return empty;
}

int VirtualmemFree(pVMhead hnode, int position)
{
    if (hnode->used <= 0)
        return ERROR;
    int end = hnode->end;
    (hnode->head)[position].next = hnode->empty;
    hnode->empty = position;
    hnode->used--;
    return 0;
}

int VirtualmemClose(pVMhead dist)
{
    if (dist)
    {
        free(dist->head);
        free(dist);
        return 0;
    }
    return ERROR;
}

#ifdef _UNITTEST_VIRTUALMEM_C

int main()
{
    pVMhead vm = VirtualmemInit(4);
    int p = 0;

    p = VirtualmemMalloc(vm);
    CK(p);
    p = VirtualmemMalloc(vm);
    CK(p);
    p = VirtualmemMalloc(vm);
    CK(p);
    VirtualmemFree(vm, 0);
    CK(p);
    p = VirtualmemMalloc(vm);
    CK(p);

    p = VirtualmemMalloc(vm);
    CK(p);
    p = VirtualmemMalloc(vm);
    CK(p);
    p = VirtualmemMalloc(vm);
    CK(p);
    p = VirtualmemMalloc(vm);
    CK(p);
    p = VirtualmemGet(vm, 3);
    CK(p);
}

#endif
#endif