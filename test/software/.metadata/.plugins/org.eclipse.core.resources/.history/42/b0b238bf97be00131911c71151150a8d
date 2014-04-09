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
 * Name        : accelerometer_pen50sflash.c
 * Author      : Group 2
 * Project     : ECE492 - Group 2 accelerometer pen
 * Description : Flashed version of accelerometer pen
 * Date		   : Apr 04, 2014
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
#include <math.h>
#include <inttypes.h>
#include <sys/alt_cache.h>

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK taskModeSelect_stk[TASK_STACKSIZE];
OS_STK taskLoadSDCard_stk[TASK_STACKSIZE];
OS_STK taskCalibrate_stk[TASK_STACKSIZE];
OS_STK taskCharacterRead_stk[TASK_STACKSIZE];
OS_STK taskTemplateMatch_stk[TASK_STACKSIZE];
OS_STK taskDTWX_stk[TASK_STACKSIZE];
OS_STK taskDTWY_stk[TASK_STACKSIZE];
OS_STK taskWriteSDCard_stk[TASK_STACKSIZE];
OS_STK taskLcdPrint_stk[TASK_STACKSIZE];
OS_STK SWQ_stk[TASK_STACKSIZE];


/* Definition of Task Priorities */
#define TASKMODESELECT_PRIORITY 		1
#define TASKLCDPRINT_PRIORITY 			2
#define TASKLOADSDCARD_PRIORITY 		3
#define TASKCALIBRATE_PRIORITY 			4
#define TASKWRITESDCARD_PRIORITY     	5
#define TASKDTWX_PRIORITY    	  		6
#define TASKDTWY_PRIORITY      			7
#define TASKTEMPLATEMATCH_PRIORITY      8
#define TASKCHARACTERREAD_PRIORITY 		9


#define BUFFER_SIZE 10
#define MSG_QUEUE_SIZE 100
#define SW_READ 1
#define SW_WRITE 2
#define WRITE_FIFO_EMPTY 0x80
#define READ_FIFO_EMPTY 0x0
#define SEVEN_SEG	(int *)SEVEN_SEG_8_0_BASE
#define INPUT_SIZE 200
#define CHAR_ARRAY_BUFF_SIZE 4
#define TEMP_ARRAY_BUFF_SIZE 16
#define INFIN 2147483647

//sram memory allocations. values multiplied by sizeof(long).
#define DTW_BASE 80000 //200x200 x 2 for X and Y
#define X_COORD_BASE 2000 // 200 x 10
#define OFFSET 1200
#define Y_COORD_BASE 2000

/*Semaphore Declaration*/
OS_EVENT *uartsem;
OS_EVENT *configuresem;
OS_EVENT *writesem;
OS_EVENT *readsem;
OS_EVENT *message;
OS_EVENT *lcdmessage;
OS_EVENT *dtw_sem;
OS_EVENT *dtw_semx;
OS_EVENT *dtw_semy;
OS_EVENT *semx;
OS_EVENT *semy;
OS_EVENT *modeselectsem;
OS_EVENT *loadsdcardsem;
OS_EVENT *loadsem;
void *messageArray[MSG_QUEUE_SIZE];
void *lcdArray[MSG_QUEUE_SIZE];


OS_EVENT *SWQ;

INT8U err;

/* Structure for input values for DTW */
typedef struct{
	volatile alt_u32 * pX;
	volatile alt_u32 * pY;
	int size;
}character;

/* Structure for calibration values for SDCARD storage */
typedef struct{
	volatile alt_8 * pX;
	volatile alt_8 * pY;
	int size;
}character_8;

character array[CHAR_ARRAY_BUFF_SIZE];    //array for input data. Can hold a queue of up to 10 characters
character_8 array_8[TEMP_ARRAY_BUFF_SIZE];//array of 4x4 calibration data
character template[TEMP_ARRAY_BUFF_SIZE]; //array for 4x4 template values
character *pCharacter; //pointer to character being matched

typedef struct{
	int * t;
	int size;
}template_groups;

template_groups templates[4];

long dtwx; //used to compute dtw for x coordinates
long dtwy; //used to compute dtw for y coordinates
int template_number; //the current template being matched in dtw

clock_t t;


