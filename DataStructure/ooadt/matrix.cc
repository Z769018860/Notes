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

class Matrix_S
{
    public:
      Matrix_S();
      ~Matrix_S();
      int print();
      Matrix_S transpose();
      friend Matrix_S operator+();
      friend Matrix_S operator-();
      friend Matrix_S operator*();

    private:
      int col_;
      int row_;
      int elem_;
      std::vector<int> rpos;
      std::vector<std::vector<int> > data;

};

int main()
{

}