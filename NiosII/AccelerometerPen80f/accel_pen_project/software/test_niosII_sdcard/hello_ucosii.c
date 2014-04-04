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
#include "includes.h"
#include <stdio.h>
#include <system.h>
#include <altera_up_sd_card_avalon_interface.h>

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK task1_stk[TASK_STACKSIZE];
OS_STK task2_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2

#define SD_BUFFER_SIZE 512

/*Semaphore Declaration*/
OS_EVENT *sem;
INT8U err;

/* Prints "Hello World" and sleeps for three seconds */
void task1(void* pdata) {
	short int sd_fileh;
	char buffer[SD_BUFFER_SIZE] = "WELCOME TO THE INTERFACE!!\r\n\0";
	printf("SD Card Write Test\n");

	alt_up_sd_card_dev *sd_card_dev = alt_up_sd_card_open_dev(
			ALTERA_UP_SD_CARD_AVALON_INTERFACE_0_NAME);

	if (sd_card_dev != 0) {
		if (alt_up_sd_card_is_Present()) {
			if (alt_up_sd_card_is_FAT16())
				printf("Card is FAT16\n");
			else
				printf("Card is not FAT16\n");

			sd_fileh = alt_up_sd_card_fopen("file.txt", true);

			if (sd_fileh < 0)
				printf("Problem creating file. Error %i", sd_fileh);
			else {
				printf("SD Accessed Successfully, writing data...");
				int index = 0;
				while (buffer[index] != '\0') {
					alt_up_sd_card_write(sd_fileh, buffer[index]);
					index = index + 1;
				}
				printf("Done!\n");

				printf("Closing File...");
				alt_up_sd_card_fclose(sd_fileh);
				printf("Done!\n");
				OSSemPost(sem);
			}
		}
	}
//  while (1)
//  {
//    printf("Hello from task1\n");
//    OSTimeDlyHMSM(0, 0, 3, 0);
//  }
}
/* Prints "Hello World" and sleeps for three seconds */
void task2(void* pdata) {

	OSSemPend(sem, 0, &err);
	printf("Hello from task2\n");
	short int sd_fileh;
	char buffer[SD_BUFFER_SIZE];
	printf("SD Card Read Test\n");

	alt_up_sd_card_dev *sd_card_dev = alt_up_sd_card_open_dev(
			ALTERA_UP_SD_CARD_AVALON_INTERFACE_0_NAME);

	if (sd_card_dev != 0) {
		if (alt_up_sd_card_is_Present()) {
			if (alt_up_sd_card_is_FAT16())
				printf("Card is FAT16\n");
			else
				printf("Card is not FAT16\n");

			sd_fileh = alt_up_sd_card_fopen("file.txt", false);

			if (sd_fileh < 0)
				printf("Problem accessing file. Error %i", sd_fileh);
			else {
				printf("SD Accessed Successfully, reading data...");

				int index;
				char * pbuffer = buffer;
				char data = alt_up_sd_card_read(sd_fileh);
				*pbuffer = data;

				for(index = 0; data != '\0'; index++) {
					data = alt_up_sd_card_read(sd_fileh);
					pbuffer = pbuffer + index*(sizeof(char));
					*pbuffer = data;
				}
				printf("Done!\n");
				printf("Closing File...");
				alt_up_sd_card_fclose(sd_fileh);
				printf("Done!\n");
				printf("%s\n", buffer);

			}
		}
	}
}
/* The main function creates two task and starts multi-tasking */
int main(void) {
	sem = OSSemCreate(0);
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
