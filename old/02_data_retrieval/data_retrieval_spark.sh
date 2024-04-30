#!/bin/bash
##
## Data retrieval I
## Datasets listed within Spark grant 
##
## 18 Nov 2010
## Izaskun Mallona
##
## Update after file inspection: beware of Kumar's short reads (8 barcode, 26 transcript)
# [imallona@imlstaupo data]$ zcat kumar_cancer/SRR8165390_1.fastq.gz | head -8
# @SRR8165390.1.1 SN363:1065:HTWVWBCXX:1:1101:1095:2087 length=8
# GGTTTACT
# +SRR8165390.1.1 SN363:1065:HTWVWBCXX:1:1101:1095:2087 length=8
# DDDDDIII
# @SRR8165390.2.1 SN363:1065:HTWVWBCXX:1:1101:1464:2090 length=8
# GGTTTACT
# +SRR8165390.2.1 SN363:1065:HTWVWBCXX:1:1101:1464:2090 length=8
# @@B@D1G1
# [imallona@imlstaupo data]$ zcat kumar_cancer/SRR8165390_2.fastq.gz | head -8
# @SRR8165390.1.2 SN363:1065:HTWVWBCXX:1:1101:1095:2087 length=26
# GCAGCCAGTCCGAACCTGAGTAGTGT
# +SRR8165390.1.2 SN363:1065:HTWVWBCXX:1:1101:1095:2087 length=26
# DADD@HHHIGIHIH<CFEHIHIIIII
# @SRR8165390.2.2 SN363:1065:HTWVWBCXX:1:1101:1464:2090 length=26
# TCAGGATCAATGCCATATTGTGTAGA
# +SRR8165390.2.2 SN363:1065:HTWVWBCXX:1:1101:1464:2090 length=26


WD=/home/Shared_s3it/imallona/repeats_sc/data
NTHREADS=8
export FASTQDUMP=/usr/local/software/sratoolkit.2.9.0-ubuntu64/bin/fastq-dump 

mkdir -p $WD ; cd $_

echo PBMCs

# Check prototype's 00_prototype/get_10x_pbmcs.sh

echo Cancer Kumar et al

# https://www.ncbi.nlm.nih.gov/pubmed/30404002
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE121861
#https://www.ncbi.nlm.nih.gov/Traces/study/?query_key=3&WebEnv=NCID_1_12425879_130.14.22.76_5555_1574076384_2916880134_0MetA0_S_HStore&o=acc_s%3Aa

