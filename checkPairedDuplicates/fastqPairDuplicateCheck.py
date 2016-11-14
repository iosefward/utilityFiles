#!/usr/bin/python

'''
---------------------------------------
common.ngseq.fastqPairDuplicateCheck.py
---------------------------------------

This stand-alone script reads a set of paired-end reads from two fastq files 
(one file for each end of the pair), and scans them to find those reads that 
are 1) properly paired (i.e. have an ID in each file) and then find those pairs
with identical sequences in both pairs (i.e., genuine duplicates). 

.. moduleauthor:: Nick Schurch <nschurch@dundee.ac.uk>

:module_version: 1.0
:created_on: 2014-06-13

Command-line Arguments
======================

**usage\:** 
    fastqPairDuplicateCheck.py
    :param: <input fastq file>
    :param: <input fastq file>
    :option:`-l|--log` *<file>* 
    [:option:`--tmpdir`] 
    [:option:`-v|--verbose`] 
    [:option:`--version`] 
    [:option:`--help`]

Required Parameters
-------------------

:param: <input fastq file>

  The input fastq file with the first end of the paired-end reads.

:param: <input fastq file>

  The input fastq file with the second end of the paired-end reads.

:option:`--logfile|-l`        

  The name (inc. path) of the log file from the wrapper.

Optional Parameter
------------------

:option:`--help|-h`

  Print a basic description of the tool and its options to STDOUT.

:option:`--version`    

  Show program's version number and exit.
    
:option:`--verbose|-v`     

  Turn on verbose logging (recommended).

Output
======

Four fastq files; two with one end each of the undupliacted paired-reads and 
one with duplicated paired-reads from both input files.

'''

#===============================================================================
# Optionally, 
# it can save the un-duplicated reads to two new fastq files, and the duplicated 
# pairs to two other fastqs.
#  
#    [:option:`--udpairs1` <output fastq file>]
#    [:option:`--udpairs2` <output fastq file>]
#    [:option:`--dpairs1` <output fastq file>]
#    [:option:`--dpairs2` <output fastq file>]
#
# :param: `--udpairs1` <output fastq file>
# 
#   The output fastq file for the first end of the unduplicated paired-end reads.
# 
# :param: `--udpairs2` <output fastq file>
# 
#   The output fastq file for the second end of the unduplicated paired-end reads.
# 
# :param: `--dpairs1` <output fastq file>
# 
#   The output fastq file for the first end of the duplicated paired-end reads.
# 
# :param: `--dpairs2` <output fastq file>
# 
#   The output fastq file for the second end of the duplicated paired-end reads.
#===============================================================================

__scriptname__= "fastqPairDuplicateCheck"
__version__ = "1.0"
__usage__ = "\n\t%s <input readpair1 fastq file> <input readpair2 fastq file>" \
            "\n\t-l|--logfile <file> \n\t[--version] [-v|--verbose] [--help]"
#            "\n\t[`--udpairs1` <output unduplicated readpair1 fastq file>]" \
#            "\n\t[`--udpairs1` <output unduplicated readpair2 fastq file>]" \
#            "\n\t[`--dpairs1` <output duplicated readpair1 fastq file>]" \
#            "\n\t[`--dpairs1` <output duplicated readpair2 fastq file>]" 
__progdesc__ = '''
This stand-alone script reads a set of paired-end reads from two fastq files 
(one file for each end of the pair), and scans them to find those reads that 
are 1) properly paired (i.e. have an ID in each file) and then find those pairs
with identical sequences in both pairs (i.e., genuine duplicates).
'''
#Optionally, 
#it can save the un-duplicated reads to two new fastq files, and the duplicated 
#pairs to two other fastqs.
#'''

__progepi__ = '''
----------------------------
common.ngseq.fastqPairDuplicateCheck.py
----------------------------
'''

import sys, numpy
import script_options.standard_parsers as sp
import script_logging.standard_logging as sl
import script_options.custom_callables as cc
from Bio.SeqIO.QualityIO import FastqGeneralIterator
from itertools import izip_longest

def flexableFileOpen(filename, openMode="r", compress=False):
    
    """ gzip compatable file open """
    
    import gzip
    
    if openMode.startswith("r"):
        try:
            filehandle = gzip.open(filename, openMode)
            filehandle.readline()
            filehandle.rewind()
        except IOError:
            filehandle = open(filename, openMode)
    elif compress:
        filehandle = gzip.open(filename, openMode)
    else:
        filehandle = open(filename, openMode)
    
    return(filehandle)

def processfilesfast(pairs_1, pairs_2, logger, pair1_undup_out_name=None, 
                     pair2_undup_out_name=None, pair1_dup_out_name=None, 
                     pair2_dup_out_name=None, compress=False,
                     checkids=True):
    
    """ processes fastq files for pair duplicates """

    # use sets instead of lists and numpy arrays. much faster! 
    # Also, use zip_longest to aggregate two iterators
    
    logger.info("fast reading and indexing both pair files: %s & %s" \
                "" % (pairs_1, pairs_2))
    p1 = FastqGeneralIterator(flexableFileOpen(pairs_1))
    p2 = FastqGeneralIterator(flexableFileOpen(pairs_2))
    looper = izip_longest(p1, p2, fillvalue=None)
    
    i=0
    j=1
    r1_i=0
    r2_i=0
    duplicates={}
    unduplicates=set()
    unpaired_r1=set()
    unpaired_r2=set()
    for r1, r2 in looper:
        skip=False
