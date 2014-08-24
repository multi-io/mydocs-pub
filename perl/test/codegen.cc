#include <stdio.h>

template<bool bnValue>
void DoStupidPrint()
{
   if (bnValue) printf("Hallo Isch bin ein Berliner!");
}

int main()
{
   DoStupidPrint<true>();
   DoStupidPrint<false>();
   bool b = false;
   //DoStupidPrint<b>();
}
