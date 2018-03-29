//OO_ADT_Code Project
//https://github.com/L-F-Z/ADT_Code
//https://github.com/AugustusWillisWang/Notes/tree/master/DataStructure/ooadt
//Developed by AugustusWillisWang

#include <iostream>
#include <algorithm>
#include <vector>

#include "dbg.h"

class String
{
    public:
      String();//StrAssign
      String(const String &);//StrCopy
      ~String(); //DelString
      virtual int empty();//StrEmpty
      virtual int compare(const String &);//StrCmp
      virtual friend int compare(const String &, const String &);
      virtual int length();
      virtual int clear();
      virtual int adhere(String & src);
      virtual int cat(String & src);
      virtual String sub_string(int pos, int len);
      virtual int index(String sub_string, int start_pos=0);
      virtual int replace(String target, String src);
      virtual int insert(int ins_before, String src);
      virtual int del(int pos, int len);

    protected:
    private:
      char *data_;
};

class String_C: public String
{
    public:
      String_C();//StrAssign
      String_C(char*);//StrAssign
      String_C(const String_C &);//StrCopy
      String_C(const String_H &);
      String_C(const String_L &);
      ~String_C(); //DelString
      int empty();//StrEmpty
      int compare(const String_C &);//StrCmp
      friend int compare(const String_C &, const String_C &);
      int length();
      int clear();
      int adhere(String_C & src);
      int cat(String_C & src);
      String sub_string(int pos, int len);
      int index(String_C& sub_string, int start_pos=0);
      int replace(String_C& target, String_C& src);
      int insert(int ins_before, String_C& src);
      int del(int pos, int len);
      int kmp(String_C& target);

    private:
      char *data_;

};

class String_H: public String
{
    public:
      String_H();//StrAssign
      String_H(char*);//StrAssign
      String_H(const String_C &);//StrCopy
      String_H(const String_H &);
      String_H(const String_L &);
      ~String_H(); //DelString
      int empty();//StrEmpty
      int compare(const String_H &);//StrCmp
      friend int compare(const String_H &, const String_H &);
      int length();
      int clear();
      int adhere(String_H & src);
      int cat(String_H & src);
      String sub_string(int pos, int len);
      int index(String_H& sub_string, int start_pos=0);
      int replace(String_H& target, String_H& src);
      int insert(int ins_before, String_H& src);
      int del(int pos, int len);

    private:
      char *data_;
      int heap_size;
};

class String_L: public String
{
    public:
      String_L();//StrAssign
      String_L(char*);//StrAssign
      String_L(const String_C &);//StrCopy
      String_L(const String_H &);
      String_L(const String_L &);
      ~String_L(); //DelString
      int empty();//StrEmpty
      int compare(const String_L &);//StrCmp
      friend int compare(const String_L &, const String_L &);
      int length();
      int clear();
      int adhere(String_L & src);
      int cat(String_L & src);
      String sub_string(int pos, int len);
      int index(String_L& sub_string, int start_pos=0);
      int replace(String_L& target, String_L& src);
      int insert(int ins_before, String_L& src);
      int del(int pos, int len);

    private:
      char *data_;
      int node_size;
};

int char_string_size(char* src)
{
    int length=0;
    while (*src!=0)
    {
        ++length;
    }
    return length;
}

String_C::String_C(char* src)
{
    int i;
    data_ = new char[char_string_size(src) + 1];
    char *pdata = data_;
    do{
        *pdata = *src;
        ++pdata;
        ++src;
    } while (*src != 0);
}