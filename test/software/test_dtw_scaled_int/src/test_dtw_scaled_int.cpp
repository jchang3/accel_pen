//============================================================================
// Name        : test_dtw_scaled_int.cpp
// Author      : Group 2
// Project     : ECE492 - Group 2 accelerometer pen
// Description : DTW scaled integer testing package
//============================================================================

#include <vector>
#include <iostream>
#include "dtw.h"
#include <time.h>
#include <fstream>
#include <string>
#include <sstream>
using namespace std;

int main() {
	vector<int> t1;
	vector<int> t2;

	string line;
	ifstream file1("200hz.txt");
	if (file1.is_open()) {
		while (getline(file1, line)) {
			istringstream linestream(line);
			string data;
			double val;
			while (linestream >> val) {
				t1.push_back(static_cast<int>(val * 1000 + 0.5));
				t2.push_back(static_cast<int>(val * 1000 + 0.5));
			}
		}
		file1.close();
	} else {
		cout << "error opening file";
	}

	clock_t t;

	t = clock();

	//dtw output
	cout << "dist_dtw = " << DTW::dtw(t1, t2) << endl;

	//runtime
	t = clock() - t;
	float time = ((float) t) / CLOCKS_PER_SEC;
	cout << "runtime = " << time << "s " << t << "clockticks " << endl;

	return 0;
}
