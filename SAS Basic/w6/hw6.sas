LIBNAME STAT480 '/home/u63067448/lab6';

DATA movies;
	infile '/home/u63067448/lab6/movies-2.txt';
	input movie $ 1-16
		  director $ 18-44
		  @46 release MMDDYY10.
		  @57 budget
		  @67 revenue;
		  profit= 1-(budget/revenue);
RUN;

proc sort data = movies out = srtd_movies;
 by descending profit;
RUN;

proc print data = srtd_movies noobs label double split='/';
	title 'Blockbuster Movies';
	sum revenue;
	footnote 'Price Obtained from TheNumbers.com';
	id movie;
	format budget dollar15.2 revenue dollar18.2 release MMDDYY8. profit;
	var director release budget revenue profit;
	where profit >= 0.75;
	label movie = 'Movie Title'
		director = 'Director(s)'
		release = 'Release/Date'
		budget = 'Budget of / Movie'
		revenue = 'Worldwide Gross / Revenue'
		profit = 'Percentage / Profit';
RUN;