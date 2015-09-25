"""
 From http://stackoverflow.com/questions/5909873/python-pretty-printing-ascii-tables

>>> from collections import namedtuple
>>> Row = namedtuple('Row',['first','second','third'])
>>> data = Row(1,2,3)
>>> data
Row(first=1, second=2, third=3)
>>> pprinttable([data])
 first = 1
second = 2
 third = 3
>>> pprinttable([data,data])
first | second | third
------+--------+------
    1 |      2 |     3
    1 |      2 |     3     
"""

def pprinttable(rows):
  if len(rows) > 1:
    headers = rows[0]._fields
    lens = []
    for i in range(len(rows[0])):
      lens.append(len(max([x[i] for x in rows] + [headers[i]],key=lambda x:len(str(x)))))
    formats = []
    hformats = []
    for i in range(len(rows[0])):
      if isinstance(rows[0][i], int):
        formats.append("%%%dd" % lens[i])
      else:
        formats.append("%%-%ds" % lens[i])
      hformats.append("%%-%ds" % lens[i])
    pattern = " | ".join(formats)
    hpattern = " | ".join(hformats)
    separator = "-+-".join(['-' * n for n in lens])
    print hpattern % tuple(headers)
    print separator
    _u = lambda t: t.decode('UTF-8', 'replace') if isinstance(t, str) else t
    for line in rows:
        print pattern % tuple(_u(t) for t in line)
  elif len(rows) == 1:
    row = rows[0]
    hwidth = len(max(row._fields,key=lambda x: len(x)))
    for i in range(len(row)):
      print "%*s = %s" % (hwidth,row._fields[i],row[i])