/* Task for mode selection. Choose between calibration mode and reading mode based on switch position*/
void taskModeSelect(void* pdata){
	OSSemPend(modeselectsem, 0, &err);
	printf("Starting ModeSelect\n");

	while(1){
		if (IORD_ALTERA_AVALON_PIO_DATA(SWITCH_BASE) == 1) {
			err = OSSemPost(loadsdcardsem);
			OSSemPend(loadsem, 0, &err);

			//template groups and sizes
			int t1[4] = {0, 1, 2, 3};
			int t2[4] = {4, 5, 6, 7};
			int t3[4] = {8, 9, 10, 11};
			int t4[4] = {12, 13, 14, 15};
			templates[0].t = t1;
			templates[1].t = t2;
			templates[2].t = t3;
			templates[3].t = t4;
			templates[0].size = 4;
			templates[1].size = 4;
			templates[2].size = 4;
			templates[3].size = 4;

			err = OSSemPost(uartsem);
		} else {
			err = OSSemPost(configuresem);
		}
		OSSemPend(modeselectsem, 0, &err);
	}
	return;
}

/*Prints message received from other tasks to LCD*/
void taskLcdPrint(void* pdata) {
	alt_up_character_lcd_dev * char_lcd_dev;
	char* msg;

	// open the Character LCD port
	char_lcd_dev = alt_up_character_lcd_open_dev("/dev/character_lcd_0");
	if (char_lcd_dev == NULL)
		alt_printf("Error: could not open character LCD device\n");
	else
		alt_printf("Opened character LCD device\n");

	alt_up_character_lcd_init(char_lcd_dev);

	while (1) {
		msg = OSQPend(lcdmessage, 0, &err);
		alt_up_character_lcd_init(char_lcd_dev);
		alt_up_character_lcd_string(char_lcd_dev, msg);
		OSTimeDlyHMSM(0, 0, 0, 500);
	}
}

/* Task that loads the character templates from the SDCard and deposits them in SRAM */
void taskLoadSDCard(void* pdata) {
	OSSemPend(loadsdcardsem, 0, &err);
	short int sd_fileh;
	int i;
	int j;
	short int a;
	int debug = -1;
	signed long test;

	for(i=0; i < TEMP_ARRAY_BUFF_SIZE; i++){

		template[i].pX = (alt_u8*)((alt_u8*) SRAM_0_BASE) + sizeof(long)*(DTW_BASE + X_COORD_BASE + Y_COORD_BASE + INPUT_SIZE*i);
		template[i].pY = (alt_u8*)((alt_u8*) SRAM_0_BASE) + sizeof(long)*(DTW_BASE + X_COORD_BASE + X_COORD_BASE + OFFSET + Y_COORD_BASE + INPUT_SIZE*i);//1200 for 16
	}

	while (1) {
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
					printf("SD Accessed Successfully, reading data...\n");

					for (i = 0; i < TEMP_ARRAY_BUFF_SIZE; i++) {
						template[i].size = (int) alt_up_sd_card_read(sd_fileh); //reads first byte of data which indicates the size of a template array
						if (i == debug) {
							printf(
									"X VALUES for %d -----------------------------------------------\n",
									debug);
						}
						for (j = 0; j < template[i].size; j++) {
							a = alt_up_sd_card_read(sd_fileh);
							*(((signed long*) template[i].pX) + j) =
									(signed long) (a);
							if (i == debug) {
								test = *(((signed long*) template[i].pX) + j);
								printf("%ld\n", test);
							}
						}

						if (i == debug) {
							printf(
									"Y VALUES for %d -----------------------------------------------\n",
									debug);
						}
						for (j = 0; j < template[i].size; j++) {
							a = alt_up_sd_card_read(sd_fileh);
							*(((signed long*) template[i].pY) + j) =
									(signed long) (a);
							if (i == debug) {
								test = *(((signed long*) template[i].pY) + j);
								printf("%ld\n", test);
							}
						}
						AverageTemplatePattern(i);
					}
					alt_up_sd_card_fclose(sd_fileh);
					err = OSSemPost(loadsem);
					OSSemPend(loadsdcardsem, 0, &err);
				}
			}
		}
	}
	return;
}

