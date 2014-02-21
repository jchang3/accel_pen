//============================================================================
// Name        : dtw.cpp
// Author      : Group 2 adapted from http://bytefish.de/blog/dynamic_time_warping/
// Project     : ECE492 - Group 2 accelerometer pen
// Description : DTW testing package
//============================================================================

#include <vector>

#ifndef DTW_H_
#define DTW_H_

namespace DTW {
    int dtw(const std::vector<int>& t1, const std::vector<int>& t2);
}

#endif