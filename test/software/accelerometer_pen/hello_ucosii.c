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
 * Name        : test_niosII_uart_sdcard.c
 * Author      : Group 2
 * Project     : ECE492 - Group 2 accelerometer pen
 * Description : Testing reading from UART and writing and reading from SDCard
 * Date		   : Mar 17, 2014
**************************************************************************/

#include <stdio.h>
#include "includes.h"
#include <stdio.h>
#include <system.h>
#include "altera_up_avalon_character_lcd.h"
#include "altera_avalon_pio_regs.h"
#include "altera_up_avalon_rs232.h"
#include "altera_up_avalon_rs232_regs.h"
#include <altera_up_sd_card_avalon_interface.h>
#include <time.h>
#include "dtw.h"
#include <stdlib.h>

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK taskModeSelect_stk[TASK_STACKSIZE];
OS_STK taskCalibrate_stk[TASK_STACKSIZE];
OS_STK taskUartRead_stk[TASK_STACKSIZE];
OS_STK taskDTWX_stk[TASK_STACKSIZE];
OS_STK taskReadSDCard_stk[TASK_STACKSIZE];
OS_STK SWQ_stk[TASK_STACKSIZE];


/* Definition of Task Priorities */
#define TASKMODESELECT_PRIORITY 		1
#define TASKCALIBRATE_PRIORITY 		2
#define TASKUARTREAD_PRIORITY 		3
#define TASKDTWX_PRIORITY      4
#define TASKREADSDCARD_PRIORITY      5

#define BUFFER_SIZE 10
#define MSG_QUEUE_SIZE 512
#define SW_READ 1
#define SW_WRITE 2
#define WRITE_FIFO_EMPTY 0x80
#define READ_FIFO_EMPTY 0x0

//#define START '.'
//#define END   ','
#define INPUT_SIZE 100
#define CHAR_ARRAY_BUFF_SIZE 10
#define DTW_BASE 10000
#define X_COORD_BASE 2000
#define Y_COORD_BASE 2000
//#define MESSAGE

/*Semaphore Declaration*/
OS_EVENT *uartsem;
OS_EVENT *configuresem;
OS_EVENT *writesem;
OS_EVENT *readsem;
OS_EVENT *message;
OS_EVENT *dtw_sem;
void *messageArray[MSG_QUEUE_SIZE];

OS_EVENT *SWQ;

INT8U err;

/* SRAM memory Addresses */
typedef struct{
	volatile alt_u32 * pX;
	volatile alt_u32 * pY;
	int size;
}character;

character array[10];
character template[10];
character *pCharacter;

void loadSDCard(int val);

void taskModeSelect(void* pdata){
	while(1){

		if (IORD_ALTERA_AVALON_PIO_DATA(SWITCH_BASE) == 1) {
			loadSDCard(1);
			err = OSSemPost(uartsem);
		} else {
			err = OSSemPost(configuresem);
		}
		//OSTimeDlyHMSM(0, 0, 0, 50);
		break;
	}
	return;
}

void loadSDCard(int val) {
	short int sd_fileh;
	//char * read_buffer[SD_BUFFER_SIZE];
	//int index;
	int i;
	int j;

	//OSSemPend(readsem, 0, &err);

	for(i=0; i < CHAR_ARRAY_BUFF_SIZE; i++){
		template[i].pX = ((alt_u32*) SRAM_0_BASE) + sizeof(int)*(DTW_BASE + X_COORD_BASE + Y_COORD_BASE + INPUT_SIZE*i);
		template[i].pY = ((alt_u32*) SRAM_0_BASE) + sizeof(int)*(DTW_BASE + X_COORD_BASE + X_COORD_BASE + Y_COORD_BASE + INPUT_SIZE*i);
	}

	printf("SD Card Read Startup\n");

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

				//char * pbuffer = read_buffer;

				for(i = 0; i < CHAR_ARRAY_BUFF_SIZE; i++){
					template[i].size = (int) alt_up_sd_card_read(sd_fileh);
					for( j = 0;  j < template[i].size; j++){
						*(template[i].pX + sizeof(int)*j) = (int)(alt_up_sd_card_read(sd_fileh)*100);
					}
					for( j = 0;  j < template[i].size; j++){
						*(template[i].pY + sizeof(int)*j) = (int)(alt_up_sd_card_read(sd_fileh)*100);
					}
				}

//				char data = 1;
//				for (index = 0; data != '\0'; index++) {
//					data = alt_up_sd_card_read(sd_fileh);
//					*pbuffer = data;
//					pbuffer = pbuffer + (sizeof(char));
//				}
//				*pbuffer = '\0';

				printf("Done!\n");
				printf("Closing File...");
				alt_up_sd_card_fclose(sd_fileh);
				printf("Done!\n");
				//printf("read buffer contains: ");
				//printf("%s\n", read_buffer);
				//OSQPost(message, (void*) &read_buffer);
			}
		}
	}
	return;
}