cat << EOF > kumar_cancer.conf
Run,Assay Type,AvgSpotLen,BioProject,BioSample,Center Name,Consent,DATASTORE filetype,DATASTORE provider,DATASTORE region,Experiment,GEO_Accession,Instrument,LibraryLayout,LibrarySelection,LibrarySource,MBases,MBytes,model,mouse_id,Organism,Platform,protocol,ReleaseDate,sample_acc,Sample Name,seeding_density,source_name,SRA Study,strain
SRR8165390,RNA-Seq,131,PRJNA498671,SAMN10321158,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940653,GSM3448086,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2922,2096,CT26,1,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984450,GSM3448086,1x106,tumor,SRP166967,BALB/c
SRR8165391,RNA-Seq,131,PRJNA498671,SAMN10321158,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940653,GSM3448086,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2968,2122,CT26,1,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984450,GSM3448086,1x106,tumor,SRP166967,BALB/c
SRR8165392,RNA-Seq,131,PRJNA498671,SAMN10321157,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940654,GSM3448087,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2465,1779,CT26,2,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984449,GSM3448087,1x106,tumor,SRP166967,BALB/c
SRR8165393,RNA-Seq,131,PRJNA498671,SAMN10321157,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940654,GSM3448087,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2505,1802,CT26,2,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984449,GSM3448087,1x106,tumor,SRP166967,BALB/c
SRR8165394,RNA-Seq,131,PRJNA498671,SAMN10321156,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940655,GSM3448088,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,3303,2381,MC-38,3,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984451,GSM3448088,2x105,tumor,SRP166967,C57B6/J
SRR8165395,RNA-Seq,131,PRJNA498671,SAMN10321156,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940655,GSM3448088,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,3354,2410,MC-38,3,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984451,GSM3448088,2x105,tumor,SRP166967,C57B6/J
SRR8165396,RNA-Seq,131,PRJNA498671,SAMN10321155,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940656,GSM3448089,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2635,1899,MC-38,4,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984453,GSM3448089,2x105,tumor,SRP166967,C57B6/J
SRR8165397,RNA-Seq,131,PRJNA498671,SAMN10321155,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940656,GSM3448089,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2675,1921,MC-38,4,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984453,GSM3448089,2x105,tumor,SRP166967,C57B6/J
SRR8165398,RNA-Seq,131,PRJNA498671,SAMN10321154,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940657,GSM3448090,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2683,1930,CT26,1,Mus musculus,ILLUMINA,overnight,2018-11-06T00:00:00Z,SRS3984455,GSM3448090,1x106,tumor,SRP166967,BALB/c
SRR8165399,RNA-Seq,131,PRJNA498671,SAMN10321154,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940657,GSM3448090,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2726,1955,CT26,1,Mus musculus,ILLUMINA,overnight,2018-11-06T00:00:00Z,SRS3984455,GSM3448090,1x106,tumor,SRP166967,BALB/c
SRR8165400,RNA-Seq,131,PRJNA498671,SAMN10321153,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940658,GSM3448091,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2707,1948,CT26,2,Mus musculus,ILLUMINA,overnight,2018-11-06T00:00:00Z,SRS3984452,GSM3448091,1x106,tumor,SRP166967,BALB/c
SRR8165401,RNA-Seq,131,PRJNA498671,SAMN10321153,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940658,GSM3448091,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2750,1972,CT26,2,Mus musculus,ILLUMINA,overnight,2018-11-06T00:00:00Z,SRS3984452,GSM3448091,1x106,tumor,SRP166967,BALB/c
SRR8165402,RNA-Seq,131,PRJNA498671,SAMN10321152,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940659,GSM3448092,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2905,2089,MC-38,3,Mus musculus,ILLUMINA,overnight,2018-11-06T00:00:00Z,SRS3984454,GSM3448092,2x105,tumor,SRP166967,C57B6/J
SRR8165404,RNA-Seq,131,PRJNA498671,SAMN10321152,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940659,GSM3448092,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,2953,2117,MC-38,3,Mus musculus,ILLUMINA,overnight,2018-11-06T00:00:00Z,SRS3984454,GSM3448092,2x105,tumor,SRP166967,C57B6/J
SRR8165405,RNA-Seq,131,PRJNA498671,SAMN10321151,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940660,GSM3448093,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,4017,2889,MC-38,4,Mus musculus,ILLUMINA,overnight,2018-11-06T00:00:00Z,SRS3984456,GSM3448093,2x105,tumor,SRP166967,C57B6/J
SRR8165406,RNA-Seq,131,PRJNA498671,SAMN10321151,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940660,GSM3448093,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,4081,2924,MC-38,4,Mus musculus,ILLUMINA,overnight,2018-11-06T00:00:00Z,SRS3984456,GSM3448093,2x105,tumor,SRP166967,C57B6/J
SRR8165407,RNA-Seq,131,PRJNA498671,SAMN10321150,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940661,GSM3448094,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,551,382,LL2,5,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984457,GSM3448094,2x105,tumor,SRP166967,C57B6/J
SRR8165408,RNA-Seq,131,PRJNA498671,SAMN10321150,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940661,GSM3448094,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,552,383,LL2,5,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984457,GSM3448094,2x105,tumor,SRP166967,C57B6/J
SRR8165409,RNA-Seq,131,PRJNA498671,SAMN10321149,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940662,GSM3448095,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,573,398,LL2,6,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984458,GSM3448095,2x105,tumor,SRP166967,C57B6/J
SRR8165410,RNA-Seq,131,PRJNA498671,SAMN10321149,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940662,GSM3448095,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,574,399,LL2,6,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984458,GSM3448095,2x105,tumor,SRP166967,C57B6/J
SRR8165411,RNA-Seq,131,PRJNA498671,SAMN10321148,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940663,GSM3448096,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,776,538,B16-F10,7,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984459,GSM3448096,2x105,tumor,SRP166967,C57B6/J
SRR8165412,RNA-Seq,131,PRJNA498671,SAMN10321148,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940663,GSM3448096,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,778,539,B16-F10,7,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984459,GSM3448096,2x105,tumor,SRP166967,C57B6/J
SRR8165413,RNA-Seq,131,PRJNA498671,SAMN10321147,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940664,GSM3448097,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,880,609,B16-F10,8,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984461,GSM3448097,2x105,tumor,SRP166967,C57B6/J
SRR8165414,RNA-Seq,131,PRJNA498671,SAMN10321147,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940664,GSM3448097,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,883,611,B16-F10,8,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984461,GSM3448097,2x105,tumor,SRP166967,C57B6/J
SRR8165415,RNA-Seq,131,PRJNA498671,SAMN10321146,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940665,GSM3448098,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,842,581,EMT6,9,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984460,GSM3448098,2x105,tumor,SRP166967,BALB/c
SRR8165417,RNA-Seq,131,PRJNA498671,SAMN10321145,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940666,GSM3448099,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,822,569,EMT6,10,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984462,GSM3448099,2x105,tumor,SRP166967,BALB/c
SRR8165418,RNA-Seq,131,PRJNA498671,SAMN10321145,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940666,GSM3448099,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,825,571,EMT6,10,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984462,GSM3448099,2x105,tumor,SRP166967,BALB/c
SRR8165419,RNA-Seq,131,PRJNA498671,SAMN10321144,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940667,GSM3448100,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,900,620,SA1N,11,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984464,GSM3448100,1x106,tumor,SRP166967,A/J
SRR8165420,RNA-Seq,131,PRJNA498671,SAMN10321144,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940667,GSM3448100,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,903,621,SA1N,11,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984464,GSM3448100,1x106,tumor,SRP166967,A/J
SRR8165421,RNA-Seq,131,PRJNA498671,SAMN10321142,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940668,GSM3448101,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,914,632,SA1N,12,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984463,GSM3448101,1x106,tumor,SRP166967,A/J
SRR8165422,RNA-Seq,131,PRJNA498671,SAMN10321142,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940668,GSM3448101,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,916,633,SA1N,12,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984463,GSM3448101,1x106,tumor,SRP166967,A/J
SRR8165423,RNA-Seq,131,PRJNA498671,SAMN10321141,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940669,GSM3448102,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,343,233,LL2,5,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984465,GSM3448102,2x105,tumor,SRP166967,C57B6/J
SRR8165424,RNA-Seq,131,PRJNA498671,SAMN10321141,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940669,GSM3448102,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,345,234,LL2,5,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984465,GSM3448102,2x105,tumor,SRP166967,C57B6/J
SRR8165425,RNA-Seq,131,PRJNA498671,SAMN10321140,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940670,GSM3448103,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,491,334,LL2,6,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984466,GSM3448103,2x105,tumor,SRP166967,C57B6/J
SRR8165426,RNA-Seq,131,PRJNA498671,SAMN10321140,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940670,GSM3448103,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,494,336,LL2,6,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984466,GSM3448103,2x105,tumor,SRP166967,C57B6/J
SRR8165427,RNA-Seq,131,PRJNA498671,SAMN10321139,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940671,GSM3448104,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,506,346,B16-F10,7,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984467,GSM3448104,2x105,tumor,SRP166967,C57B6/J
SRR8165428,RNA-Seq,131,PRJNA498671,SAMN10321139,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940671,GSM3448104,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,507,347,B16-F10,7,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984467,GSM3448104,2x105,tumor,SRP166967,C57B6/J
SRR8165429,RNA-Seq,131,PRJNA498671,SAMN10321138,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940672,GSM3448105,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,922,628,B16-F10,8,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984468,GSM3448105,2x105,tumor,SRP166967,C57B6/J
SRR8165430,RNA-Seq,131,PRJNA498671,SAMN10321138,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940672,GSM3448105,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,925,630,B16-F10,8,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984468,GSM3448105,2x105,tumor,SRP166967,C57B6/J
SRR8165431,RNA-Seq,131,PRJNA498671,SAMN10321137,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940673,GSM3448106,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,632,431,EMT6,9,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984469,GSM3448106,2x105,tumor,SRP166967,BALB/c
SRR8165432,RNA-Seq,131,PRJNA498671,SAMN10321137,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940673,GSM3448106,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,634,432,EMT6,9,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984469,GSM3448106,2x105,tumor,SRP166967,BALB/c
SRR8165434,RNA-Seq,131,PRJNA498671,SAMN10321136,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940674,GSM3448107,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,674,459,EMT6,10,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984472,GSM3448107,2x105,tumor,SRP166967,BALB/c
SRR8165436,RNA-Seq,131,PRJNA498671,SAMN10321135,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940675,GSM3448108,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,581,396,SA1N,11,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984470,GSM3448108,1x106,tumor,SRP166967,A/J
SRR8165437,RNA-Seq,131,PRJNA498671,SAMN10321134,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940676,GSM3448109,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,602,412,SA1N,12,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984471,GSM3448109,1x106,tumor,SRP166967,A/J
SRR8165438,RNA-Seq,131,PRJNA498671,SAMN10321134,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940676,GSM3448109,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,603,413,SA1N,12,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984471,GSM3448109,1x106,tumor,SRP166967,A/J
SRR8165435,RNA-Seq,131,PRJNA498671,SAMN10321135,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940675,GSM3448108,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,578,394,SA1N,11,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984470,GSM3448108,1x106,tumor,SRP166967,A/J
SRR8165416,RNA-Seq,131,PRJNA498671,SAMN10321146,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940665,GSM3448098,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,845,582,EMT6,9,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984460,GSM3448098,2x105,tumor,SRP166967,BALB/c
SRR8165433,RNA-Seq,131,PRJNA498671,SAMN10321136,GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX4940674,GSM3448107,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,671,458,EMT6,10,Mus musculus,ILLUMINA,fresh,2018-11-06T00:00:00Z,SRS3984472,GSM3448107,2x105,tumor,SRP166967,BALB/c
EOF

