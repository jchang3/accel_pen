/*
 * dtw.h
 *
 *  Created on: 2014-01-30
 *      Author: jchang3
 */

#ifndef DTW_H_
#define DTW_H_


//#include "../global.h"
//#include "../functions.h"
#include "dtwpoint.h"
#include <cstddef>
#include <vector>
#include <functional>
#include <iostream>
#include <cmath>

namespace Aquila
{
    /**
* Type of compared data - vectors of features, which themselves are
* vectors of doubles.
*/
    typedef std::vector<std::vector<double> > DtwDataType;

    /**
* Type of DTW point array.
*/
    typedef std::vector<std::vector<DtwPoint> > DtwPointsArrayType;

    /**
* Lowest-cost path is a vector of points.
*/
    typedef std::vector<DtwPoint> DtwPathType;


    //typedef std::function<double(const std::vector<double>&, const std::vector<double>&)> DistanceFunctionType;

    //double (*euclideanDistance_ptr)(void* v1, void* v2);
    /** Euclidean Distance function **/
    double euclideanDistance(const std::vector<double>& v1,
                                                      const std::vector<double>& v2)
        {
            double distance = 0.0;
            for (std::size_t i = 0, size = v1.size(); i < size; i++)
            {
                distance += (v1[i] - v2[i])*(v1[i] - v2[i]);
            }

            return std::sqrt(distance);
        }

    /**
* Dynamic Time Warping implementation.
*/
    class Dtw
    {
    public:
        /**
* Type of lowest-cost passes between points.
*/
        enum PassType {Neighbors, Diagonals};

        /**
* Creates the DTW algorithm wrapper object.
*
* @param distanceFunction which function to use for calculating distance
* @param passType pass type - how to move through distance array
*/
        Dtw(void * distanceFunction, PassType passType):/*(/*DistanceFunctionType distanceFunction double (*m_distanceFunction)(void* v1, void* v2) = &euclideanDistance,*/
            /*PassType passType = Neighbors):*/
            m_distanceFunction(&euclideanDistance), m_passType(Neighbors),
            m_points()
        {
        }

        double getDistance(const DtwDataType& from, const DtwDataType& to);

        /**
* Returns a const reference to the point array.
*
* @return DTW points
*/
        const DtwPointsArrayType& getPoints() const
        {
            return m_points;
        }

        /**
* Returns the final point on the DTW path (in the top right corner).
*
* @return a DTW point
*/
        DtwPoint getFinalPoint() const
        {
            return m_points[m_fromSize - 1][m_toSize - 1];
        }

        DtwPathType getPath() const;

    private:
        /**
* Distance definition used in DTW (eg. Euclidean, Manhattan etc).
*/
        /*DistanceFunctionType*/double (*m_distanceFunction)(const std::vector<double>& v1, const std::vector<double>& v2);

        /**
* Type of passes between points.
*/
        PassType m_passType;

        /**
* Array of DTW points.
*/
        DtwPointsArrayType m_points;

        /**
* Coordinates of the top right corner of the points array.
*/
        std::size_t m_fromSize, m_toSize;
    };
}

#endif /* DTW_H_ */
