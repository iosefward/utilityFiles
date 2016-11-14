#Take the input sample sheet and generate a file with the reverse complement of 
#the barcodes. 

import sys
import os
import string

#A 10 second google is better than writing
#http://edwards.sdsu.edu/labsite/index.php/robs/396-reverse-complement-dna-sequences-in-python
def rc(dna):

    complements = string.maketrans('acgtrymkbdhvACGTRYMKBDHV', 'tgcayrkmvhdbTGCAYRKMVHDB')
    rcseq = dna.translate(complements)[::-1]
    return rcseq


#loads the samplesheet
sampleSheet = sys.argv[1]
try:
    openSheet = open(sampleSheet)
    sampleLines = openSheet.readlines()
except: 
    print("Failed to load file")

#parse the input name and open the output file
sampleSheetBase = os.path.splitext(sampleSheet)
outputFileName = sampleSheetBase[0] + "_revComp" + sampleSheetBase[1]
openOutputFile = open(outputFileName,"w")

#write the header line
openOutputFile.write(sampleLines[0])
#loop over the other lines and replace the barcode with the rev complement
for line in sampleLines[1:]:
    splitLine = line.split(",")
    splitLine[4] = rc(splitLine[4])
    openOutputFile.write( ",".join(splitLine))
#Closey McFinished
openOutputFile.close()
