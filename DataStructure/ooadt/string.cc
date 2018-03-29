//OO_ADT_Code Project
//https://github.com/L-F-Z/ADT_Code
//https://github.com/AugustusWillisWang/Notes/tree/master/DataStructure/ooadt
//Developed by AugustusWillisWang

#include <iostream>
#include <algorithm>
#include <vector>

#include "adt.h"
#include "dbg.h"

using std::istream;
using std::ostream;
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
  String_C(const String_C &); //StrCopy
  // String_C(const String_H &);
  // String_C(const String_L &);
  ~String_C(); //DelString
  void operator=(char *);
  void operator=(const String_C &);
  // String_C operator=(const String_H &);
  // String_C operator=(const String_L &);

  int empty();                   //StrEmpty
  int compare(const String_C &); //StrCmp
  friend int compare(const String_C &, const String_C &);
  int length();
  int clear();
  int adhere(String_C &src);
  int cat(String_C &src);
  String_C sub_string(int pos, int len)const;
  int index(String_C &sub_string, int start_pos = 0);
  int replace(String_C &target, String_C &src);
  int insert(int ins_before, String_C &src);
  int del(int pos, int len);
  int kmp(String_C &target);

  virtual int print();
  friend ostream &operator<<(ostream &output, const String_C S);

private:
  char *data_;
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

int char_string_size(char *src)
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
  // data_ = new char [1];
  *data_ = 0;
}

String_C::String_C(char *src)
{
  int i;
  data_ = new char [char_string_size(src) + 1];
  char *pdata = data_;
  do
  {
    *pdata = *src;
    ++pdata;
    ++src;
  } while (*src != 0);
}

String_C::String_C(const String_C &) //StrCopy
{
}
// String_C(const String_H &);
// String_C(const String_L &);
String_C::~String_C()
{
  delete data_;
}

void String_C::operator=(char *)
{
}

void String_C::operator=(const String_C &)
{
}
// String_C operator=(const String_H &);
// String_C operator=(const String_L &);

String_C::empty() //StrEmpty
{
  return 0;
}

String_C::compare(const String_C &) //StrCmp
{
  return 0;
}
int compare(const String_C &, const String_C &)
{
  return 0;
}

String_C::length()
{
  return 0;
}

String_C::clear()
{
  return 0;
}

String_C::adhere(String_C &src)
{
  return 0;
}

String_C::cat(String_C &src)
{
  return 0;
}

String_C String_C::sub_string(int pos, int len)const
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

int String_C::index(String_C &sub_string, int start_pos)
{
  return 0;
}
String_C::replace(String_C &target, String_C &src)
{
  return 0;
}
String_C::insert(int ins_before, String_C &src)
{
  return 0;
}
String_C::del(int pos, int len)
{
  return 0;
}
String_C::kmp(String_C &target)
{
  return 0;
}

String_C::print()
{
  printf("%s", data_);
}
ostream &operator<<(ostream &output, const String_C S);

// String_C::ostream &operator<<();

int main(int argc, char *argv[])
{
  String_C a((char *)"22223333");
  a.print();
  // String_C b = (char *)"123468";
}