/* Calibrates the pen*/
void taskCalibrate(void* pdata) {
	OSSemPend(configuresem, 0, &err);
	alt_u16 read_FIFO_used;
	alt_u8 data_R8;
	unsigned p_error;
	alt_up_rs232_dev* rs232_dev;
	int buffer[BUFFER_SIZE];
	int index = 0;
	int i;
	int start = 0;
	//int sram_ready = 0;
	int coord = 0;
	int current_address = 0;
	int reading = 0;
	//int msg[BUFFER_SIZE];
	//int val;

	buffer[0] = -1;
	buffer[1] = -1;

	for(i=0; i < CHAR_ARRAY_BUFF_SIZE; i++){
		array[i].pX = ((alt_u32*) SRAM_0_BASE) + sizeof(int)*(DTW_BASE + INPUT_SIZE*i);
		array[i].pY = ((alt_u32*) SRAM_0_BASE) + sizeof(int)*(DTW_BASE + X_COORD_BASE + INPUT_SIZE*i);
	}

	// open the RS232 UART port
	rs232_dev = alt_up_rs232_open_dev("/dev/rs232_0");
	if (rs232_dev == NULL)
		printf("Error: could not open RS232 UART\n");
	else
		printf("Opened RS232 UART device\n");

	alt_up_rs232_enable_read_interrupt(rs232_dev);

	printf("UART Read For Configuration\n");
	while (1) {

//		//character values read
//		if((buffer[0] != -1)){
//
//			//resource available
//			if (OSSemAccept(dtw_sem) == 1) {
//
//				pCharacter = &array[buffer[0]];
//				err = OSQPost(message, (void*) &buffer);
//
//				//shift to next in queue
//				if(buffer[1] != -1){
//					buffer[0] = buffer[1];
//					//
//					if(buffer[1] != current_address){
//						if(buffer[1]==CHAR_ARRAY_BUFF_SIZE - 1){
//							buffer[1] = 0;
//						}
//						else{
//							buffer[1]++;
//						}
//					}
//					else{
//						buffer[1] = -1;
//					}
//				}
//				//nothing left in queue
//				else{
//					buffer[0] = -1;
//				}
//				//if(buffer[])
//			}
//		}
		if(current_address == 0){
			printf("Starting Calibration. Write the Character for 0\n\n");
		}

		// Read from UART
		read_FIFO_used = alt_up_rs232_get_used_space_in_read_FIFO(rs232_dev);
		if (read_FIFO_used > READ_FIFO_EMPTY) {
			alt_printf("char stored in read_FIFO: %x\n", read_FIFO_used);
			alt_up_rs232_read_data(rs232_dev, &data_R8, &p_error);
			alt_printf("read %c from RS232 UART\n", data_R8);

			if (reading == 0) {
				reading = 1;
				if (current_address == CHAR_ARRAY_BUFF_SIZE - 1) {
					current_address = 0;
				}
				else {
					current_address++;
				}
			 }

			if(coord == 0) {
				*(array[current_address].pX + sizeof(char)*index) = (data_R8);
				coord = 1;
				//index++;
			}
			else {
				*(array[current_address].pY +  sizeof(char)*index) = (data_R8);
				index++;
				coord = 0;
			}

		}
			else {
			//detect end of character values
			if (reading) {
				start++;
				//finished character value
				if (start == 2) {
					array[current_address].size = index + 1;
					if(current_address != CHAR_ARRAY_BUFF_SIZE - 1 ){
						printf("Finished reading character %d, write character %d\n", current_address, current_address + 1);
					}
					else{
						printf("Finished reading character %d, Starting SDCard Write Task\n", current_address);
						OSSemPost(writesem);
					}



//					//Check to see if there is a queue for dtw
//					//no queue
//					if (buffer[0] == -1 && buffer[1] == -1) {
//						buffer[0] = current_address;
//					}
//					//queue
//					else if (buffer[0] != -1 && buffer[1] == -1) {
//						buffer[1] = buffer[0] + 1;
//					}

					index = 0;
					start = 0;
					reading = 0;
				}
			}
		}
//		else {
//			//detect end of character values
//			if (reading) {
//				start++;
//				//finished character value
//				if (start == 2) {
//					array[current_address].size = index+1;
//
//					//Check to see if there is a queue for dtw
//					//no queue
//					if(buffer[0] == -1 && buffer[1] == -1){
//						buffer[0] = current_address;
//					}
//					//queue
//					else if (buffer[0] != -1 && buffer[1] == -1){
//						buffer[1] = buffer[0] + 1;
//					}
//
//					index = 0;
//					start = 0;
//					reading = 0;
//				}
//			}
//		}
		OSTimeDlyHMSM(0, 0, 0, 5);
	}
}

