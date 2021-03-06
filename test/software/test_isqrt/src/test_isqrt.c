/*
 ============================================================================
 Name        : test_isqrt.c
 Author      : Group
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C, Ansi-style
 ============================================================================
 */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
long isqrt(long x);
int main(void) {
	int a;
	int b;
	clock_t begin, end;
	float time_spent;


	begin = clock();
	a = (int) sqrtl(163840001);
	end = clock();
	time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
	printf("%d time = %f\n", a, time_spent);

	begin = clock();
	b = (int) isqrt(163840001);
	end = clock();
	time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
	printf("%d time = %f\n", b, time_spent);
	return EXIT_SUCCESS;
}

long isqrt (x) long x;{
  long   squaredbit, remainder, root;

   if (x<1) return 0;

   /* Load the binary constant 01 00 00 ... 00, where the number
    * of zero bits to the right of the single one bit
    * is even, and the one bit is as far left as is consistant
    * with that condition.)
    */
   squaredbit  = (long) ((((unsigned long) ~0L) >> 1) &
                        ~(((unsigned long) ~0L) >> 2));
   /* This portable load replaces the loop that used to be
    * here, and was donated by  legalize@xmission.com
    */

   /* Form bits of the answer. */
   remainder = x;  root = 0;
   while (squaredbit > 0) {
     if (remainder >= (squaredbit | root)) {
         remainder -= (squaredbit | root);
         root >>= 1; root |= squaredbit;
     } else {
         root >>= 1;
     }
     squaredbit >>= 2;
   }

   return root;
}
