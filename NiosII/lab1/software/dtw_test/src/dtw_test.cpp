//============================================================================
// Name        : dtw_test.cpp
// Author      : James Chang
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
using namespace std;

int main() {
	cout << "!!!Hello World!!!" << endl; // prints !!!Hello World!!!
	static const int arr[] = {0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0};
	static const int arr2[] = {1.0,1.0,2.0,3.0,3.0,4.0,5.0,5.0,6.0,8.0,10.0};
	vector<double> v1 (arr, arr + sizeof(arr) / sizeof(arr[0]) );
	vector<double> v2 (arr2, arr2 + sizeof(arr2) / sizeof(arr2[0]) );


	const vector< vector<double> > vec;

	for (int i = 0; i < 10; i++) {
	    vector<double> row; // Create an empty row
	    for (int j = 0; j < 10; j++) {
	        row.push_back(i * j); // Add an element (column) to the row
	    }
	    vec.push_back(row); // Add the row to the main vector

	 const  vector< vector<double> > vec2;

	 for (int i = 0; i < 10; i++) {
		 vector<double> row; // Create an empty row
		 for (int j = 0; j < 10; j++) {
			 row.push_back(i * j); // Add an element (column) to the row
		 }
		 vec2.push_back(row); // Add the row to the main vector

			const vector * from = vec;
			const vector * to = vec2;
    Aquila::Dtw dtw(&vec);
    double distance = dtw.getDistance(vec2);
    std::cout << "Finished, distance = " << distance << std::endl;
    delete to;
    delete from;
    return 0;


	return 0;
}