libname stat480 '/home/u63067448/lab11';

data stat480.shows;
     infile '/home/u63067448/lab11/shows.csv' delimiter = ',' FIRSTOBS=2;
     length show_name $ 20 theater_name $ 13;
     informat date yymmdd10.;
     format date yymmdd10.;
     input date show_name $ theater_name $ type $ capacity gross;
run;

proc means data=stat480.shows;
    var capacity gross;
run;

proc means data=stat480.shows;
    class theater_name;
    var capacity gross;
run;

proc means data=stat480.shows mean median clm alpha=0.05;
    class theater_name type;
    var capacity gross;
run;



proc means data=stat480.shows mean std;
    class theater_name type;
    var capacity gross;
    output out=showSummary 
    mean = CapacityMean GrossMean 
    std = CapacityStd GrossStd;
run;

proc print data=showSummary;
    title "Summary by Theater Name and Type of Show";
run;

proc univariate data=stat480.shows;
	title "Percentiles for Capacity";
	var capacity;
run;