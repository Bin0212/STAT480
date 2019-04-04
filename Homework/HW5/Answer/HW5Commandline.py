# STAT 480 HW 5 code examples Spring 2019, University of Illinois at Urbana-Champaign
# Darren Glosemeyer
#
# This file may not be distributed and may not be posted online without the express written consent of the author.
#
# Code is provided below to obtain the results. The report also needs sentences to interpret the results and answer the questions. 

# Change to data directory already created
cd ~/Stat480/hb-workspace/input/ncdc

# Run script to get data from 1915 to 1924
./ncdc_data.sh 1915 1924

# Make directory on HDFS to store the data, and copy the data there
hadoop fs -mkdir data1524
hadoop fs -put all/191[5-9].gz data1524
hadoop fs -put all/192*.gz data1524

## Change to directory where I stored my files
#cd ~/Stat480/Homework/Homework5/

# See the script files
#ls 
#HW5Ex1reduce_script.py  HW5Ex3map_script.py     HW5Ex4combine_script.py  HW5map_script.py
#HW5Ex2reduce_script.py  HW5Ex3reduce_script.py  HW5Ex4reducenocombine_script.py	HW5Ex4reduce_script.py



# Exercise 1
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
-files /home/glosemey/Stat480/Homework/Homework5/HW5map_script.py,\
/home/glosemey/Stat480/Homework/Homework5/HW5Ex1reduce_script.py \
  -input data1524 \
  -output outputEx1 \
  -mapper "/home/glosemey/Stat480/Homework/Homework5/HW5map_script.py" \
  -reducer "/home/glosemey/Stat480/Homework/Homework5/HW5Ex1reduce_script.py" 
  

# Monthly lows in degrees Celsius
[glosemey@sp19-0101 Homework5]$ hadoop fs -cat outputEx1/part*
01	-45.6
02	-47.8
03	-39.4
04	-31.1
05	-7.8
06	-2.8
07	1.1
08	0.0
09	-13.9
10	-28.9
11	-36.1
12	-42.8



# Exercise 2
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
-files /home/glosemey/Stat480/Homework/Homework5/HW5map_script.py,\
/home/glosemey/Stat480/Homework/Homework5/HW5Ex2reduce_script.py \
-input data1524 \
-output outputEx2 \
-mapper "/home/glosemey/Stat480/Homework/Homework5/HW5map_script.py" \
-reducer "/home/glosemey/Stat480/Homework/Homework5/HW5Ex2reduce_script.py"
  
# Results for count, min and max by month with temperatures in degrees Fahrenheit
[glosemey@sp19-0101 Homework5]$ hadoop fs -cat outputEx2/part*
01	6500	-50.08	44.96
02	6003	-54.04	44.96
03	6572	-38.92	62.96
04	6285	-23.98	77.0
05	6571	17.96	82.94
06	6342	26.96	89.06
07	6581	33.98	100.04
08	6505	32.0	86.0
09	6183	6.98	75.92
10	6502	-20.02	62.06
11	6294	-32.98	50.0
12	6504	-45.04	50.0



 
 
 
 
# Exercise 3
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
-files /home/glosemey/Stat480/Homework/Homework5/HW5Ex3map_script.py,\
/home/glosemey/Stat480/Homework/Homework5/HW5Ex3reduce_script.py \
-input data1524 \
-output outputEx3 \
-mapper "/home/glosemey/Stat480/Homework/Homework5/HW5Ex3map_script.py" \
-reducer "/home/glosemey/Stat480/Homework/Homework5/HW5Ex3reduce_script.py"
  
# Results  by month for counts of non-missing temps and observations with valid quality codes, respectively
[glosemey@sp19-0101 Homework5]$ hadoop fs -cat outputEx3/part*
01	6500	6500
02	6003	6005
03	6574	6595
04	6286	6286
05	6571	6578
06	6342	6365
07	6581	6595
08	6505	6508
09	6183	6202
10	6502	6502
11	6294	6294
12	6504	6504


 
# Exercise 4
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
-files /home/glosemey/Stat480/Homework/Homework5/HW5map_script.py,\
/home/glosemey/Stat480/Homework/Homework5/HW5Ex4combine_script.py,\
/home/glosemey/Stat480/Homework/Homework5/HW5Ex4reduce_script.py \
-input data1524 \
-output outputEx4 \
-mapper "/home/glosemey/Stat480/Homework/Homework5/HW5map_script.py" \
-combiner "/home/glosemey/Stat480/Homework/Homework5/HW5Ex4combine_script.py" \
-reducer "/home/glosemey/Stat480/Homework/Homework5/HW5Ex4reduce_script.py"
  
# Results for average temperature by month in degrees Celsius
[glosemey@sp19-0101 Homework5]$ hadoop fs -cat outputEx4/part*
01	-8.13858461538
02	-8.37404631018
03	-4.85763846622
04	1.01907716786
05	7.09373002587
06	12.0541784926
07	15.80205136
08	13.4259800154
09	9.11060973638
10	3.68974161796
11	-1.76580870671
12	-5.91194649446



# Alternate approach without a combiner
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
-files /home/glosemey/Stat480/Homework/Homework5/HW5map_script.py,\
/home/glosemey/Stat480/Homework/Homework5/HW5Ex4reducenocombine_script.py \
-input data1524 \
-output outputEx42 \
-mapper "/home/glosemey/Stat480/Homework/Homework5/HW5map_script.py" \
-reducer "/home/glosemey/Stat480/Homework/Homework5/HW5Ex4reducenocombine_script.py"


[glosemey@sp19-0101 Homework5]$ hadoop fs -cat outputEx42/part*
01	-8.13858461538
02	-8.37404631018
03	-4.85763846622
04	1.01907716786
05	7.09373002587
06	12.0541784926
07	15.80205136
08	13.4259800154
09	9.11060973637
10	3.68974161796
11	-1.7658087067
12	-5.91194649446
