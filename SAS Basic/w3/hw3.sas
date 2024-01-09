/*1
LIBNAME STAT480 '/home/u63067448/lab3';

DATA STAT480.mortgage;
	LENGTH SSN $ 11;
	input gender $ 1 paygrade 3-4 SSN;
	DATALINES;
M 6 778-62-8144 
M 2 456-09-8732 
F 12 329-67-2398 
M 14 346-12-4592 
F 9 567-98-3409
F 8 349-92-9384
M 8 439-45-0394
;
RUN;


proc print data = STAT480.mortgage;
	title 'Output dataset: mortgage';
RUN;
*/

*2;
LIBNAME STAT480 '/home/u63067448/lab3';
DATA employees;
	infile 'employees.txt';
	input 	@1 Name $15.
			+1 Position $18.
			+1 StartDate DATE9.
			+1 EndDate MMDDYY8.;
	RUN;

proc print data = employees;
	title 'Output dataset: employees';
	Format StartDate DATE9. EndDate MMDDYY8.;
RUN;


	
		