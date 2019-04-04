#!/usr/bin/env python

import sys

(last_key, count_temp, count_qual) = (None, 0, 0)
for line in sys.stdin:
  (key, temp, qual) = line.strip().split("\t")
  if last_key and last_key != key:
    print "%s\t%s\t%s" % (last_key, count_temp, count_qual)
    (last_key, count_temp, count_qual) = (key, int(temp), int(qual))
  else:
    (last_key, count_temp, count_qual) = (key, int(temp) + count_temp, int(qual) + count_qual)

if last_key:
  print "%s\t%s\t%s" % (last_key, count_temp, count_qual)
