libname stat480 '/home/u63067448/lab9';

data stat480.countries;
    infile '/home/u63067448/lab9/countries.txt';
    input @1 name $11. @13 total_char $13. @27 net_change percent6.2 @35 prop_world @42 gdp_capita;
    total = input(compress(total_char, ','), best12.);
run;


proc format;
  invalue $countrycode
    'India' = 'IND'
    'Congo' = 'COG'
    'Azerbaijan' = 'AZE'
    'Thailand' = 'THA'
    'China' = 'CHN'
    'Romania' = 'ROU'
    'Chile' = 'CHL'
    'South Korea' = 'KOR'
    'Israel' = 'ISR'
    'Norway' = 'NOR';
  value netfmt
    low-<0 = 'Shirinking'
    0-high = 'Growing'
    other = 'N/A';
  picture worldpix
    other = '009.99%';
  picture gdpix
    low-high = '$00,000' (mult=1000 fill = '*' prefix = '$');
run;


/* 데이터셋 정렬 */
proc sort data=stat480.countries;
  by descending total;
run;

/* 데이터셋 출력 */
proc print data=stat480.countries noobs label;
  id name;
  var total net_change prop_world gdp_capita;
  format name $countrycode. 
         total comma13.
         net_change netfmt.
         prop_world worldpix.
         gdp_capita gdpix.;
  label name = 'Country'
        total = 'Population'
        net_change = 'Pop. Change'
        prop_world = 'Share of World Pop'
        gdp_capita = 'GDP per Capita';
  title 'Facts about Countries(2021)';
run;
