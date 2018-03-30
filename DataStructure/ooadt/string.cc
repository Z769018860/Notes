//OO_ADT_Code Project
//https://github.com/L-F-Z/ADT_Code
//https://github.com/AugustusWillisWang/Notes/tree/master/DataStructure/ooadt
//Developed by AugustusWillisWang

#include <iostream> 
#include <exception>
#include <cstdlib>
#include <cstring>
// #include <algorithm>
// #include <vector>

#include <string.h>
#include <stdio.h>

#include "adt.h"
#include "dbg.h"

using std::istream;
using std::ostream;
using std::memcpy;

using std::string;

// class String
// {
// public:
//   String();               //StrAssign
//   String(const String &); //StrCopy
//   ~String();              //DelString
//   void operator=(const String &);

//   virtual int empty();                 //StrEmpty
//   virtual int compare(const String &); //StrCmp
//   virtual int length();
//   virtual int clear();
//   virtual int adhere();
//   virtual int cat();
//   virtual sub_string();
//   virtual int index();
//   virtual int replace();
//   virtual int insert();
//   virtual int del();

//   friend int compare(const String &, const String &);

//   virtual int print();
//   virtual int out();
//   // friend ostream& operator<<(ostream &output, const String S);

// protected:
// private:
//   char *data_;
// };

class String_C
{
public:
  String_C();                 //StrAssign
  String_C(char *);           //StrAssign
  String_C(const string src);           //StrAssign
  String_C(const String_C &); //StrCopy
  // String_C(const String_H &);
  // String_C(const String_L &);
  ~String_C(); //DelString
  void operator=(char *);
  void operator=(const String_C &);
  // String_C operator=(const String_H &);
  // String_C operator=(const String_L &);

  int empty()const;                   //StrEmpty
  int compare(const String_C &)const; //StrCmp
  friend int compare(const String_C &, const String_C &);
  int length()const;
  int clear();
  int adhere(String_C &src);
  int cat(String_C &src);
  String_C sub_string(int pos, int len) const;
  int index(String_C &sub_string, int start_pos = 0)const;
  int replace(String_C &target, String_C &src);
  int insert(int ins_before, String_C &src);
  int del(int pos, int len);
  int kmp(String_C &target, int start_pos = 0)const;

  virtual int print();
  friend ostream &operator<<(ostream &output, const String_C S);

  char *data_;

private:
};

// class String_H : public String
// {
// public:
//   String_H();                 //StrAssign
//   String_H(char *);           //StrAssign
//   // String_H(const String_C &); //StrCopy
//   String_H(const String_H &);
//   // String_H(const String_L &);
//   ~String_H();                   //DelString
//   void operator=(char *);
//   // void operator=(const String_C &);
//   void operator=(const String_H &);
//   // void operator=(const String_L &);

//   int empty();                   //StrEmpty
//   int compare(const String_H &); //StrCmp
//   friend int compare(const String_H &, const String_H &);
//   int length();
//   int clear();
//   int adhere(String_H &src);
//   int cat(String_H &src);
//   String_H sub_string(int pos, int len);
//   int index(String_H &sub_string, int start_pos = 0);
//   int replace(String_H &target, String_H &src);
//   int insert(int ins_before, String_H &src);
//   int del(int pos, int len);

//   virtual int print();
//   friend ostream &operator<<(ostream &output, const String_H S);

// private:
//   char *data_;
//   int heap_size;
// };

// class String_L : public String
// {
// public:
//   String_L();                 //StrAssign
//   String_L(char *);           //StrAssign
//   // String_L(const String_C &); //StrCopy
//   // String_L(const String_H &);
//   String_L(const String_L &);
//   ~String_L();                   //DelString
//   void operator=(char *);
//   // String_C operator=(const String_C &);
//   // String_C operator=(const String_H &);
//   void operator=(const String_L &);

//   int empty();                   //StrEmpty
//   int compare(const String_L &); //StrCmp
//   friend int compare(const String_L &, const String_L &);
//   int length();
//   int clear();
//   int adhere(String_L &src);
//   int cat(String_L &src);
//   String_L sub_string(int pos, int len);
//   int index(String_L &sub_string, int start_pos = 0);
//   int replace(String_L &target, String_L &src);
//   int insert(int ins_before, String_L &src);
//   int del(int pos, int len);

