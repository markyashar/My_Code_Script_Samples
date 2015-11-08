import csv
with open("GPS_Streams.txt_orig","rb") as source:
    rdr= csv.reader( source )
    with open("GPS_Streams_intermediate_out.txt","wb") as result:
        wtr= csv.writer( result )
        for r in rdr:
            wtr.writerow( (r[0], r[1], r[4], r[5], r[6], r[7], r[10], r[11], r[16], r[17], r[18], r[19]) )
