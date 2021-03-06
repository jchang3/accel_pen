//============================================================================
// Name        : dtw.cpp
// Author      : Group 2
// Project     : ECE492 - Group 2 accelerometer pen
// Description : DTW testing package using Sakoe-Chiba band boundaries
//============================================================================


#include <vector>
#include <utility>
#include <cmath>
#include "dtw.h"
#include <iostream>
#include <fstream>

#define INFIN 10000000

namespace DTW {

	//euclidean distance
    int dist(int x, int y) {
        return sqrt(pow((x - y), 2));
    }

    //returns minimum of three numbers
    int minimum(int x, int y, int z){
    	return x < y ? (x < z ? x : z) : (y < z ? y : z);
    }

    //matrix output for debugging
    void print_matrix(int* cost, int m, int n){
    	        std::ofstream myfile;
    	        myfile.open ("example.txt");
    	        for(int i = 0; i < m; i++){
    	        	for(int j = 0; j < n; j++){
    	        		myfile << *(cost+(i*n+j)) << ", ";
    	            }
    	            myfile << std::endl;
    	        }
    	        myfile.close();
    }

    //dynamic programming approach
    int dtw(const std::vector<int>& t1, const std::vector<int>& t2) {

        int m = t1.size();
        int n = t2.size();
        int window = static_cast<int>(0.1*(std::max(m, n))+0.5);    //band size of 10% max of m or n
        int constraint = std::abs(n-m);
        window = std::max(window, constraint);

        // create cost matrix
        int cost[m][n];

        // setup initial state of matrix
        for(int i = 0; i < m; i++)
        	for(int j = 0; j < n; j++)
        		cost[i][j] = INFIN;
        cost[0][0] = 0;

        // fill matrix
        for(int i = 1; i < m; i++)
            for(int j = std::max(1, i-window); j < std::min(n,i+window); j++)
                cost[i][j] = minimum(cost[i-1][j], cost[i][j-1], cost[i-1][j-1])
                    + dist(t1[i],t2[j]);

        //print_matrix((int*)cost, m, n);
        return cost[m-1][n-1];
    }
}
