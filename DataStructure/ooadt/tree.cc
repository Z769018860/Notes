//OO_ADT_Code Project
//https://github.com/L-F-Z/ADT_Code
//https://github.com/AugustusWillisWang/Notes/tree/master/DataStructure/ooadt
//Developed by AugustusWillisWang

#include <iostream>
#include <exception>
#include <cstdlib>
#include <cstring>
#include <algorithm>
#include <vector>

#include <string.h>
#include <stdio.h>

#include "adt.h"
#include "dbg.h"

template <class T>
class Tree
{
  public:
    Tree();
    Tree(int num, T *data);
    Tree(const Tree<T> &src);
    virtual ~Tree();
    virtual int clear();
    virtual int empty();
    virtual int depth();
    virtual int root();
    virtual T value();
    virtual Tree<T> *parent();
    virtual Tree<T> *leftchild();
    virtual Tree<T> *rightsibling();
    virtual Tree<T> *operator[](int p);
    virtual int insertchild();
    virtual int deletechild();
    virtual int traverse();
    virtual int degree();
    virtual int print();
    virtual int operator+(T data);
    virtual int push_back();
    virtual int push_head();
    virtual T pop_back();
    virtual T pop_head();
    virtual Tree<T> operator&(Tree<T> tgt);

  private:
    T data_;
    union {
        Tree *subtree; //or left child point
        std::vector<Tree<T>> sublist;
    };
    Tree *nexttree;   //or right child point
    Tree *fathertree; //parent point
};

template <class T>
class Bintree: public Tree<T>
{
    public:
      Bintree();
      Bintree(int num, T *data);
      Bintree(const Tree<T> &src);
      Bintree(const Bintree<T> &src);
      virtual ~Bintree();
      virtual int clear();
      virtual int empty();
      virtual int depth();
      virtual int root();
      virtual T value();
      virtual Tree<T> *parent();
      virtual Tree<T> *leftchild();
      virtual Tree<T> *delete_leftchild();
      virtual Tree<T> *rightchild();
      virtual Tree<T> *delete_rightchild();
      virtual Tree<T> *leftsibling();
      virtual Tree<T> *rightsibling();
      virtual Tree<T> *operator[](int p);
      virtual int insertchild();
      virtual int insert_leftchild();
      virtual int insert_rightchild();
      virtual int delete_child();
      virtual int traverse();
      virtual int preorder_traverse();
      virtual int inorder_traverse();
      virtual int postorder_traverse();
      virtual int level_traverse();
      virtual int degree();
      virtual int print();
      virtual int operator+(T data);
      virtual int push_back();
      virtual int push_head();
      virtual T pop_back();
      virtual T pop_head();

    private:
};

template <class T>
class Arrayed_Bintree : public Bintree<T>
{
  public:
    Arrayed_Bintree();
    Arrayed_Bintree(int num, T *data);
    Arrayed_Bintree(const Tree<T> &src);
    Arrayed_Bintree(const Bintree<T> &src);
    virtual ~Arrayed_Bintree();
    virtual int clear();
    virtual int empty();
    virtual int depth();
    virtual int root();
    virtual T value();
    virtual int parent();
    virtual int leftchild();
    virtual int delete_leftchild();
    virtual int rightchild();
    virtual int delete_rightchild();
    virtual int leftsibling();
    virtual int rightsibling();
    virtual int operator[](int p);
    virtual int insertchild();
    virtual int insert_leftchild();
    virtual int insert_rightchild();
    virtual int delete_child();
    virtual int traverse();
    virtual int preorder_traverse();
    virtual int inorder_traverse();
    virtual int postorder_traverse();
    virtual int degree();
    virtual int print();
    virtual int operator+(T data);
    virtual int push_back();
    virtual int push_head();
    virtual T pop_back();
    virtual T pop_head();

  private:
    std::vector<T> bintree;
    std::vector<T> valid;
};

template <class T>
class Threading_bintree : public Bintree<T>
{
  public:
    Threading_bintree();
    Threading_bintree(int num, T *data);
    Threading_bintree(const Tree<T> &src);
    Threading_bintree(const Bintree<T> &src);
    virtual ~Threading_bintree();
    virtual int clear();
    virtual int empty();
    virtual int depth();
    virtual int root();
    virtual T value();
    virtual Tree<T> *parent();
    virtual Tree<T> *leftchild();
    virtual Tree<T> *delete_leftchild();
    virtual Tree<T> *rightchild();
    virtual Tree<T> *delete_rightchild();
    virtual Tree<T> *leftsibling();
    virtual Tree<T> *rightsibling();
    virtual Tree<T> *operator[](int p);
    virtual int insertchild();
    virtual int insert_leftchild();
    virtual int insert_rightchild();
    virtual int delete_child();
    virtual int traverse();
    virtual int preorder_traverse();
    virtual int inorder_traverse();
    virtual int postorder_traverse();
    virtual int level_traverse();
    virtual int degree();
    virtual int print();
    virtual int operator+(T data);
    virtual int push_back();
    virtual int push_head();
    virtual T pop_back();
    virtual T pop_head();