/* Applies a shifting average with 5 points to filter noise for templates. Division not applied to scale integer values for precision */
void AverageTemplatePattern(int i){
	int j;
	long prev_val_X[2] = {*(template[i].pX), *(template[i].pX+1)};
	long prev_val_Y[2] = {*(template[i].pY), *(template[i].pY+1)};
	for (j = 0; j < template[i].size; j++){
		long tempX = 0;
		long tempY = 0;
		if (j < template[i].size-2){
			tempX = *((long*)template[i].pX + j);
			tempY = *((long*)template[i].pY + j);
			*((long*)template[i].pX + j) = (prev_val_X[1] + prev_val_X[0] + *((long*)template[i].pX + j)
									+ *((long*)template[i].pX + (j+1)) + *((long*)template[i].pX + (j+2)))*2;
			*((long*)template[i].pY + j) = (prev_val_Y[1] + prev_val_Y[0] + *((long*)template[i].pY + j)
									+ *((long*)template[i].pY + (j+1)) + *((long*)template[i].pY + (j+2)))*2;
			prev_val_X[1] = prev_val_X[0];
			prev_val_X[0] = tempX;
			prev_val_Y[1] = prev_val_Y[0];
			prev_val_Y[0] = tempY;
		}
		else{
			tempX = *((long*)template[i].pX + j);
			tempY = *((long*)template[i].pX + j);
			*((long*)template[i].pX + j) = (prev_val_X[1] + prev_val_X[0] + *((long*)template[i].pX + j))*2;
			*((long*)template[i].pY + j) = (prev_val_Y[1] + prev_val_Y[0] + *((long*)template[i].pY + j))*2;
			prev_val_X[1] = prev_val_X[0];
			prev_val_X[0] = tempX;
			prev_val_Y[1] = prev_val_Y[0];
			prev_val_Y[0] = tempY;
		}
	}
}

