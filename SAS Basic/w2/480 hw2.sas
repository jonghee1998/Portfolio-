/************************************************
Create a temporary SAS data set called produce to read instream data using column input;
************************************************/

/*
LIBNAME stat480 '/home/u63067448/lab2';

DATA stat480.produce;
	input name $1-8 code 10-13  price 15-19 type $21-22;
	DATALINES;
BANANA   4011 0.69 	WT
GUAVA    4299 1.49 	EA
HONEYDEW 4034 3.99 	EA
CASHEW   3105 12.99 WT
SHALLOT  4662 1.29 	WT
RAPINI   4547 1.99 	EA
CELERY   4583 2.99 	EA
	;
RUN;

PROC PRINT data=stat480.produce;
  title 'produce';
RUN;

/* 2.1 
LIBNAME stat480 '/home/u63067448/lab2';
DATA stat480.portfolio;
  infile '/home/u63067448/lab2/stocks.dat';
  input name $1-4  price 9-14 height 8-9 share 17-19;
RUN;
 
PROC PRINT data=stat480.portfolio;
  title 'portfolio';
RUN;
*/

/* 2.2 */
LIBNAME stat480 '/home/u63067448/lab2';
DATA temp;
  set stat480.portfolio;
RUN;
 
PROC PRINT data=temp;
  title 'Temp_portfolio';
RUN;