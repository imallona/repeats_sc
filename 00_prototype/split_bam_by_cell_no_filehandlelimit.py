#! /usr/bin/env python3
#
# Modified from https://raw.githubusercontent.com/crazyhottommy/scATACutils/master/python/split_scATAC_bam_by_cell.py
#
# Gets a BAM file with the reads from the first NUMBEROFCELLS_MAX different CB (cell barcodes)
# found when iterating the bam records

import pysam
import csv
import argparse
import os.path
import sys
import random

NUMBEROFCELLS_MAX = 10000

parser = argparse.ArgumentParser()
parser.add_argument("bam", help="Required. the FULL path to the 10x scATAC bam file generated \
    by cellranger-atac count")
parser.add_argument("-prefix", help="Optional, the prefix of the output bam, default is barcode.bam")
parser.add_argument("-outdir", help="Optional, the output directory for the splitted bams, default is current dir")
args = parser.parse_args()


if os.path.exists(args.bam):
    pass
else:
    print("bam not found")
    sys.exit(1)

if os.path.isdir(args.outdir):
    pass
else:
    try:
        os.mkdir(args.outdir)
    except OSError:
        print("can not create directory {}".format(args.outdir))

fin = pysam.AlignmentFile(args.bam, "rb")

## dict with keys are barcode, values are outbam
fouts_dict = {}

for read in fin:
    i = 1
    tags = read.tags
    CB_list = [ x for x in tags if x[0] == "CB"]
    if CB_list:
        cell_barcode = CB_list[0][1]
        if args.prefix:
            fout_name = args.prefix + "_" + cell_barcode + ".bam"
        else:
            fout_name = cell_barcode + ".bam"
        # print(len(fouts_dict))
        # file handle generated only if below
        if cell_barcode not in fouts_dict and len(fouts_dict) < NUMBEROFCELLS_MAX :
            if args.outdir:
                fouts_dict[cell_barcode] = pysam.AlignmentFile(os.path.join(args.outdir,fout_name), "wb", template = fin)
                fouts_dict[cell_barcode].write(read) 
            else:
                fouts_dict[cell_barcode] = pysam.AlignmentFile(fout_name, "wb", template = fin)
                 # and write the record
        elif cell_barcode in fouts_dict and len(fouts_dict) < NUMBEROFCELLS_MAX:
            fouts_dict[cell_barcode].write(read)
        else cell_barcode in fouts_dict and len(fouts_dict) == NUMBEROFCELLS_MAX:
            # close a random filehandle that is not the one in use            
            fouts_dict[random.choice([x for x in fouts_dict if x not in cell_barcode])].close()
            # and write the record
            fouts_dict[cell_barcode].write(read)
        i = i +1
        if i %% 1000 == 0:
            print(i) + 'processed'
    else: 
        continue
    

## do not forget to close the files
fin.close()
for fout in fouts_dict.values():
    fout.close()
