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

#include <stdio.h>
#include <stdlib.h>
#include "includes.h"
#include "dtw.h"
#include <time.h>

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK task1_stk[TASK_STACKSIZE];
OS_STK task2_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2
#define INPUT_SIZE 75


OS_EVENT *sram_sem;
OS_EVENT *dtw_sem;


INT8U err;

/* Prints "Hello World" and sleeps for three seconds */
void task1(void* pdata) {
	volatile alt_u32 * pSRAM = (alt_u32*) SRAM_0_BASE;
	volatile alt_u32 * pSRAM2 = ((alt_u32*) SRAM_0_BASE) + sizeof(int)*INPUT_SIZE;
	int i;

	while(1){

		// Initialize seed
		srand(time(NULL));
		OSSemPend(sram_sem, 0, &err);
		printf("SRAM Write Test\n");

		/* Writes data to SRAM */
		printf("Writing to SRAM...\n");
		for (i = 0; i<INPUT_SIZE; i++) {
			//*(pSRAM + i) = i;
			*(pSRAM + i) = (-100*(rand() % 128)) + ((rand() % 129));
			*(pSRAM2 + i) = (-100*(rand() % 128)) + ((rand() % 129));
			//printf("%c",msg[i]);
			//end = pSRAM + i;
		}
		printf("Finished to SRAM\n");
		//(*end) = '\0';
		//char recv[MSG_QUEUE_SIZE];

		/* Checks output from SRAM */
		//printf("SRAM Write Test\n");
//
//		for (i = 0; i<INPUT_SIZE; i++) {
//			printf("%d\n", *(pSRAM2 + i));
//			//end = recv + i*sizeof(char);
//		}

		OSSemPost(dtw_sem);
		//printf("SRAM message is: %s\n", recv);
	}
}

/* Prints "Hello World" and sleeps for three seconds */
void task2(void* pdata) {
	volatile alt_u32 * pSRAM = (alt_u32*) SRAM_0_BASE;
	volatile alt_u32 * pSRAM2 = ((alt_u32*) SRAM_0_BASE) + sizeof(int)*INPUT_SIZE;
	int *t1;
	int *t2;
	int i;
	clock_t t;
	while (1) {
		OSSemPend(dtw_sem, 0, &err);

		t1 = malloc(INPUT_SIZE*sizeof(int));
		if (t1 == NULL) {
			printf("1Error allocating memory\n"); //print an error message
			return;
		}
		t2 = malloc(INPUT_SIZE*sizeof(int));
		if (t2 == NULL) {
			printf("Error allocating memory\n"); //print an error message
			return;
		}

		for(i=0; i< INPUT_SIZE; i++){
			t1[i] = *(pSRAM + i);
			t2[i] = *(pSRAM2 + i);
		}

		t = clock();
		//pass t1 and t2 to dtw
		//printf("3\n");
		int answer = dtw(pSRAM, pSRAM2, INPUT_SIZE, INPUT_SIZE);
		//answer = answer*answer;
		//runtime
		t = clock() - t;
		float time = ((float) t) / CLOCKS_PER_SEC;
		printf("%d   time = %f", answer, time);
		//printf("finished\n");
		free(t1);
		free(t2);
	}
}
/* The main function creates two task and starts multi-tasking */
int main(void) {
	sram_sem = OSSemCreate(1);
	dtw_sem = OSSemCreate(0);
	OSTaskCreateExt(task1, NULL, (void *) &task1_stk[TASK_STACKSIZE - 1],
			TASK1_PRIORITY, TASK1_PRIORITY, task1_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(task2, NULL, (void *) &task2_stk[TASK_STACKSIZE - 1],
			TASK2_PRIORITY, TASK2_PRIORITY, task2_stk, TASK_STACKSIZE, NULL, 0);
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
