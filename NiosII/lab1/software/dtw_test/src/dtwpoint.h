/*
 * dtwpoint.h
 *
 *  Created on: 2014-01-30
 *      Author: jchang3
 */

#ifndef DTWPOINT_H_
#define DTWPOINT_H_
#include <cstddef>

namespace Aquila
{
    /**
* A struct representing a single point in the DTW array.
*/
    struct DtwPoint
    {
        /**
* Creates the point with default values.
*/
        DtwPoint():
            x(0), y(0), dLocal(0.0), dAccumulated(0.0), previous(0)
        {
        }

        /**
* Creates the point and associates it with given coordinates.
*
* @param x_ x coordinate in DTW array
* @param y_ y coordinate in DTW array
* @param distanceLocal value of local distance at (x, y)
*/
        DtwPoint(std::size_t x_, std::size_t y_, double distanceLocal = 0.0):
            x(x_), y(y_), dLocal(distanceLocal),
            // at the edges set accumulated distance to local. otherwise 0
            dAccumulated((0 == x || 0 == y) ? dLocal : 0.0),
            previous(0)
        {
        }

        /**
* X coordinate of the point in the DTW array.
*/
        std::size_t x;

        /**
* Y coordinate of the point in the DTW array.
*/
        std::size_t y;

        /**
* Local distance at this point.
*/
        double dLocal;

        /**
* Accumulated distance at this point.
*/
        double dAccumulated;

        /**
* Non-owning pointer to previous point in the lowest-cost path.
*/
        DtwPoint* previous;
    };
}




#endif /* DTWPOINT_H_ */