/* Calibrates the pen, stores the calibrations in SRAM. Posts to the SDCard write task to save the data. */
void taskCalibrate(void* pdata) {
	OSSemPend(configuresem, 0, &err);
	alt_u16 read_FIFO_used;
	alt_8 data_R8;
	unsigned p_error;
	alt_up_rs232_dev* rs232_dev;
	int index = 0;
	int i;
	int start = 0;
	int coord = 0;
	int current_address = -1;
	char* lcdbuffer = "Calibrating\0";
	int reading = 0;

	for(i=0; i < TEMP_ARRAY_BUFF_SIZE; i++){
		array_8[i].pX = (alt_8*)((alt_u8*) SRAM_0_BASE) + sizeof(signed char)*(DTW_BASE + INPUT_SIZE*i);
		array_8[i].pY = (alt_8*)((alt_u8*) SRAM_0_BASE) + sizeof(signed char)*(DTW_BASE + X_COORD_BASE + OFFSET + INPUT_SIZE*i);//1200 for 16 templates
	}

	// open the RS232 UART port
	rs232_dev = alt_up_rs232_open_dev("/dev/rs232_0");
	if (rs232_dev == NULL)
		printf("Error: could not open RS232 UART\n");
	else
		printf("Opened RS232 UART device\n");

	alt_up_rs232_enable_read_interrupt(rs232_dev);

	printf("UART Read For Configuration\n");
	printf("Starting Calibration. Write character 0...\n\n");

	OSQPost(lcdmessage, lcdbuffer);
	while (1) {

		// Read from UART
		read_FIFO_used = alt_up_rs232_get_used_space_in_read_FIFO(rs232_dev);
		if (read_FIFO_used > READ_FIFO_EMPTY) {
			alt_up_rs232_read_data(rs232_dev, &data_R8, &p_error);

			if (reading == 0) {
				reading = 1;
				if (current_address == TEMP_ARRAY_BUFF_SIZE - 1) {
					current_address = 0;
				}
				else {
					current_address++;
				}
			 }

			if(coord == 0 && index <= INPUT_SIZE) {
				*((unsigned char*)array_8[current_address].pX + index) = data_R8;
				printf("x =%d\n", (short int)*((unsigned char*)array_8[current_address].pX + index));
				coord = 1;
			}
			else if(coord == 1){
				*((unsigned char*)array_8[current_address].pY + index) = (unsigned char)data_R8;
				printf("y =%d\n", (short int)*((unsigned char*)array_8[current_address].pY + index));

				if(index < INPUT_SIZE){
					index++;
				}
				coord = 0;
			}
			else{
				printf("sync issue\n");
			}

		}
			else {
			//detect end of character values
			if (reading) {
				start++;
				//finished character value
				if (start == 2) {
					array_8[current_address].size = index;
					if(current_address != TEMP_ARRAY_BUFF_SIZE - 1 ){
						printf("Finished reading character %d, write character %d...\n", current_address, current_address + 1);
					}
					else{
						printf("Finished reading character %d, Starting SDCard Write Task\n", current_address);
						OSSemPost(writesem);
						OSSemPend(configuresem, 0, &err);
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

/* Checks for an SDCard, and writes the configuration data to the card. Pends on the calibration task.  */
void taskWriteSDCard(void* pdata) {
	short int sd_fileh;
	int i;
	int j;
	alt_8 temp;
	bool b;
	char * lcdbuffer = "Finished Saving\0";
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
					printf("SD Accessed Successfully, writing data...\n");

					for(i = 0; i < TEMP_ARRAY_BUFF_SIZE; i++){
						temp = (unsigned char) array_8[i].size;
						alt_up_sd_card_write(sd_fileh, temp);

						//for x values
						for(j = 0; j < array_8[i].size; j++){
							temp = (*((unsigned char*)array_8[i].pX + j));
							b = alt_up_sd_card_write(sd_fileh, temp);
							if(!b){
								printf("error\n");
							}
						}
						//for y values
						for(j = 0; j < array_8[i].size; j++){
							temp = (*((unsigned char*)array_8[i].pY + j));
							alt_up_sd_card_write(sd_fileh, temp);
						}
					}
					alt_up_sd_card_write(sd_fileh, '\0');
					alt_up_sd_card_fclose(sd_fileh);
					printf("Done!\n\n");
					OSQPost(lcdmessage, lcdbuffer);
					OSSemPend(writesem, 0, &err);
				}
			}
		}
	}
}

/* Task to read a character from the UART */
void taskCharacterRead(void* pdata) {
	OSSemPend(uartsem, 0, &err);
	alt_u16 read_FIFO_used;
	alt_8 data_R8;
	unsigned p_error;
	alt_up_rs232_dev* rs232_dev;
	int buffer[BUFFER_SIZE];
	int index = 0;
	int i;
	int start = 0;
	int coord = 0;
	int current_address = -1;
	int reading = 0;
	int k;
	short int a;
	signed long test;
	char * lcdbuffer = "Ready to read\0";

	buffer[0] = -1;
	buffer[1] = -1;

	for(i=0; i < 10; i++){
		array[i].pX = ((alt_u32*) SRAM_0_BASE) + (DTW_BASE + INPUT_SIZE*i);
		array[i].pY = ((alt_u32*) SRAM_0_BASE) + (DTW_BASE + X_COORD_BASE + INPUT_SIZE*i);

	}

	// open the RS232 UART port
	rs232_dev = alt_up_rs232_open_dev("/dev/rs232_0");
	if (rs232_dev == NULL)
		printf("Error: could not open RS232 UART\n");
	else
		printf("Opened RS232 UART device\n");

	alt_up_rs232_enable_read_interrupt(rs232_dev);

	printf("UART Ready for input\n");
	OSQPost(lcdmessage, lcdbuffer);
	while (1) {

		//character values read
		if((buffer[0] != -1)){
			if (OSSemAccept(dtw_sem) == 1) {

				pCharacter = &array[buffer[0]];
				printf("X VALUES for current char -----------------------------------------------\n");
				for(k=0; k<pCharacter->size ;k++){
					test = *(((long*)pCharacter->pX)+k);
					printf("%ld\n",test);
				}
				printf("Y VALUES for current char -----------------------------------------------\n");
				for(k=0; k < pCharacter->size ;k++){
					test = *(((long*)pCharacter->pY)+k);
					printf("%ld\n",test);

				}

				printf("\n*********************POSTED TO DTW******************\n");

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
			alt_up_rs232_read_data(rs232_dev, &data_R8, &p_error);

			if (reading == 0) {
				reading = 1;
				if (current_address == CHAR_ARRAY_BUFF_SIZE - 1) {
					current_address = 0;
				}
				else {
					current_address++;
				}
			 }

			if(coord == 0 && index <= INPUT_SIZE) {
				a = (short int)(data_R8);
				*(array[current_address].pX + index) = (signed long)(a);
				coord = 1;
			}
			else
			if(coord == 1){
				a = (short int)(data_R8);
				*(array[current_address].pY + index) = (signed long)(a);
				if(index < INPUT_SIZE){
					index++;
				}
				coord = 0;
			}
			else{
				printf("sync issue\n");
			}

		}
		else {
			//detect end of character values
			if (reading) {
				start++;
				//finished character value
				if (start == 2) {

					printf("\n*********************FINISHED READING A CHARACTER******************\n");
					if(index <= INPUT_SIZE){
						array[current_address].size = index;
					}
					else{
						array[current_address].size = INPUT_SIZE;
					}

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
					coord = 0;
				}
			}
		}
		OSTimeDlyHMSM(0, 0, 0, 5);
	}
}


/* Task matches templates. Synchronized with the character input task. Spawns two threads which run dtw on the x and y axis. Computes final score.
 * Algorithm ignores tasks based on groups with similar profiles if the score is too high.*/
void taskTemplateMatch(void* pdata) {
	char* msg;
	long long best_match = INFIN;
	long long sec_best_match = INFIN;
	int match_group;
	int match = 0;
	int i;
	int j;
	long long score =0;
	signed long test;
	int k;
	char * lcdbuffer;

	while (1) {
		msg = OSQPend(message, 0, &err);

		lcdbuffer = "Processing...\0";
		OSQPost(lcdmessage, lcdbuffer);
		AverageCharReadPattern();

		printf("X VALUES for current char -----------------------------------------------\n");
		for(k=0; k<pCharacter->size ;k++){
			test = *(((long*)pCharacter->pX)+k);
			printf("%ld\n",test);
		}
		printf("Y VALUES for current char -----------------------------------------------\n");
		for(k=0; k < pCharacter->size ;k++){
			test = *(((long*)pCharacter->pY)+k);
			printf("%ld\n",test);

		}

		for(i=0; i < 4; i++){
			for(j=0; j < 4;j++){
				template_number = templates[i].t[j];
				OSSemPost(dtw_semx);
				OSSemPost(dtw_semy);
				OSSemPend(semx, 0, &err);
				OSSemPend(semy, 0, &err);

				score += (sqrt(((unsigned long)(dtwx * dtwx) + (unsigned long)(dtwy * dtwy)))) + (2*dtwx) + (2*dtwy);

				printf("dtwx = %ld   dtwy = %ld\n", dtwx, dtwy);
				printf("template %d score= %ld\n\n",template_number, score);

			}
			if(best_match > score){
						best_match = score;
						match = i;

					}
			score =0;
		}

		printf("best match is \'%d\' with score a of %ld\n", match, best_match);
		if(match == 0){
			lcdbuffer = "match CIRCLE";
		}
		if(match == 1){
			lcdbuffer = "match TRIANGLE";
		}
		if(match == 2){
			lcdbuffer = "match CHECK";
		}
		if(match == 3){
			lcdbuffer = "match LINE";
		}

		OSQPost(lcdmessage, lcdbuffer);
		best_match = INFIN;
		score = 0;
		match=0;
		OSSemPost(dtw_sem);
	}
}


/* Applies a shifting average with 5 points to filter noise for user input. Division not applied to scale integer values for precision */
void AverageCharReadPattern()
{
	int j;
	long prev_val_X[2] = {*((long*)pCharacter->pX), *((long*)pCharacter->pX+1)};
	long prev_val_Y[2] = {*((long*)pCharacter->pY), *((long*)pCharacter->pY+1)};
	for (j = 0; j < pCharacter->size; j++)
	{
		long tempX = 0;
		long tempY = 0;
		if (j < pCharacter->size-2)
		{
			tempX = *((long*)pCharacter->pX + j);
			tempY = *((long*)pCharacter->pY + j);
			*((long*)pCharacter->pX + j) = (prev_val_X[1] + prev_val_X[0] + *((long*)pCharacter->pX + j)
									+ *((long*)pCharacter->pX + (j+1)) + *((long*)pCharacter->pX + (j+2)))*2;
			*((long*)pCharacter->pY + j) = (prev_val_Y[1] + prev_val_Y[0] + *((long*)pCharacter->pY + j)
									+ *((long*)pCharacter->pY + (j+1)) + *((long*)pCharacter->pY + (j+2)))*2;
			prev_val_X[1] = prev_val_X[0];
			prev_val_X[0] = tempX;
			prev_val_Y[1] = prev_val_Y[0];
			prev_val_Y[0] = tempY;
		}
		else
		{
			tempX = *((long*)pCharacter->pX + j);
			tempY = *((long*)pCharacter->pX + j);
			*((long*)pCharacter->pX + j) = (prev_val_X[1] + prev_val_X[0] + *((long*)pCharacter->pX + j))*2;
			*((long*)pCharacter->pY + j) = (prev_val_Y[1] + prev_val_Y[0] + *((long*)pCharacter->pY + j))*2;
			prev_val_X[1] = prev_val_X[0];
			prev_val_X[0] = tempX;
			prev_val_Y[1] = prev_val_Y[0];
			prev_val_Y[0] = tempY;
		}
	}
}


/* Performs DTW on X coordinates */
void taskDTWX(void* pdata) {
	while (1) {
		OSSemPend(dtw_semx, 0, &err);
		dtwx = dtw( (long*)template[template_number].pX, (long*)(pCharacter->pX), template[template_number].size,  pCharacter->size, 0);
		OSSemPost(semx);
	}
}

/* Performs DTW on X coordinates */
void taskDTWY(void* pdata) {
	while (1) {
		OSSemPend(dtw_semy, 0, &err);
		dtwy = dtw( (long*)template[template_number].pY, (long*)(pCharacter->pY), template[template_number].size,  pCharacter->size, 1);
		OSSemPost(semy);
	}
}



/* The main function runs the accelerometer character recognition and calibration tests. */
int main(void) {
	modeselectsem = OSSemCreate(1);
	uartsem = OSSemCreate(0);
	configuresem = OSSemCreate(0);
	dtw_sem = OSSemCreate(1);
	loadsem = OSSemCreate(0);

	message = OSQCreate(&messageArray, MSG_QUEUE_SIZE);
	lcdmessage = OSQCreate(&lcdArray, MSG_QUEUE_SIZE);
	dtw_semx = OSSemCreate(0);
	dtw_semy = OSSemCreate(0);
	semx = OSSemCreate(0);
	semy = OSSemCreate(0);

	writesem = OSSemCreate(0);
	readsem = OSSemCreate(0);
	loadsdcardsem = OSSemCreate(0);

	OSTaskCreateExt(taskModeSelect, NULL, (void *) &taskModeSelect_stk[TASK_STACKSIZE - 1],
			TASKMODESELECT_PRIORITY, TASKMODESELECT_PRIORITY, taskModeSelect_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskLcdPrint, NULL, (void *) &taskLcdPrint_stk[TASK_STACKSIZE - 1],
			TASKLCDPRINT_PRIORITY, TASKLCDPRINT_PRIORITY, taskLcdPrint_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskLoadSDCard, NULL, (void *) &taskLoadSDCard_stk[TASK_STACKSIZE - 1],
			TASKLOADSDCARD_PRIORITY, TASKLOADSDCARD_PRIORITY, taskLoadSDCard_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskCalibrate, NULL, (void *) &taskCalibrate_stk[TASK_STACKSIZE - 1],
			TASKCALIBRATE_PRIORITY, TASKCALIBRATE_PRIORITY, taskCalibrate_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskCharacterRead, NULL, (void *) &taskCharacterRead_stk[TASK_STACKSIZE - 1],
			TASKCHARACTERREAD_PRIORITY, TASKCHARACTERREAD_PRIORITY, taskCharacterRead_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskTemplateMatch, NULL, (void *) &taskTemplateMatch_stk[TASK_STACKSIZE - 1],
			TASKTEMPLATEMATCH_PRIORITY, TASKTEMPLATEMATCH_PRIORITY, taskTemplateMatch_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskDTWX, NULL, (void *) &taskDTWX_stk[TASK_STACKSIZE - 1],
			TASKDTWX_PRIORITY, TASKDTWX_PRIORITY, taskDTWX_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskDTWY, NULL, (void *) &taskDTWY_stk[TASK_STACKSIZE - 1],
			TASKDTWY_PRIORITY, TASKDTWY_PRIORITY, taskDTWY_stk, TASK_STACKSIZE, NULL, 0);

	OSTaskCreateExt(taskWriteSDCard, NULL, (void *) &taskWriteSDCard_stk[TASK_STACKSIZE - 1],
			TASKWRITESDCARD_PRIORITY, TASKWRITESDCARD_PRIORITY, taskWriteSDCard_stk, TASK_STACKSIZE, NULL, 0);
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