/* UART task: read*/
void taskUartRead(void* pdata) {
	OSSemPend(uartsem, 0, &err);
	alt_u16 read_FIFO_used;
	alt_u8 data_R8;
	unsigned p_error;
	alt_up_rs232_dev* rs232_dev;
	int buffer[BUFFER_SIZE];
	char * pbuffer = buffer;
	int index = 0;
	int i;
	int start = 0;
	//int sram_ready = 0;
	int coord = 0;
	int current_address = 0;
	int reading = 0;
	int msg[BUFFER_SIZE];
	int val;

	buffer[0] = -1;
	buffer[1] = -1;

	for(i=0; i < 10; i++){
		array[i].pX = ((alt_u32*) SRAM_0_BASE) + sizeof(int)*(DTW_BASE + INPUT_SIZE*i);
		array[i].pY = ((alt_u32*) SRAM_0_BASE) + sizeof(int)*(DTW_BASE + X_COORD_BASE + INPUT_SIZE*i);
	}

	// open the RS232 UART port
	rs232_dev = alt_up_rs232_open_dev("/dev/rs232_0");
	if (rs232_dev == NULL)
		printf("Error: could not open RS232 UART\n");
	else
		printf("Opened RS232 UART device\n");

	alt_up_rs232_enable_read_interrupt(rs232_dev);

	printf("UART Read Test\n");
	while (1) {

		//character values read
		if((buffer[0] != -1)){

			//resource available
			if (OSSemAccept(dtw_sem) == 1) {

				pCharacter = &array[buffer[0]];
				err = OSQPost(message, (void*) &buffer);

				//shift to next in queue
				if(buffer[1] != -1){
					buffer[0] = buffer[1];
					//
					if(buffer[1] != current_address){
						if(buffer[1]==CHAR_ARRAY_BUFF_SIZE - 1){
							buffer[1] = 0;
						}
						else{
							buffer[1]++;
						}
					}
					else{
						buffer[1] = -1;
					}
				}
				//nothing left in queue
				else{
					buffer[0] = -1;
				}
				//if(buffer[])
			}
		}

		// Read from UART
		read_FIFO_used = alt_up_rs232_get_used_space_in_read_FIFO(rs232_dev);
		if (read_FIFO_used > READ_FIFO_EMPTY) {
			alt_printf("char stored in read_FIFO: %x\n", read_FIFO_used);
			alt_up_rs232_read_data(rs232_dev, &data_R8, &p_error);
			alt_printf("read %c from RS232 UART\n", data_R8);

			if (reading == 0) {
				reading = 1;
				if (current_address == CHAR_ARRAY_BUFF_SIZE - 1) {
					current_address = 0;
				}
				else {
					current_address++;
				}
			 }

			if(coord == 0) {
				*(array[current_address].pX + sizeof(int)*index) = (int)(data_R8*100);
				coord = 1;
				//index++;
			}
			else {
				*(array[current_address].pY +  sizeof(int)*index) = (int)(data_R8*100);
				index++;
				coord = 0;
			}

		}
		else {
			//detect end of character values
			if (reading) {
				start++;
				//finished character value
				if (start == 2) {
					array[current_address].size = index+1;

					//Check to see if there is a queue for dtw
					//no queue
					if(buffer[0] == -1 && buffer[1] == -1){
						buffer[0] = current_address;
					}
					//queue
					else if (buffer[0] != -1 && buffer[1] == -1){
						buffer[1] = buffer[0] + 1;
					}

					index = 0;
					start = 0;
					reading = 0;
				}
			}
		}
		OSTimeDlyHMSM(0, 0, 0, 5);
	}
}

