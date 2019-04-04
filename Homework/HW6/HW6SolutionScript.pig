/* update file paths as needed */
A1920s = LOAD 'Data1920s.txt' AS (usaf:int, wban:int, year:int, temp:int); 
stations = LOAD 'StationCodes.txt' AS (usaf:int, wban:int, name:chararray); 
/* merged data set for exercise 1 */
final = JOIN A1920s BY $0 LEFT OUTER, stations BY $0;
final = FOREACH final GENERATE $0 AS usaf:int, $2 AS year:int, 
	$3 AS temp:int, $6 AS name:chararray;
/* get and store 5 results */
final5 = LIMIT final 5;
STORE final5 INTO 'merged5dir';


/* exercise 2; get count, min, mean and max for each station */
grouped = GROUP final by name;
ctminavgmax = FOREACH grouped GENERATE group, COUNT(final.temp) AS ct:int, MIN(final.temp) AS mintemp:int, 
	AVG(final.temp) AS avgtemp, MAX(final.temp) AS maxtemp:int;
ctminavgmax10 = LIMIT ctminavgmax 10;
STORE ctminavgmax10 INTO 'ctminavgmax10dir';


/* exercise 3; get results by year for stations with lowest recorded temp */
allgroup = GROUP ctminavgmax ALL;
minoverall = FOREACH allgroup GENERATE MIN(ctminavgmax.mintemp) AS lowest;
lowestrecorded = JOIN ctminavgmax BY mintemp, minoverall BY lowest;
lowestrecorded = FOREACH lowestrecorded GENERATE group AS station;
STORE lowestrecorded INTO 'lowest';
lowestdata = FILTER final BY name 
	IN ('SODANKYLA');
lowestdata = FOREACH lowestdata GENERATE name, year, temp;
lowestgrouped = GROUP lowestdata BY (name, year);
lowestbyyear = FOREACH lowestgrouped GENERATE FLATTEN(group) AS (station, year),
	MIN(lowestdata.temp) AS mintemp, AVG(lowestdata.temp) AS avgtemp, MAX(lowestdata.temp) AS maxtemp;
lowestbyyear = ORDER lowestbyyear BY station, year;
STORE lowestbyyear INTO 'minavgmaxforlowestbyyear'; 


/* exercise 4; temp max above mean for each station, and max above mean by year for station with largest overall difference */
abovedata = FOREACH ctminavgmax GENERATE $0, $4-$3 AS maxabove;
STORE abovedata INTO 'aboveranges';
sortedabove = ORDER abovedata BY $1 DESC;
maxabove = LIMIT sortedabove 1;
STORE maxabove INTO 'largestabove';
aberdeendata = FILTER final BY name=='ABERDEEN/DYCE AIRPO';
aberdeengrouped = GROUP aberdeendata BY year;
aberdeen = FOREACH aberdeengrouped GENERATE group, 
	AVG(aberdeendata.temp) - MIN(aberdeendata.temp);
STORE aberdeen INTO 'aberdeenbelow';
