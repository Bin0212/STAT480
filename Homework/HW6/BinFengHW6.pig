/* Data preparation */
/* Read in data */
temperature = LOAD 'input/ncdc/HW6/Data1920s.txt' 
    AS (usaf: int, wban: int, year: int, temp: int);
station = LOAD 'input/ncdc/HW6/StationCodes.txt'
    AS (usaf: int, wban: int, location: chararray);

/* combine data */
combine = JOIN temperature BY $0, station BY $0;
/* remove repeated results: usaf, wban */
concise = FOREACH combine GENERATE $0, $1, $2, $3, $6;

/* Problem #1 */
/* limit to the first 5 rows */
result_1 = LIMIT concise 5;
/* store data */
STORE result_1 INTO 'input/ncdc/HW6/P1';

/* Problem #2 */
/* group by station */
group_concise = GROUP concise BY $4;
/* compute results */
result_2 = FOREACH group_concise GENERATE group, COUNT(concise.temperature::temp), 
    AVG(concise.temperature::temp), MAX(concise.temperature::temp), 
    MIN(concise.temperature::temp);
/* limit to the first 10 rows */
result_2 = LIMIT result_2 10;
/* store data */
STORE result_2 INTO 'input/ncdc/HW6/P2';

/* Problem #3 */
/* find the minimum temp station */
result_3_1 = FOREACH group_concise GENERATE group, MIN(concise.temperature::temp);
/* order the results */
result_order_3 = ORDER result_3_1 BY $1;
result_order_3 = LIMIT result_order_3 1;
DUMP result_order_3;

/* filter results by the station name */
min_station = FILTER concise BY $4 == 'SODANKYLA';
/* group by year */
group_min = GROUP min_station BY $2;
/* compute results */
result_3 = FOREACH group_min GENERATE group, MIN(min_station.temperature::temp), 
    AVG(min_station.temperature::temp), MAX(min_station.temperature::temp);
/* store data */
STORE result_3 INTO 'input/ncdc/HW6/P3';

/* Problem #4 */
/* compute results */
deviation = FOREACH group_concise GENERATE group, 
    (MAX(concise.temperature::temp) - AVG(concise.temperature::temp)), 
    (AVG(concise.temperature::temp) - MIN(concise.temperature::temp));
/* find the station with maximum deviation */
order_deviation = ORDER deviation BY $1 DESC;
max_deviation = LIMIT order_deviation 1;
/* store data */
STORE max_deviation INTO 'input/ncdc/HW6/P4_1';
/* create new join */
max_station = JOIN max_deviation by $0, concise by station::location;
/* remove repeated results: usaf, wban */
max_station_concise = FOREACH max_station GENERATE $0, $3, $4, $5, $6;
/* group by year */
group_max = GROUP max_station_concise BY $3;
result_4 = FOREACH group_max GENERATE group,
    (AVG(max_station_concise.temperature::temp) - 
        MIN(max_station_concise.temperature::temp));
/* store data */
STORE result_4 INTO 'input/ncdc/HW6/P4_2';