//   virtual int print();
//   friend ostream &operator<<(ostream &output, const String_L S);

// private:
//   char *data_;
//   int node_size;
// };

int char_string_size(const char *src)
{
  int length = 0;
  while (*src != 0)
  {
    ++length;
    ++src;
  }
  return length;
}

String_C::String_C()
{
  data_ = new char[1];
  *data_ = 0;
}

String_C::String_C(char *src)
{
  // delete[] data_;
  int i;
  data_ = new char[char_string_size(src) + 1];
  char *pdata = data_;
  while (*src != 0)
  {
    *pdata = *src;
    ++pdata;
    ++src;
  }
  *pdata = 0;
}

String_C::String_C(const string ssrc) //StrAssign
{
  const char *src = ssrc.data();
  // delete[] data_;
  int i;
  data_ = new char[char_string_size(src) + 1];
  char *pdata = data_;
  while (*src != 0)
  {
    *pdata = *src;
    ++pdata;
    ++src;
  }
  *pdata = 0;
}

String_C::String_C(const String_C &src) //StrCopy
{
  // delete[] data_;1
  int size = src.length() + 1;
  data_ = new char[size];
  memcpy(data_, src.data_, size);
}
// String_C(const String_H &);
// String_C(const String_L &);
String_C::~String_C()
{
  delete[] data_;
}

void String_C::operator=(char *src)
{
  delete[] data_;
  int i;
  data_ = new char[char_string_size(src) + 1];
  char *pdata = data_;
  do
  {
    *pdata = *src;
    ++pdata;
    ++src;
  } while (*src != 0);
}

void String_C::operator=(const String_C &src)
{
  delete[] data_;
  int size = src.length() + 1;
  data_ = new char[size];
  memcpy(data_, src.data_, size);
}
// String_C operator=(const String_H &);
// String_C operator=(const String_L &);

int String_C::empty()const //StrEmpty
{
  if (data_)
    return !(int)*data_;
  return 1;
}

int String_C::compare(const String_C &S)const //StrCmp
{
  // if (this->empty() || S.empty())
  // {
  //   throw("Empty cmp;");
  // }
  char *a = data_;
  char *b = S.data_;
  while (*a != *b && *a != 0 && *b != 0)
  {
    ++a;
    ++b;
  }
  return *a - *b;
}

int compare(const String_C& P, const String_C &S)
{
  // if (P.empty() || S.empty())
  // {
  //   std::stderr << "Cmp failed." << std::endl;
  //   return 0;
  // }
  char *a = P.data_;
  char *b = S.data_;
  while (*a != *b && *a != 0 && *b != 0)
  {
    ++a;
    ++b;
  }
  return *a - *b;
}

int String_C::length()const
{
  return char_string_size(data_);
}

int String_C::clear()
{
  delete[] data_;
  data_ = new char[1];
  data_[0] = 0;
  return 0;
}

int String_C::adhere(String_C &src)
{
  int len_this = this->length();
  int len_target = src.length();
  char *data = data_;
  char *result = new char[len_target + len_this + 1];

  memcpy(result, data_, len_this);
  memcpy(result + len_this, src.data_, len_target);
  result[len_this + len_target] = 0;
  return 0;
}

int String_C::cat(String_C &src)
{
  this->adhere(src);
}

String_C String_C::sub_string(int pos, int len) const
{
  char *result = new char[len + 1];
  int cnt = 0;
  char *data = data_;
  char *presult = result;
  while (cnt != pos)
  {
    ++data;
    ++cnt;
  }
  cnt = 0;
  while (cnt < len && (*presult) != 0)
  {
    *presult = *data;
    presult++;
    data++;
    cnt++;
  }
  String_C nstring;
  if (cnt == len)
  {
    nstring.data_ = result;
  }
  return nstring;
}

int String_C::index(String_C &sub_string, int start_pos)const
{
  int cnt = start_pos;
  char *data = data_;
  const char *sub = sub_string.data_;
  while (*data)
  {
    int match = 0;
    char *p = data;
    while (*p == *sub && *p != 0)
    {
      data++;
      p++;
      cnt++;
      if (*sub == 0)
        return cnt;
    }
    if (*sub == 0)
      return -1;
    if (*p == 0)
      return -1;
    throw(std::bad_exception());
  }
}