  private:
};

template <class T>
class Huffman_Bintree : public Bintree<T>
{
  public:
    Huffman_Bintree();
    Huffman_Bintree(int num, T *data);
    Huffman_Bintree(const Tree<T> &src);
    Huffman_Bintree(const Bintree<T> &src);

    virtual ~Huffman_Bintree();
    virtual int clear();
    virtual int empty();
    virtual int depth();
    virtual int root();
    virtual T value();
    virtual Tree<T> *parent();
    virtual Tree<T> *leftchild();
    virtual Tree<T> *delete_leftchild();
    virtual Tree<T> *rightchild();
    virtual Tree<T> *delete_rightchild();
    virtual Tree<T> *leftsibling();
    virtual Tree<T> *rightsibling();
    virtual Tree<T> *operator[](int p);
    virtual int insertchild();
    virtual int insert_leftchild();
    virtual int insert_rightchild();
    virtual int delete_child();
    virtual int traverse();
    virtual int preorder_traverse();
    virtual int inorder_traverse();
    virtual int postorder_traverse();
    virtual int level_traverse();
    virtual int degree();
    virtual int print();
    virtual int operator+(T data);
    virtual int push_back();
    virtual int push_head();
    virtual T pop_back();
    virtual T pop_head();

  private:
};

template <class T>
class Sorted_Bintree : public Bintree<T>
{
  public:
    Sorted_Bintree();
    Sorted_Bintree(int num, T *data);
    Sorted_Bintree(const Tree<T> &src);
    Sorted_Bintree(const Bintree<T> &src);
    virtual ~Sorted_Bintree();
    virtual int clear();
    virtual int empty();
    virtual int depth();
    virtual int root();
    virtual T value();
    virtual Tree<T> *parent();
    virtual Tree<T> *leftchild();
    virtual Tree<T> *delete_leftchild();
    virtual Tree<T> *rightchild();
    virtual Tree<T> *delete_rightchild();
    virtual Tree<T> *leftsibling();
    virtual Tree<T> *rightsibling();
    virtual Tree<T> *operator[](int p);
    virtual int insertchild();
    virtual int insert_leftchild();
    virtual int insert_rightchild();
    virtual int delete_child();
    virtual int traverse();
    virtual int preorder_traverse();
    virtual int inorder_traverse();
    virtual int postorder_traverse();
    virtual int level_traverse();
    virtual int degree();
    virtual int print();
    virtual int operator+(T data);
    virtual int push_back();
    virtual int push_head();
    virtual T pop_back();
    virtual T pop_head();

  private:
};

template <class T>
class Avltree : public Bintree<T>
{
  public:
    Avltree();
    Avltree(int num, T *data);
    Avltree(const Tree<T> &src);
    Avltree(const Bintree<T> &src);
    virtual ~Avltree();
    virtual int clear();
    virtual int empty();
    virtual int depth();
    virtual int root();
    virtual T value();
    virtual Tree<T> *parent();
    virtual Tree<T> *leftchild();
    virtual Tree<T> *delete_leftchild();
    virtual Tree<T> *rightchild();
    virtual Tree<T> *delete_rightchild();
    virtual Tree<T> *leftsibling();
    virtual Tree<T> *rightsibling();
    virtual Tree<T> *operator[](int p);
    virtual int insertchild();
    virtual int insert_leftchild();
    virtual int insert_rightchild();
    virtual int delete_child();
    virtual int traverse();
    virtual int preorder_traverse();
    virtual int inorder_traverse();
    virtual int postorder_traverse();
    virtual int level_traverse();
    virtual int degree();
    virtual int print();
    virtual int operator+(T data);
    virtual int push_back();
    virtual int push_head();
    virtual T pop_back();
    virtual T pop_head();

  private:
};

template<class T>
class Btree
{

};

template <class T>
class Bplustree
{
};

template <class T>
class Tiretree
{
};

int main()
{

}