#designed to get the most common sequences in the first 30 bases of each read


import gzip
from Bio import SeqIO
import operator
import sys

#We're expecting a gzipped fastq file
inputFile = sys.argv[1]
try:
    inputData = gzip.open(inputFile, 'rb') 
except: 
    print("Failed to load file")

seqDict = {}
for record in SeqIO.parse(inputData, "fastq"):
    first30 = record
    sequence = str(record[:30].seq)
    if sequence in seqDict:
        seqDict[sequence] += 1
    else: 
        seqDict[sequence] = 1

sorted_results = sorted(seqDict.iteritems(), key=operator.itemgetter(1), reverse=True)

i = 0
while i < 30:
    print sorted_results[i]
    i += 1
print len(seqDict)