echo Neurons Tanay: data missing, not published yet

# https://www.biorxiv.org/content/10.1101/462853v2
# https://bitbucket.org/tanaylab/brocks_et_al_nat_com_2019_epitherapy_scrna/src/default/

echo Cardiac differentiation Friedman et al they also have ChIP-seq

# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6220122/
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE97080
# https://www.ncbi.nlm.nih.gov/sra?term=SRP102528
# https://www.ncbi.nlm.nih.gov/Traces/study/?query_key=6&WebEnv=NCID_1_12425879_130.14.22.76_5555_1574076384_2916880134_0MetA0_S_HStore&o=acc_s%3Aa

cat << EOF > friedman_cardiac.conf
Run,Assay Type,AvgSpotLen,BioProject,BioSample,Cell_type,Center Name,Consent,DATASTORE filetype,DATASTORE provider,DATASTORE region,Experiment,Instrument,LibraryLayout,LibrarySelection,LibrarySource,MBases,MBytes,Organism,Platform,ReleaseDate,sample_acc,Sample Name,source_name,SRA Study,GEO_Accession,chip_antibody
SRR5380560,RNA-Seq,36,PRJNA380639,SAMN06645356,cardiogenic mesoderm (C-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675786,Illumina HiSeq 2000,SINGLE,cDNA,TRANSCRIPTOMIC,755,492,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074546,GSM2551186,cardiogenic mesoderm (C-ECs),SRP102528,,
SRR5380562,RNA-Seq,36,PRJNA380639,SAMN06645354,hemogenic mesoderm (H-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675788,Illumina HiSeq 2000,SINGLE,cDNA,TRANSCRIPTOMIC,430,284,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074548,GSM2551188,hemogenic mesoderm (H-ECs),SRP102528,GSM2551188,
SRR5380563,RNA-Seq,36,PRJNA380639,SAMN06645353,hemogenic mesoderm (H-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675789,Illumina HiSeq 2000,SINGLE,cDNA,TRANSCRIPTOMIC,591,388,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074549,GSM2551189,hemogenic mesoderm (H-ECs),SRP102528,,
SRR5380564,RNA-Seq,36,PRJNA380639,SAMN06645352,cardiac progenitor cells (CPCs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675790,Illumina HiSeq 2000,SINGLE,cDNA,TRANSCRIPTOMIC,426,278,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074550,GSM2551190,cardiac progenitor cells (CPCs),SRP102528,GSM2551190,
SRR5380565,RNA-Seq,36,PRJNA380639,SAMN06645351,cardiac progenitor cells (CPCs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675791,Illumina HiSeq 2000,SINGLE,cDNA,TRANSCRIPTOMIC,494,322,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074551,GSM2551191,cardiac progenitor cells (CPCs),SRP102528,GSM2551191,
SRR5380567,ChIP-Seq,36,PRJNA380639,SAMN06645359,cardiogenic mesoderm (C-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675793,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,290,190,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074553,GSM2551193,cardiogenic mesoderm (C-ECs),SRP102528,GSM2551193,"H3K4me3 (Cat # 9751\, Cell Signaling)"
SRR5380568,ChIP-Seq,36,PRJNA380639,SAMN06645358,cardiogenic mesoderm (C-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675794,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,406,266,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074554,GSM2551194,cardiogenic mesoderm (C-ECs),SRP102528,GSM2551194,none
SRR5380569,ChIP-Seq,36,PRJNA380639,SAMN06645357,cardiogenic mesoderm (C-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675795,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,984,646,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074555,GSM2551195,cardiogenic mesoderm (C-ECs),SRP102528,GSM2551195,H3K27me3 (Cat # 07-449; Millipore)
SRR5380570,ChIP-Seq,36,PRJNA380639,SAMN06645361,cardiogenic mesoderm (C-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675796,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,530,348,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074556,GSM2551196,cardiogenic mesoderm (C-ECs),SRP102528,GSM2551196,"H3K4me3 (Cat # 9751\, Cell Signaling)"
SRR5380571,ChIP-Seq,36,PRJNA380639,SAMN06645360,cardiogenic mesoderm (C-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675797,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,426,278,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074557,GSM2551197,cardiogenic mesoderm (C-ECs),SRP102528,GSM2551197,none
SRR5380572,ChIP-Seq,36,PRJNA380639,SAMN06645362,hemogenic mesoderm (H-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675798,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,429,284,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074558,GSM2551198,hemogenic mesoderm (H-ECs),SRP102528,GSM2551198,H3K27me3 (Cat # 07-449; Millipore)
SRR5380573,ChIP-Seq,36,PRJNA380639,SAMN06645329,hemogenic mesoderm (H-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675799,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,366,242,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074559,GSM2551199,hemogenic mesoderm (H-ECs),SRP102528,GSM2551199,"H3K4me3 (Cat # 9751\, Cell Signaling)"
SRR5380574,ChIP-Seq,36,PRJNA380639,SAMN06645328,hemogenic mesoderm (H-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675800,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,372,234,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074560,GSM2551200,hemogenic mesoderm (H-ECs),SRP102528,GSM2551200,none
SRR5380575,ChIP-Seq,36,PRJNA380639,SAMN06645363,hemogenic mesoderm (H-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675801,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,391,258,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074561,GSM2551201,hemogenic mesoderm (H-ECs),SRP102528,GSM2551201,H3K27me3 (Cat # 07-449; Millipore)
SRR5380576,ChIP-Seq,36,PRJNA380639,SAMN06645349,hemogenic mesoderm (H-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675802,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,302,189,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074562,GSM2551202,hemogenic mesoderm (H-ECs),SRP102528,GSM2551202,"H3K4me3 (Cat # 9751\, Cell Signaling)"
SRR5380577,ChIP-Seq,36,PRJNA380639,SAMN06645348,hemogenic mesoderm (H-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675803,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,381,237,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074563,GSM2551203,hemogenic mesoderm (H-ECs),SRP102528,GSM2551203,none
SRR5380578,ChIP-Seq,36,PRJNA380639,SAMN06645347,cardiac progenitor cells (CPCs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675804,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,329,205,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074564,GSM2551204,cardiac progenitor cells (CPCs),SRP102528,GSM2551204,H3K27me3 (Cat # 07-449; Millipore)
SRR5380579,ChIP-Seq,36,PRJNA380639,SAMN06645346,cardiac progenitor cells (CPCs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675805,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,342,220,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074565,GSM2551205,cardiac progenitor cells (CPCs),SRP102528,GSM2551205,"H3K4me3 (Cat # 9751\, Cell Signaling)"
SRR5380580,ChIP-Seq,36,PRJNA380639,SAMN06645345,cardiac progenitor cells (CPCs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675806,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,190,133,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074566,GSM2551206,cardiac progenitor cells (CPCs),SRP102528,GSM2551206,none
SRR5380582,ChIP-Seq,36,PRJNA380639,SAMN06645343,cardiac progenitor cells (CPCs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675808,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,376,234,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074568,GSM2551208,cardiac progenitor cells (CPCs),SRP102528,GSM2551208,"H3K4me3 (Cat # 9751\, Cell Signaling)"
SRR5380583,ChIP-Seq,36,PRJNA380639,SAMN06645342,cardiac progenitor cells (CPCs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675809,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,87,60,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074569,GSM2551209,cardiac progenitor cells (CPCs),SRP102528,GSM2551209,none
SRR5380561,RNA-Seq,36,PRJNA380639,SAMN06645355,cardiogenic mesoderm (C-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675787,Illumina HiSeq 2000,SINGLE,cDNA,TRANSCRIPTOMIC,849,553,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074547,GSM2551187,cardiogenic mesoderm (C-ECs),SRP102528,,
SRR5380581,ChIP-Seq,36,PRJNA380639,SAMN06645344,cardiac progenitor cells (CPCs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675807,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,287,181,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074567,GSM2551207,cardiac progenitor cells (CPCs),SRP102528,GSM2551207,H3K27me3 (Cat # 07-449; Millipore)
SRR5380566,ChIP-Seq,36,PRJNA380639,SAMN06645350,cardiogenic mesoderm (C-ECs),GEO,public,sra,"gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",SRX2675792,Illumina HiSeq 2000,SINGLE,ChIP,GENOMIC,377,250,Homo sapiens,ILLUMINA,2017-08-16T00:00:00Z,SRS2074552,GSM2551192,cardiogenic mesoderm (C-ECs),SRP102528,GSM2551192,H3K27me3 (Cat # 07-449; Millipore)
EOF


echo Friedman cardiac single cell

wget https://www.ebi.ac.uk/arrayexpress/files/E-MTAB-6268/E-MTAB-6268.sdrf.txt -O friedman_single_cell.sdrf

mkdir friedman_single_cell
cd $_

cat ../friedman_single_cell.sdrf | tr "\t" "\n"  | grep -e "ftp.*gz" | xargs -L 1 -P $NTHREADS wget


echo Neurons developmental series, Mayer
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6052457/ this maybe?




for fn in $(find . -name "*conf")
do
    mkdir -p $(basename $fn .conf)
    cd $(basename $fn .conf)
    
    grep TRANSCRIPTOMIC ../$fn | \
        cut -f1 -d"," | \
        xargs -P $NTHREADS -n 1 -I % sh -c 'echo $date downloading %; $FASTQDUMP -I --gzip --split-files %; echo $date ended %' | tee -a download.log
    cd $WD
    
done
          