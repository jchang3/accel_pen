//============================================================================
// Name        : dtw.c
// Author      : Group 2
// Project     : ECE492 - Group 2 accelerometer pen
// Description : DTW testing package using Sakoe-Chiba band boundaries for C
//============================================================================

#include "dtw.h"
#include <math.h>
#include <stdlib.h>
#define INFIN 1000000000

int min_three(int a, int b, int c);
int min(int a, int b);
int max(int a, int b);
int dist(int x, int y);

/* Returns minimum of three numbers */
int min_three(int a, int b, int c){
	int min = a;
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
int dist(int x, int y) {
	return sqrtl((long)pow((x - y), 2));
}

int dtw(int * t1, int * t2, int n, int m) {
	int i;
	int j;
	int window = (int)(0.1*(max(m, n))+0.5); //band size of 10% max of m or n
	int constraint = abs(n-m);
	window = max(window, constraint);

	// create cost matrix
	int cost[m][n];

	// setup initial state of matrix
	for (i = 0; i < m; i++)
		for (j = 0; j < n; j++)
			cost[i][j] = INFIN;
	cost[0][0] = 0;

	// fill matrix
	for(i = 1; i < m; i++)
	for(j = max(1, i-window); j < min(n,i+window); j++)
			cost[i][j] = min_three(cost[i-1][j], cost[i][j-1], cost[i-1][j-1])
			+ dist(t1[i],t2[j]);

			return cost[m - 1][n - 1];
		}

