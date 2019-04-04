##Q1
# Download dataset
cd ~/Stat480/hb-workspace/input/ncdc
chmod u+x ncdc_data.sh
./ncdc_data.sh 1915 1924
hadoop fs -put ~/Stat480/hb-workspace/input/ncdc/all/* input/ncdc/HW5
cd ~/Stat480/hb-workspace/ch02-mr-intro/src/main/python
cp max_temperature_map.py min_temperature_map.py
cp max_temperature_reduce.py min_temperature_reduce.py
vi min_temperature_map.py
vi min_temperature_reduce.py

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -files /home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/min_temperature_map.py,\
/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/min_temperature_reduce.py \
  -input input/ncdc/HW5/ \
  -output outputpy \
  -mapper "/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/min_temperature_map.py" \
  -reducer "/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/min_temperature_reduce.py"

  # View results.
  hadoop fs -cat outputpy/part*

  # Need to delete outputpy directory to use outputpy directory again.
  hadoop fs -rm -r -f outputpy

# Reuslts
# 01	-45.6
# 02	-47.8
# 03	-39.4
# 04	-31.1
# 05	-7.8
# 06	-2.8
# 07	1.1
# 08	0.0
# 09	-13.9
# 10	-28.9
# 11	-36.1
# 12	-42.8

##Q2
cp max_temperature_map.py trust_max_min_temperature_map.py
cp max_temperature_reduce.py trust_max_min_temperature_reduce.py
vi trust_max_min_temperature_map.py
vi trust_max_min_temperature_reduce.py

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -files /home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/trust_max_min_temperature_map.py,\
/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/trust_max_min_temperature_reduce.py \
  -input input/ncdc/HW5/ \
  -output outputpy \
  -mapper "/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/trust_max_min_temperature_map.py" \
  -reducer "/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/trust_max_min_temperature_reduce.py"

# Results ???how com if i put count as the first element, it will not group for different year
# 01	44.96	-50.08	6500
# 02	44.96	-54.04	6003
# 03	62.96	-38.92	6572
# 04	77.0	-23.98	6285
# 05	82.94	17.96	6571
# 06	89.06	26.96	6342
# 07	100.04	33.98	6581
# 08	86.0	32.0	6505
# 09	75.92	6.98	6183
# 10	62.06	-20.02	6502
# 11	50.0	-32.98	6294
# 12	50.0	-45.04	6504

## Q3
cp max_temperature_map.py count_temperature_map.py
cp max_temperature_reduce.py count_temperature_reduce.py
vi count_temperature_map.py
vi count_temperature_reduce.py

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -files /home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/count_temperature_map.py,\
/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/count_temperature_reduce.py \
  -input input/ncdc/HW5/ \
  -output outputpy \
  -mapper "/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/count_temperature_map.py" \
  -reducer "/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/count_temperature_reduce.py"

# Results ??? they are the sam
01	6500	6500
02	6003	6005
03	6572	6595
04	6285	6286
05	6571	6578
06	6342	6365
07	6581	6595
08	6505	6508
09	6183	6202
10	6502	6502
11	6294	6294
12	6504	6504

## Q4
cp min_temperature_map.py mean_temperature_map.py
cp min_temperature_reduce.py mean_temperature_reduce.py
vi mean_temperature_map.py
vi mena_temperature_reduce.py

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
  -files /home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/mean_temperature_map.py,\
/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/mean_temperature_reduce.py \
  -input input/ncdc/HW5/ \
  -output outputpy \
  -mapper "/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/mean_temperature_map.py" \
  -reducer "/home/binfeng2/Stat480/hb-workspace/ch02-mr-intro/src/main/python/mean_temperature_reduce.py"

# Results
# 01	-8.13858461538	6500
# 02	-8.37404631018	6003
# 03	-4.85763846622	6572
# 04	1.01907716786	6285
# 05	7.09373002587	6571
# 06	12.0541784926	6342
# 07	15.80205136	6581
# 08	13.4259800154	6505
# 09	9.11060973637	6183
# 10	3.68974161796	6502
# 11	-1.7658087067	6294
# 12	-5.91194649446	6504
