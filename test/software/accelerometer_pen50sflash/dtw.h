//============================================================================
// Name        : dtw.h
// Author      : Group 2
// Project     : ECE492 - Group 2 accelerometer pen
// Description : DTW testing package using Sakoe-Chiba band boundaries for C
//============================================================================

#ifndef DTW_H_
#define DTW_H_

/* Returns DTW score from two integer pointers to arrays of values*/
extern long dtw(long * t1, long * t2, int m, int n, int coord);


#endif
