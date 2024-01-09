LIBNAME STAT480 '/home/u63067448/lab5';

DATA STAT480.bodyrisk;
	infile '/home/u63067448/lab5/bodyrisk-1.dat';
	input waist bmi whr;
	
	length waist_risk $4;
	if(waist=.) then waist_risk=' ';
	else if(waist<88.9) then waist_risk='Low';
	else if(waist>=88.9) then waist_risk='High';
	
	length bmi_risk $11;
	if(bmi=.) then bmi_risk=' ';
	else if(bmi<18.5) then bmi_risk='Underweight';
	else if(bmi>=30) then bmi_risk='Obesity';
	else if(18.5<=bmi<25) then bmi_risk='Normal';
	else if(25<=bmi<30) then bmi_risk='Overweight';
	
	length whr_risk $8;
	if(whr=.) then whr_risk=' ';
	else if(whr<=0.80) then whr_risk='Low';
	else if(0.80<=whr<=0.85) then whr_risk='Moderate';
	else if(whr>0.85) then whr_risk='High';
	
	RUN;

proc print data = STAT480.bodyrisk;
	title 'Output dataset: bodyrisk';
	var waist_risk bmi_risk whr_risk;
RUN;

	
	