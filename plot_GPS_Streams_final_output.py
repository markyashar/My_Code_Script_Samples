import csv
import math
from math import *
from numpy import *
import matplotlib
from matplotlib import *
matplotlib.use('PDF')
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
from matplotlib.ticker import FormatStrFormatter, MultipleLocator
from matplotlib.ticker import *
from pylab import *
import sys, fileinput

def getColumn(filename, column):
    results = csv.reader(open(filename))
    return [result[column] for result in results]


heading= getColumn("GPS_Streams_final_output.txt",1)
hdop = getColumn("GPS_Streams_final_output.txt",2)
lat = getColumn("GPS_Streams_final_output.txt",3)
lon = getColumn("GPS_Streams_final_output.txt",4)
true_speed = getColumn("GPS_Streams_final_output.txt",5)
true_track = getColumn("GPS_Streams_final_output.txt",6)

ax=subplot(111)
for label in ax.get_xticklabels() + ax.get_yticklabels():
    label.set_fontsize(7.1)
fmt = FormatStrFormatter('%.6f')
ax.xaxis.set_major_formatter(fmt)
labels = ax.get_xticklabels()
setp(labels, rotation=20, ha='right', fontsize=7.1)
ax.yaxis.set_major_formatter(fmt)
ax.plot(lat,lon,'bo')
ax.set_title('Latitude vs. Longitude')
plt.xlabel("Latitude (degrees)")
plt.ylabel("Longitude (degrees)")
# plt.show()
savefig('GPS_lat_lon.pdf')
plt.close()

ax=subplot(111)
for label in ax.get_xticklabels() + ax.get_yticklabels():
    label.set_fontsize(7.1)
fmt = FormatStrFormatter('%.6f')
ax.xaxis.set_major_formatter(fmt)
labels = ax.get_xticklabels()
setp(labels, rotation=20, ha='right', fontsize=7.1)
ax.yaxis.set_major_formatter(fmt)
ax.plot(lon,lat,'bo')
ax.set_title('Longitude vs. Latitude')
plt.xlabel("Longitude (degrees)")
plt.ylabel("Latitude (degrees)")
# plt.show()
savefig('GPS_lon_lat.pdf')
plt.close()

ax=subplot(111)
for label in ax.get_xticklabels() + ax.get_yticklabels():
    label.set_fontsize(7.1)
fmt = FormatStrFormatter('%.6f')
ax.xaxis.set_major_formatter(fmt)
labels = ax.get_xticklabels()
setp(labels, rotation=20, ha='right', fontsize=7.1)
ax.yaxis.set_major_formatter(fmt)
ax.plot(heading,lat,'bo')
ax.set_title('Heading vs. Latitude')
plt.xlabel("Heading (degrees)")
plt.ylabel("Latitude (degrees)")
savefig('GPS_heading_lat.pdf')
plt.close()