#        if checkids:
#            print r1[0], r2[0], r1[0]==r2[0]
#            if re.match(re.sub(" 1:","",x),re.sub(" 2:","",y)):
#                skip=True
        if r1 is None:
            r2_i+=1
            unpaired_r2.add(r2)
        if r2 is None:
            r1_i+=1
            unpaired_r1.add(r1)
                
        if not skip:
            if (r1[1],r2[1]) in unduplicates:
                try:
                    duplicates[(r1[1],r2[1])]+=1
                except KeyError:
                    duplicates[(r1[1],r2[1])]=2
            else:
                unduplicates.add((r1[1],r2[1]))
            r1_i+=1
            r2_i+=1
        
        i+=1
        if i==1000000:
            logger.info("\t processed %iE6 reads" % j)
            i=0
            j+=1
    
    for readpair in duplicates.keys():
        unduplicates.remove(readpair)
    
    logger.info("\t read %i reads from pair file 1" % r1_i)
    logger.info("\t\t found %i unpaired reads" % len(unpaired_r1))
    logger.info("\t read %i reads from pair file 2" % r2_i)
    logger.info("\t\t found %i unpaired reads" % len(unpaired_r2))
    logger.info("\t found %i un-duplicated pairs" % len(unduplicates))
    logger.info("\t found %i duplicated pairs" % len(duplicates.keys()))
    dupfrac = (float(len(duplicates))/(len(unduplicates)+len(unduplicates)))*100
    logger.info("\t duplicate pair fraction is %.02f%s" % (dupfrac, "%"))
    duplication = numpy.array(duplicates.values())
    logger.info("\t\t maximum duplication for any pair: %i" % duplication.max())
    logger.info("\t\t mean duplication for duplicated pairs: %.2f" % duplication.mean())
        
    return(True)

if __name__ == '__main__':
    
    # parse command line options
    # Set standard parser
    parser, pos_args, kw_args = sp.standard_parser(__version__,
                                                   prog = __scriptname__, 
                                                   usage = __usage__,
                                                   description = __progdesc__,
                                                   epilog = __progepi__,
                                                   infile = False,
                                                   outfile = False,
                                                   tmpdir = False)
        
    infiles_group = parser.add_argument_group('Input paired fastq files (required)')
    fastqfilehelp = "Specify an input fastq file (inc. path if different " \
                    "from the current working directory) to be consumed by " \
                    "this script. This files should be one of two with the " \
                    "pairs from paired end reads in."

    infiles_group.add_argument('pair1',
                               action = 'store',
                               type = cc.input_file,
                               help = fastqfilehelp 
                               )

    infiles_group.add_argument('pair2',
                               action = 'store',
                               type = cc.input_file,
                               help = fastqfilehelp 
                               )
    
    pos_args.append(('pair1',None))
    pos_args.append(('pair2',None))
    
#===============================================================================
#     outfiles_group = parser.add_argument_group('Output fastq filenames')
#     fastqfileouthelp = "Specify the filename for an output fastq file (inc. " \
#                        "path if different from the current working " \
#                        "directory) to be output from this script."
#     
#     outfiles_group.add_argument('--udpairs1',
#                                 action = 'store',
#                                 type = cc.output_file,
#                                 help = fastqfileouthelp)
# 
#     outfiles_group.add_argument('--udpairs2',
#                                 action = 'store',
#                                 type = cc.output_file,
#                                 help = fastqfileouthelp)
#     
#     outfiles_group.add_argument('--dpairs1',
#                                 action = 'store',
#                                 type = cc.output_file,
#                                 help = fastqfileouthelp)
# 
#     outfiles_group.add_argument('--dpairs2',
#                                 action = 'store',
#                                 type = cc.output_file,
#                                 help = fastqfileouthelp)
#     
#     pos_args.append(('udpairs1',None))
#     pos_args.append(('udpairs2',None))
#     pos_args.append(('dpairs1',None))
#     pos_args.append(('dpairs2',None))
#     
#     script_options_group = parser.add_argument_group('Options')
# 
#     script_options_group.add_argument('--compress-output',
#                                       action = 'store_true',
#                                       dest = 'compress',
#                                       help = "Use this flag to specify " \
#                                              "gzipped output"
#                                       )
#     
#     kw_args.append(('compress', 'compress-output', False))
#===============================================================================
    
    # parse arguments
    args = parser.parse_args()
    
    # setup standard logging information
    script_logger = sl.standard_logger(__version__, sys.argv, args, pos_args, 
                                       kw_args, script_name=__scriptname__)
    
    # run comparison
    success = processfilesfast(args.pair1, args.pair2, script_logger)#,
                          #     args.udpairs1, args.udpairs2, args.dpairs1, 
                          #     args.dpairs2, compress=args.compress)

    script_logger.info("Finished.")
