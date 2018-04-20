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

// const int MAX_ROW_NUM = 233;

class Matrix
{
public:
  Matrix();
  ~Matrix();
  virtual int print();
  virtual int updatecnt();
  Matrix transpose();
  friend Matrix operator+(Matrix tgt);
  friend Matrix operator-(Matrix tgt);
  friend Matrix operator*(Matrix tgt);

  int col_ = 0;
  int row_ = 0;
  int elem_ = 0;

private:
  std::vector<int> rpos;
  std::vector<std::vector<int>> data;
};

Matrix::Matrix()
{
}

Matrix::~Matrix()
{
}

int Matrix::print() {}
int Matrix::updatecnt() {}
Matrix Matrix::transpose() {}

class Matrix_Sparse : public Matrix
{
public:
  Matrix_Sparse();
  Matrix_Sparse(const Matrix_Sparse &src);
  Matrix_Sparse(const int *src, int row, int col);
  Matrix_Sparse(std::vector<int> src);
  ~Matrix_Sparse();
  int print();
  virtual int updatecnt();
  Matrix_Sparse transpose_sparse();
  friend Matrix_Sparse operator+(Matrix_Sparse tgt);
  friend Matrix_Sparse operator-(Matrix_Sparse tgt);
  friend Matrix_Sparse operator*(Matrix_Sparse tgt);
  struct MSdot
  {
    int a;
    int b;
    int data;
  };

  int addline(std::vector<int> src); //addline
  int Matrix_Sparse::findpoint(int a, int b); //get the value of a point;
  int Matrix_Sparse::setup_row_position();//reset row_position_
  int Matrix_Sparse::set(int a, int b, int data);//get a point to given value
  int Matrix_Sparse::sort();                     //sort the elements by row, update row_position_ and merge the same term at the same time;

private:
  std::vector<MSdot> data_;
  std::vector<int> row_position_;
  std::vector<int> row_cnt_;
};

int Matrix_Sparse::addline(std::vector<int> src) //addline
{
  int t;
  struct Matrix_Sparse::MSdot tmpstr;
  if (src.size() > col_)
  {
    col_ = src.size();
  }
  while (!src.empty())
  {
    if (t = src.back() == 0)
    {
    }
    else
    {
      {
        tmpstr.a = row_ + 1, tmpstr.b = src.size() - 1, tmpstr.data = t;
      }
      data_.push_back(tmpstr);
      elem_++;
    }
    src.pop_back();
  }
  ++row_;
}

Matrix_Sparse::Matrix_Sparse(const int *src, int row, int col)
{
  if (!src)
    throw("Nullptr for initialzing Matrix_Sparse.");
  int t;
  struct Matrix_Sparse::MSdot tmpstr;
  if (col > col_)
  {
    col_ = col;
  }
  if (row > row_)
  {
    row_ = row;
  }

  for (int a = 0; a < row; a++)
  {
    for (int b = 0; b < col; b++)
    {
      if (t = *(src + a * col + b) == 0)
      {
        continue;
      }
      else
      {
        {
          tmpstr.a = a, tmpstr.b = b, tmpstr.data = t;
        }
        data_.push_back(tmpstr);
        elem_++;
      }
    }
  }
}

int Matrix_Sparse::findpoint(int a, int b)
{
  int s = data_.size();
  for (int i = 0; i < s; i++)
  {
    if (data_[i].a == a && data_[i].b == b)
      return data_[i].data;
  }
  return 0;
}

int Matrix_Sparse::print()
{
  //printbyline
  for (int a = 0; a < row_; a++)
  {
    for (int b = 0; b < col_; b++)
    {
      std::cout << this->findpoint(a, b) << " ";
    }
    std::cout << std::endl;
  }
}

int Matrix_Sparse::updatecnt()
{
  elem_ = data_.size();
}

int Matrix_Sparse::setup_row_position() //can be used only in ordered data_;
{
  row_position_.clear();
  row_cnt_.clear();
  int s = data_.size();
  int rowcnt = -1;
  int i = 0;
  while (i < s)
  {
    if (data_[i].a > rowcnt)
    {
      rowcnt = data_[i].a;
      row_position_.push_back(i);
    }
    ++i;
  }
  return 0;
}

Matrix_Sparse Matrix_Sparse::transpose_sparse()
{
  int s = data_.size();
  int i = 0;
  int t;
  while (i < s)
  {
    t = data_[i].a;
    data_[i].a = data_[i].b;
    data_[i].b = t;
    ++i;
  }
}

int Matrix_Sparse::set(int a, int b, int data)
{
  struct Matrix_Sparse::MSdot tmpstr;
  if ((b + 1) > col_)
  {
    col_ = (b + 1);
  }
  if ((a + 1) > row_)
  {
    row_ = (a + 1);
  }
  {
    tmpstr.a = a, tmpstr.b = b, tmpstr.data = data;
  }
  data_.push_back(tmpstr);
  elem_++;
}

int Matrix_Sparse::sort()
{
  row_cnt_.clear();
  row_position_.clear();
  std::vector<int> temp(row_,0);
  row_cnt_ = temp;
  //traverse and get row_cnt_
  //use temp to save how many point has been moved
}

int main()
{
}