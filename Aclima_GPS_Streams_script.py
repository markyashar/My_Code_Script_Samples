import numpy as np
from numpy import *
import csv
import math
from math import *
import matplotlib
from matplotlib import *
import matplotlib.pyplot as plt
import matplotlib.dates as mdate
from pylab import *
import datetime as dt
from matplotlib.mlab import csv2rec
import matplotlib.mlab as mlab
from matplotlib.ticker import FormatStrFormatter, MultipleLocator
from matplotlib.ticker import *
import sys, fileinput
import time

with open("GPS_Streams_intermediate_output1.txt","rb") as source:
    rdr= csv.reader( source )
    with open("GPS_Streams_final_output.txt","wb") as result:
        wtr= csv.writer( result )
        for r in rdr:
            for i,x in enumerate(r[1:]):
                r[i+1] = float(x)

            true_speed_ms = (r[8]/r[2]+r[9]/r[3])/(1/r[2]+1/r[3])
            hdop = sqrt((r[2]*r[2] + r[3]*r[3])/2)
            
            x1 = cos(r[4]*math.pi/180) * cos(r[6]*math.pi/180)
            x2 = cos(r[5]*math.pi/180) * cos(r[7]*math.pi/180)
            y1 = cos(r[4]*math.pi/180) * sin(r[6]*math.pi/180)
            y2 = cos(r[5]*math.pi/180) * sin(r[7]*math.pi/180)
            z1 = sin(r[4]*math.pi/180)
            z2 = sin(r[5]*math.pi/180)
 
            x = (x1/r[2] + x2/r[3])/(1/r[2]+1/r[3])
            y = (y1/r[2] + y2/r[3])/(1/r[2]+1/r[3])
            z = (z1+z2)/2
 
            lon = atan2(y, x)*180/math.pi
            lat = atan2(z, sqrt(x * x + y * y))*180/math.pi


            true_track_deg = atan2( (sin(r[10]*math.pi/180) + sin(r[11]*math.pi/180))/2,  (cos(r[10]*math.pi/180) + cos(r[11]*math.pi/180))/2 )*180/math.pi 
            if true_track_deg < 0:
                true_track_deg = true_track_deg + 360
            else:
                true_track_deg = true_track_deg            
            wtr.writerow( (r[0], r[1], hdop, lat, lon, true_speed_ms, true_track_deg) )
# print r[0]
dates = matplotlib.dates.datestr2num(r[0])
# plt.plot(r[1],hdop)
fig, ax = plt.subplots()                                                                                                                                                                    
ax.plot_date(dates, r[1])                                                                                                                                                                   
date_fmt = '%H:%M:%S'                                                                                                                                                                       
date_formatter = mdate.DateFormatter(date_fmt)                                                                                                                                              
ax.xaxis.set_major_formatter(date_formatter)                                                                                                                                                

# Sets the tick labels diagonal so they fit easier.                                                                                                                                           
fig.autofmt_xdate()                                                                                                                                                                         
plt.savefig('testi2.png')
# plt.show()


# secs = mdate.epoch2num(r[0])
# dates = matplotlib.dates.datestr2num(r[0])
# print dates
# print r[0]
# plt.plot(r[1],hdop)
# fig, ax = plt.subplots()
# ax.plot_date(dates, r[1])
# date_fmt = '%H:%M:%S'
# date_formatter = mdate.DateFormatter(date_fmt)
# ax.xaxis.set_major_formatter(date_formatter)

# Sets the tick labels diagonal so they fit easier.
# fig.autofmt_xdate()

# plt.show()


# dateconv = np.vectorize(dt.datetime.fromtimestamp)
# ax = subplot(111)
# for label in ax.get_xticklabels() + ax.get_yticklabels():
#    label.set_fontsize(7.1)
# xfmt = md.DateFormatter('%H:%M:%S')
# ax.xaxis.set_major_formatter(xfmt)
# labels=ax.get_xticklabels()
# setp(labels, rotation=30, ha='right', fontsize=7.1)

# dates = matplotlib.dates.datestr2num(r[0])
# plt.plot(dates, r[1])
# plot_date(dates, r[1])
# plt.gcf().autofmt_xdate()

# plt.xlabel('Time Stamps')
# plt.ylabel('Heading')
# plt.title('Time vs. Heading (degrees)')
# plt.grid(True)
# plt.show()

# dates = dateconv(r[0]) # convert timestamps to datetime objects
# dates = matplotlib.dates.datestr2num(r[0])
# plt.plot(dates, r[1], label='the data')
# plt.xticks(dates, rotation=25) # set ticks at plotted datetimes
# ax=plt.gca()
# xfmt = md.DateFormatter('%H:%M:%S')
# ax.xaxis.set_major_formatter(xfmt)

# plt.tight_layout()
# plt.savefig('testi2.png')


# dates = matplotlib.dates.datestr2num(r[0])
# fig = plt.figure()
# ax = fig.add_subplot(111)
# ax.set_xticks(dates) # Tickmark + label at every plotted point
# ax.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M:%S'))


# ax.plot_date(dates, levels, ls='-', marker='o')
# ax.set_title('Time vs. Heading (degrees)')
# ax.set_ylabel('Heading (degrees)')
# ax.grid(True)

# datetimes = [datetime.datetimes.strptime(t, "%H:%M:%S+00:00") for t in r[0]]
# ax.plot(datetimes, r[1])
# dates = matplotlib.dates.datestr2num(r[0])
# ax.set_xticks(dates)
# plt.plot(dates,r[1])
# plt.gcf().autofmt_xdate()
# plt.show()

# Format the x-axis for dates (label formatting, rotation)
# fig.autofmt_xdate(rotation=45)
# fig.tight_layout()

# fig.show()

# time_format = '%H:%M:%S.%f'

# dates = [datetime.strp(str(x),'%H:%M:%S') for x in r[0]]
# plt.plot(dates,r[1])
