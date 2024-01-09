LIBNAME STAT480 '/home/u63067448/lab4';

DATA baseball;

	infile '/home/u63067448/lab4/batting.txt' delimiter=',';
	length Name $14;
	input Name $ Team $ AB R H Doubles Triples HR Walks HBP SacFlies;
	AVG = H/AB;
	Singles = H-Doubles-Triples-HR;
	SLG = (Singles + (2 * Doubles) + (3 * Triples) + (4 * HR)) / AB;
	OBP = (H+Walks+HBP)/(AB+Walks+HBP+SacFlies);
	OPS = SLG+OBP;
	RUN;
	
	
proc print data = baseball;
	title 'Output dataset: baseball';
	var name team AB AVG OPS;
RUN;
