import re
sourcefile = "GPS_Streams_intermediate_output.txt" 
filename2 = "GPS_Streams_intermediate_output1.txt"

offending = [",,",",,,",",,,,"]

def fixup( filename ): 
    fin = open( filename ) 
    fout = open( filename2 , "w") 
    for line in fin:
        # line = re.sub('2014-08-15 ','',line)
        line = re.sub('\+00:00','',line)  
        # if True in [item in line for item in offending]:
        #    continue
        fout.write(line)
    fin.close() 
    fout.close() 

fixup(sourcefile)