/* Checks for an SDCard, and Writes to the card if it is FAT16. Receives data from UART task */
void taskDTWX(void* pdata) {
	clock_t t;
	//short int sd_fileh;
	int index;
	char* msg;
	int * t1;
	//volatile alt_u32 * pSRAM = (alt_u32*) SRAM_0_BASE;
	//volatile alt_u32 * pSRAM2 = ((alt_u32*) SRAM_0_BASE) + sizeof(int)*INPUT_SIZE;

	//char buffer[SD_BUFFER_SIZE];// = "SD CARD test message\r\n\0";
	while (1) {
		msg = OSQPend(message, 0, &err);
		//buffer = msg;
		printf("DTW test\n");

		t1 = calloc(INPUT_SIZE, sizeof(int));
		if (t1 == NULL) {
			printf("1Error allocating memory\n"); //print an error message
			return;
		}

		t = clock();

		int answer = dtw((int*)pCharacter->pX, t1 , pCharacter->size, INPUT_SIZE);


		t = clock() - t;
		float time = ((float) t) / CLOCKS_PER_SEC;
		printf("%d   time = %f", answer, time);

		OSSemPost(dtw_sem);
	}
}

/* Checks for an SDCard, and Reads from the card if it is FAT16 from the file written to by taskDTWX  */
void taskReadSDCard(void* pdata) {
	short int sd_fileh;
	//char * read_buffer[SD_BUFFER_SIZE];
	int i;
	int j;
	while (1) {

		OSSemPend(writesem, 0, &err);
		printf("SD Card Write for configuration\n");

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
					printf("Problem creating file. Error %i", sd_fileh);
				else {
					printf("SD Accessed Successfully, writing data...");

					for(i = 0; i < CHAR_ARRAY_BUFF_SIZE; i++){
						alt_up_sd_card_write(sd_fileh, (char)array[i].size);
						for(j = 0; j < array[i].size; j++){
							alt_up_sd_card_write(sd_fileh, (char)(*(array[i].pX + j*sizeof(char))))
									;
						}
						for(j = 0; j < array[i].size; j++){
							alt_up_sd_card_write(sd_fileh, (char)(*(array[i].pY + j*sizeof(char))));
						}
					}

					//int index = 0;
//					while (*msg != '\0') {
//						alt_up_sd_card_write(sd_fileh, *msg);
//						//index++;
//						msg += sizeof(char);
//					}
					//alt_up_sd_card_write(sd_fileh, '\0');

					printf("Done!\n");
					printf("Closing File...");
					alt_up_sd_card_fclose(sd_fileh);
					printf("Done!\n\n");

					//OSSemPost(readsem);
				}
			}
		}
	}
}

/* The main function creates two tasks. The SD read task pends on the SD write task */
int main(void) {
	uartsem = OSSemCreate(0);
	configuresem = OSSemCreate(0);
	dtw_sem = OSSemCreate(0);

	message = OSQCreate(&messageArray, MSG_QUEUE_SIZE);

	//writesem = OSSemCreate(1);
	readsem = OSSemCreate(0);
	//SWQ = OSQCreate(SWQ_stk, TASK_STACKSIZE);

	OSTaskCreateExt(taskModeSelect, NULL, (void *) &taskModeSelect_stk[TASK_STACKSIZE - 1],
			TASKMODESELECT_PRIORITY, TASKMODESELECT_PRIORITY, taskModeSelect_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskCalibrate, NULL, (void *) &taskCalibrate_stk[TASK_STACKSIZE - 1],
			TASKCALIBRATE_PRIORITY, TASKCALIBRATE_PRIORITY, taskCalibrate_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskUartRead, NULL, (void *) &taskUartRead_stk[TASK_STACKSIZE - 1],
			TASKUARTREAD_PRIORITY, TASKUARTREAD_PRIORITY, taskUartRead_stk, TASK_STACKSIZE, NULL, 0);


	OSTaskCreateExt(taskDTWX, NULL, (void *) &taskDTWX_stk[TASK_STACKSIZE - 1],
			TASKDTWX_PRIORITY, TASKDTWX_PRIORITY, taskDTWX_stk, TASK_STACKSIZE, NULL, 0);


	OSTaskCreateExt(taskReadSDCard, NULL, (void *) &taskReadSDCard_stk[TASK_STACKSIZE - 1],
			TASKREADSDCARD_PRIORITY, TASKREADSDCARD_PRIORITY, taskReadSDCard_stk, TASK_STACKSIZE, NULL, 0);
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
