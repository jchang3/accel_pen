//============================================================================
// Name        : dtw.c
// Author      : Group 2
// Project     : ECE492 - Group 2 accelerometer pen
// Description : DTW testing package using Sakoe-Chiba band boundaries for C
//============================================================================

#include "dtw.h"
#include <math.h>
#include <stdlib.h>
#include "includes.h"
#define INFIN 2147483646
#define DTW_BASE_Y 40000

long min_three(long a, long b, long c);
int min(int a, int b);
int max(int a, int b);
long dist(signed long x, signed long y);

/* Returns minimum of three numbers */
long min_three(long a, long b, long c){
	long min = a;
	if (min > b) min = b;
	if (min > c) min = c;
	return min;
}

/* Returns minimum of two numbers */
int min(int a, int b){
	int m = a;
	if (m > b) m = b;
	return m;
}

/* Returns maximum of two numbers */
int max(int a, int b){
	int m = a;
	if (m < b) m = b;
	return m;
}

// Euclidean distance
long dist(signed long x, signed long y) {
	return (long) sqrt(((signed long long)(x-y))*((signed long long)(x-y)));
	//return (x-y)*(x-y);
}

long dtw(long * t1, long * t2, int m, int n, int coord) {
	int i;
	int j;
	long zero = 0;
	volatile alt_u32 * pCost;
	int window = (int)(0.1*(max(m, n))+0.5); //band size of 10% max of m or n
	int constraint = abs(n-m);
	window = max(window, constraint);

	// create cost matrix
	//int cost[m][n];
	if(coord == 0){
		pCost = ((alt_u32*) SRAM_0_BASE);// + sizeof(int)*800;
	}
	else{
		pCost = ((alt_u32*) SRAM_0_BASE) + DTW_BASE_Y;
	}
	//long index = 0;
	// setup initial state of matrix
	for (i = 0; i < m; i++){
		for (j = 0; j < n; j++){
			*(pCost +(i*n+j)) = (signed long)INFIN;
			//cost[i][j]
			//printf("%d\n", index++);
		}
	}
	//cost[0][0] = 0;
	*pCost = zero;
	// fill matrix
	for (i = 1; i < m; i++) {
		for (j = max(1, i - window); j < min(n, i + window)+1; j++) {
			*(pCost +(i*n+j)) = min_three(
					(long)(*(pCost + ((i-1)*n+j))),
					(long)(*(pCost +(i*n+(j-1)))),
					(long)(*(pCost +((i-1)*n+(j-1)))))
					+ dist(t1[i], t2[j]);

		}
	}
	return (long)*(pCost + ((m-1)*n+(n-1)));
	//return pCost[m - 1][n - 1];

}

