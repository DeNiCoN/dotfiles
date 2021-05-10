#!/usr/bin/python
# ----------------------------------------------------------------------------
# Author:  Nicolas P. Rougier
# License: BSD
# ----------------------------------------------------------------------------
import glob
import sys
import re
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta

def calmap(ax, year, data, origin="upper", weekstart="sun"):
    ax.tick_params('x', length=0, labelsize="medium", which='major')
    ax.tick_params('y', length=0, labelsize="x-small", which='major')

    # Month borders
    xticks, labels = [], []

    start = datetime(year,1,1).weekday()

    _data = np.zeros(7*53)*np.nan
    _data[start:start+len(data)] = data
    data = _data.reshape(53,7).T
    
    for month in range(1,13):
        first = datetime(year, month, 1)
        last = first + relativedelta(months=1, days=-1)
        if origin == "lower":
            y0 = first.weekday()
            y1 = last.weekday()
            x0 = (int(first.strftime("%j"))+start-1)//7
            x1 = (int(last.strftime("%j"))+start-1)//7
            P = [(x0, y0), (x0, 7), (x1, 7), (x1, y1+1),
                 (x1+1, y1+1), (x1+1, 0), (x0+1, 0), (x0+1, y0)]
        else:
            y0 = 6-first.weekday()
            y1 = 6-last.weekday()
            x0 = (int(first.strftime("%j"))+start-1)//7
            x1 = (int(last.strftime("%j"))+start-1)//7
            P = [(x0, y0+1), (x0, 0), (x1, 0), (x1, y1),
                  (x1+1, y1), (x1+1, 7), (x0+1, 7), (x0+1, y0+1)]
            
        xticks.append(x0 +(x1-x0+1)/2)
        labels.append(first.strftime("%b"))
        poly = Polygon(P, edgecolor="black", facecolor="None",
                       linewidth=1, zorder=20, clip_on=False)
        ax.add_artist(poly)
    
    ax.set_xticks(xticks)
    ax.set_xticklabels(labels)
    ax.set_yticks(0.5 + np.arange(7))

    labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    if origin == "upper": labels = labels[::-1]
    ax.set_yticklabels(labels)
    
    # Showing data
    cmap = plt.cm.get_cmap('Blues')
    ax.imshow(data, extent=[0, 53, 0, 7], zorder=10, cmap=cmap, origin=origin)

def parseNumClocksForYear(filepath, data_func):
    txt = glob.glob(filepath)
    global_data = np.zeros(366)
    for filename in txt:
        f = open(filename).read()
        got = re.findall(r"CLOCK: \[\d{4}-(\d{2})-(\d{2}) (Mon|Tue|Wed|Thu|Fri|Sat|Sun) \d{2}:\d{2}\]--\[\d{4}-\d{2}-\d{2} (Mon|Tue|Wed|Thu|Fri|Sat|Sun) \d{2}:\d{2}\] =>  (\d+):(\d{2})", f)
        data = np.zeros(366)
        for s in got:
            date = datetime(2020, int(s[0]), int(s[1]))
            data[date.timetuple().tm_yday - 1] += data_func(s)

        global_data += data
    return global_data

now = datetime.now()

fig = plt.figure(figsize=(8,4.5), dpi=150)
#Minutes
mins = parseNumClocksForYear("/home/denicon/Dropbox/Orgzly/*.org", 
    lambda x: int(x[4]) * 60 + int(x[5])) 

ax = plt.subplot(311, xlim=[0,53], ylim=[0,7], frameon=False, aspect=1)
ax.set_title("Minutes", size="medium", weight="bold")
calmap(ax, now.year, mins)

start = datetime(2020,1,1).weekday()
_data = np.zeros(7*53)
_data[start:start+len(mins)] = mins

ax = plt.subplot(312)
reshaped = _data.reshape(-1, 7) / 60.0
weeks = np.sum(reshaped, axis = 1)
avrg = 0
avrgc = 0
for i in weeks:
    if (i != 0.0):
        avrg += i
        avrgc += 1
ax.bar(np.arange(1, 54), weeks, width = 1.0, align="edge")
ax.axhline(avrg/avrgc, color="black", linewidth=1.0);
plt.xlim([1,54])
plt.tight_layout()
plt.savefig(sys.stdout.buffer, dpi=150)
