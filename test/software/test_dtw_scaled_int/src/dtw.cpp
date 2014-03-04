//============================================================================
// Name        : dtw.cpp
// Author      : Group 2
// Project     : ECE492 - Group 2 accelerometer pen
// Description : DTW scaled integer testing package
//============================================================================


#include <vector>
#include <utility>
#include <cmath>
#include "dtw.h"
#include <iostream>
#include <fstream>


namespace DTW {

    int dist(int x, int y) {
        return sqrt(pow((x - y), 2));
    }

    //dynamic programming approach
    int dtw(const std::vector<int>& t1, const std::vector<int>& t2) {
        int m = t1.size();
        int n = t2.size();

        // create cost matrix
        int cost[m][n];

        cost[0][0] = dist(t1[0], t2[0]);
        // calculate first row
        for(int i = 1; i < m; i++)
            cost[i][0] = cost[i-1][0] + dist(t1[i], t2[0]);
        // calculate first column
        for(int j = 1; j < n; j++)
            cost[0][j] = cost[0][j-1] + dist(t1[0], t2[j]);
        // fill matrix
        for(int i = 1; i < m; i++)
            for(int j = 1; j < n; j++)
                cost[i][j] = std::min(cost[i-1][j], std::min(cost[i][j-1], cost[i-1][j-1]))
                    + dist(t1[i],t2[j]);


        std::ofstream myfile;
        myfile.open ("example.txt");
        for(int i = 0; i < m; i++){
                	for(int j = 0; j < n; j++){
                		myfile << cost[i][j] << ", ";
                	}
                	myfile << std::endl;
                }
        myfile.close();
        return cost[m-1][n-1];
    }
}
