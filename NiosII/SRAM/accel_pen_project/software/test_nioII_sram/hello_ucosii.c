/*************************************************************************
 * Copyright (c) 2004 Altera Corporation, San Jose, California, USA.      *
 * All rights reserved. All use of this software and documentation is     *
 * subject to the License Agreement located at the end of this file below.*
 **************************************************************************
 * Description:                                                           *
 * The following is a simple hello world program running MicroC/OS-II.The *
 * purpose of the design is to be a very simple application that just     *
 * demonstrates MicroC/OS-II running on NIOS II.The design doesn't account*
 * for issues such as checking system call return codes. etc.             *
 *                                                                        *
 * Requirements:                                                          *
 *   -Supported Example Hardware Platforms                                *
 *     Standard                                                           *
 *     Full Featured                                                      *
 *     Low Cost                                                           *
 *   -Supported Development Boards                                        *
 *     Nios II Development Board, Stratix II Edition                      *
 *     Nios Development Board, Stratix Professional Edition               *
 *     Nios Development Board, Stratix Edition                            *
 *     Nios Development Board, Cyclone Edition                            *
 *   -System Library Settings                                             *
 *     RTOS Type - MicroC/OS-II                                           *
 *     Periodic System Timer                                              *
 *   -Know Issues                                                         *
 *     If this design is run on the ISS, terminal output will take several*
 *     minutes per iteration.                                             *
 **************************************************************************/
/**************************************************************************
 * Name        : test_niosII_sram.c
 * Author      : Group 2
 * Project     : ECE492 - Group 2 accelerometer pen
 * Description : Testing SRAM Read and Writes
 * Date		   : Mar 3, 2014
**************************************************************************/
#include <stdio.h>
#include "includes.h"

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK task1_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define TASK1_PRIORITY      1

#define SRAM_WORDS 1000

/* Writes to SRAM and then checks the output by Reading from SRAM*/
void task1(void* pdata) {

	alt_u32 data;
	volatile alt_u32 * pSRAM = (alt_u32*)SRAM_0_BASE;
	int i;
	/* Writes data to SRAM */
	printf("Writing to SRAM...\n");
	for (i = 0; i < SRAM_WORDS; i++) {
		*(pSRAM+i) = i;
	}

	/* Checks output from SRAM */
	printf("Reading from SRAM...\n");
	for (i = 0; i < SRAM_WORDS; i++) {
			data = *(pSRAM+i);
			printf("%d  %08lX\n", i, data);
	}
}

/* The main function creates two task and starts multi-tasking */
int main(void) {

	OSTaskCreateExt(task1, NULL, (void *) &task1_stk[TASK_STACKSIZE - 1],
			TASK1_PRIORITY, TASK1_PRIORITY, task1_stk, TASK_STACKSIZE, NULL, 0);


	OSStart();
	return 0;
}

/******************************************************************************
 *                                                                             *
 * License Agreement                                                           *
 *                                                                             *
 * Copyright (c) 2004 Altera Corporation, San Jose, California, USA.           *
 * All rights reserved.                                                        *
 *                                                                             *
 * Permission is hereby granted, free of charge, to any person obtaining a     *
 * copy of this software and associated documentation files (the "Software"),  *
 * to deal in the Software without restriction, including without limitation   *
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
 * and/or sell copies of the Software, and to permit persons to whom the       *
 * Software is furnished to do so, subject to the following conditions:        *
 *                                                                             *
 * The above copyright notice and this permission notice shall be included in  *
 * all copies or substantial portions of the Software.                         *
 *                                                                             *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
 * DEALINGS IN THE SOFTWARE.                                                   *
 *                                                                             *
 * This agreement shall be governed in all respects by the laws of the State   *
 * of California and by the laws of the United States of America.              *
 * Altera does not recommend, suggest or require that this reference design    *
 * file be used in conjunction or combination with any other product.          *
 ******************************************************************************/
