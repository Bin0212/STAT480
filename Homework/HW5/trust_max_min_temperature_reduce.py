#!/usr/bin/env python

import sys

(last_key, max_val, min_val, total) = (None, -sys.maxint, sys.maxint, 0)
for line in sys.stdin:
  (key, tmp_max, tmp_min, count) = line.strip().split("\t")
  (key, tmp_max, tmp_min, count) = (key, float(tmp_max)*9/50+32, float(tmp_min)*9/50+32, int(count))
  if last_key and last_key != key:
    print "%s\t%s\t%s\t%s" % (last_key, max_val, min_val, total)
    (last_key, max_val, min_val, total)  = (key, tmp_max, tmp_min, count)
  else:
    (last_key, max_val, min_val, total) = (key, max(max_val, tmp_max), min(min_val, tmp_min), total + count)

if last_key:
  print "%s\t%s\t%s\t%s" % (last_key, max_val, min_val, total)