namespace String_Replace
{

int is_head_equal(char *a, char *b)
{
  while (*a == *b && *a != 0)
  {
    a++;
    b++;
    if (*b == 0)
    {
      return 1;
    }
  }
  return 0;
}

int add_b_to_a(char *(&a) , char *b)
{
  while (*b != 0)
  {
    *a = *b;
    a++;
    b++;
  }
  return 0;
}
}

#define BUFSIZE 1024
int String_C::replace(String_C &target, String_C &src)
{
  using namespace String_Replace;
  char *buf = new char[BUFSIZE];
  int overflow_cnt = 0;
  int len_target = target.length();
  char *a = data_;
  char *b = target.data_;
  char *c = buf;
  while (*a != 0 && overflow_cnt < (BUFSIZE - 1))
  {
    if (is_head_equal(a, b))
    {
      char *d = src.data_;
      while (*d != 0)
      {
        *c = *d;
        d++;
        c++;
        overflow_cnt++;
      }
      a += len_target;
    }
    else
    {
      *c++ = *a++;
    }
  }
  *c = 0;

  char *result = new char[overflow_cnt + 1];
  memcpy(result, buf, overflow_cnt + 1);
  delete[] buf;
  data_ = result;
  return OK;
}

int String_C::insert(int ins_before, String_C &src)
{
  if (ins_before < 0)
    throw(std::domain_error("domain_error"));
  int cnt = 0;
  char *a = data_;
  char *b = new char[BUFSIZE];
  char *c = src.data_;

  while (*a != 0 && cnt != ins_before)
  {
    *b = *a;
    a++;
  }
  if (*a != 0)
  {
    while (*c)
    {
      *b = *c;
      b++;
      c++;
    }
    while (*a != 0 && cnt != ins_before)
    {
      *b = *a;
      a++;
    }
    *b = 0;
  }

  int bufsize = char_string_size(b);
  char *d = new char[bufsize + 1];
  memcpy(d, b, bufsize + 1);
  data_ = d;
  delete[] b;

  return OK;
}

int String_C::del(int pos, int len)
{
  int len_data = this->length();
  if (pos < 0 || pos + len > len_data)
    throw(std::domain_error("domain_error"));
  int cnt = 0;
  char *a = data_;
  while (cnt != pos && *a != 0)
  {
    cnt++;
    a++;
  }
  char *backp = a;
  a += len;
  while (*a)
  {
    *backp = *a;
    ++a;
    ++backp;
  }
  *backp = 0;
  return OK;
}
#undef BUFSIZE

namespace String_Kmp
{
int *set_next(char *data)
{
  int len_tgt = char_string_size(data);
  int *result = new int[len_tgt];
  int i = 0;
  result[0] = -1;
  int j = -1;
  while (i < len_tgt)
  {
    if (j == -1 || data[i] == data[j])
    {
      ++i;
      ++j;
      if (data[i] != data[j])
        result[i] = j;
      else
        result[i] = result[j];
    }
    else
      j = result[j];
  }
  return result;
}
}

int String_C::kmp(String_C &target, int start_pos)const
{
  using namespace String_Kmp;

  int *next = set_next(target.data_);
  int i = start_pos;
  int j = 0;
  int len_data = this->length();
  int len_tgt = target.length();

  while (i <= len_data && j < len_tgt)
  {
    if (j == -1 || data_[i] == target.data_[j])
    {
      ++i;
      ++j;
    }
    else
    {
      j = next[j];
    }
  }
  if (j >= len_tgt)
    return i - len_tgt;
  return -1;
}

int String_C::print()
{
  printf("%s", data_);
  return 0;
}

ostream &operator<<(ostream &output, const String_C S)
{
  printf("%s", S.data_);
  return output;
}

// String_C::ostream &operator<<();

int main(int argc, char *argv[])
{
  LICENSE;
  String_C a((char*)"22223333");
  a.print();
  // delete a;
  String_C b=(char*)"12345678";
  CK(b.length());
  b.clear();
  CK(b.empty());
  String_C *c = new String_C;
  c->print();
  CK(c->length());
  CK(c->empty());
  delete c;
  // String_C b = (char *)"123468";
  L;
  CK(b.compare("234567"));
  a.print();
  String_C d("233");
  CK(a.kmp(d));
}