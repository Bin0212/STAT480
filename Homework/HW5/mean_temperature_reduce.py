#!/usr/bin/env python

import sys

(last_key, ave_temp, total) = (None, 0, 0)
for line in sys.stdin:
  (key, temp, count) = line.strip().split("\t")
  (key, temp, count) = (key, float(temp)/10, int(count))
  if last_key and last_key != key:
    print "%s\t%s\t%s" % (last_key, ave_temp, total)
    (last_key, ave_temp, total) = (key, temp, count)
  else:
    pre = ave_temp * total
    total = total + count
    (last_key, ave_temp, total) = (key, (temp + pre) / total, total)

if last_key:
  print "%s\t%s\t%s" % (last_key, ave_temp, total)
