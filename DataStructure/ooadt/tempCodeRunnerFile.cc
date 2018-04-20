Matrix_Sparse::Matrix_Sparse(const int *src, int row, int col)
// {
//   if (!src)
//     throw("Nullptr for initialzing Matrix_Sparse.");
//   int t;
//   struct Matrix_Sparse::MSdot tmpstr;
//   if (col > col_)
//   {
//     col_ = col;
//   }
//   if (row > row_)
//   {
//     row_ = row;
//   }

//   for (int a = 0; a < row; a++)
//   {
//     for (int b = 0; b < col; b++)
//     {
//       if (t=*(src+a*col+b) == 0)
//       {
//         continue;
//       }
//       else
//       {
//         {
//           tmpstr.a = a, tmpstr.b = b, tmpstr.data = t;
//         }
//         data.push_back(tmpstr);
//         elem_++;
//       }
//     }
//   }
// }