libname stat480 '/home/u63067448/lab10';

data cars;
infile '/home/u63067448/lab10/cars.dat';
	input brand $ 1-14
		  year $ 15-19
		  transmission $ 20-21
		  gears
		  driveline $24-27
		  city
		  highway;
run;


proc REPORT data= cars NOWINDOWS HEADLINE;
	title 'Cars 2009-2012';
	column Year transmission gears city highway expected;
       where Year in ('2009','2010','2011','2012');
       define Year/group 'Year';
       define transmission/group 'Automatic or Manual'
       						width=7 center;
       define gears/max spacing=5'Max Number of Forward Gears' 
       				 center;
       define city/mean 'Average MPG in Cities'format= 4.1 
       				width=7 center;
       define highway/mean'Average MPG on Highways' format= 4.1
       				width=7 center;
       define expected/computed 'Expected MPG' format= 4.1 
       				width=7 center;
       compute expected;
       expected = round(6/10*city.mean + 4/10*highway.mean, 0.1);
       endcomp;
run;

