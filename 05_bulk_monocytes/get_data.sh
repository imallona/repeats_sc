#!/bin/bash
##
## basic RNAseq analysis of human monocytes (repeats)
##
# Izaskun Mallona
# may 19 aug 2020
# GPL
## https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE80095
# t cells https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE101497

export HOME=/home/imallona
export TASK="repeats_sc"
export SUBTASK="bulk"
export WD="$HOME"/"$TASK"/"$SUBTASK"
export SOFT="$HOME"/soft
export NTHREADS=16


# export FASTQDUMP=~/soft/sra-toools/sratoolkit.2.10.5-ubuntu64/bin/fastq-dump
export FASTQDUMP=~/soft/sra-toools/sratoolkit.2.10.8-ubuntu64/bin/fastq-dump


mkdir -p $WD
cd $_

# Run,AGE,Assay Type,AvgSpotLen,Bases,BioProject,BioSample,Bytes,Cell_type,Center Name,Consent,DATASTORE filetype,DATASTORE provider,DATASTORE region,disease_status,Experiment,gender,GEO_Accession (exp),Instrument,LibraryLayout,LibrarySelection,LibrarySource,Organism,Platform,ReleaseDate,Sample Name,source_name,SRA Study
cat << EOF >> monocytes.conf
SRR3352080,25,RNA-Seq,155,19985111926,PRJNA317907,SAMN04631208,14369768355,CD14-Positive Monocytes cells,GEO,public,"fastq,sra","gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",Healthy individuals,SRX1688608,male,GSM2112705,Illumina HiSeq 2000,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2016-12-23T00:00:00Z,GSM2112705,Monocyte Cells,SRP073050
SRR3352081,39,RNA-Seq,150,15612587972,PRJNA317907,SAMN04631209,11389908539,CD14-Positive Monocytes cells,GEO,public,"fastq,sra","gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",Healthy individuals,SRX1688609,male,GSM2112706,Illumina HiSeq 2000,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2016-12-23T00:00:00Z,GSM2112706,Monocyte Cells,SRP073050
SRR3352082,35,RNA-Seq,170,16118686421,PRJNA317907,SAMN04631210,11660467357,CD14-Positive Monocytes cells,GEO,public,"fastq,sra","gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",Healthy individuals,SRX1688610,male,GSM2112707,Illumina HiSeq 2000,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2016-12-23T00:00:00Z,GSM2112707,Monocyte Cells,SRP073050
SRR3352083,30,RNA-Seq,169,21767556923,PRJNA317907,SAMN04631211,15808410875,CD14-Positive Monocytes cells,GEO,public,"fastq,sra","gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",Healthy individuals,SRX1688611,female,GSM2112708,Illumina HiSeq 2000,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2016-12-23T00:00:00Z,GSM2112708,Monocyte Cells,SRP073050
SRR3352084,31,RNA-Seq,170,16923747293,PRJNA317907,SAMN04631212,12303365789,CD14-Positive Monocytes cells,GEO,public,"fastq,sra","gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",Healthy individuals,SRX1688612,female,GSM2112709,Illumina HiSeq 2000,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2016-12-23T00:00:00Z,GSM2112709,Monocyte Cells,SRP073050
SRR3352085,35,RNA-Seq,171,16971321824,PRJNA317907,SAMN04631213,12248576134,CD14-Positive Monocytes cells,GEO,public,"fastq,sra","gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",Healthy individuals,SRX1688613,female,GSM2112710,Illumina HiSeq 2000,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2016-12-23T00:00:00Z,GSM2112710,Monocyte Cells,SRP073050    
EOF

while IFS='' read -r line || [[ -n "$line" ]]
do

    mkdir -p "$WD"/fastqs
    cd "$_"

    sample=$(echo $line | cut -f1 -d ',')

    echo $sample
    
  
    #   $(dirname $FASTQDUMP)/prefetch $sample --output-file ./"$sample".sra

    $(dirname $FASTQDUMP)/vdb-validate ./"$sample".sra &> "$sample"_vdbvalidation.log
    
    if [[ -e "${sample}.sra" ]]; then
        ${FASTQDUMP}  --gzip --split-files  ${sample}.sra
    fi

    echo 'remove the sra'
    rm -f  ${sample}.sra
    
done < monocytes.conf

# map directly without adaptor etc trimming

mkdir -p ~/repeats_sc/data/bulk_GSE80095

mv "$WD"/fastqs/*gz ~/repeats_sc/data/bulk_GSE80095
mv "$WD/"*conf ~/repeats_sc/data/bulk_GSE80095
mv "$WD"/*log ~/repeats_sc/data/bulk_GSE80095




# also do this with an external group

cd ~/repeats_sc/data/bulk_GSE80095


# Run,Assay Type,AvgSpotLen,Bases,BioProject,BioSample,Bytes,Cell_type,Center Name,Consent,DATASTORE filetype,DATASTORE provider,DATASTORE region,Donor,Experiment,GEO_Accession (exp),Instrument,LibraryLayout,LibrarySelection,LibrarySource,Organism,Platform,ReleaseDate,Sample Name,source_name,source,SRA Study,tissue,treatment
cat << EOF >> tcells.conf
SRR5831539,RNA-Seq,200,2210956200,PRJNA394680,SAMN07357224,1019690213,CD3+ Lymphocytes,GEO,public,"fastq,sra","gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",264,SRX3008845,GSM2705024,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2017-11-10T00:00:00Z,GSM2705024,Human peripheral blood,Primary cells,SRP112521,Peripheral blood,Vehicle
SRR5831542,RNA-Seq,200,2312165400,PRJNA394680,SAMN07357230,1060754609,CD3+ Lymphocytes,GEO,public,"fastq,sra","gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",265,SRX3008848,GSM2705027,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2017-11-10T00:00:00Z,GSM2705027,Human peripheral blood,Primary cells,SRP112521,Peripheral blood,Vehicle
SRR5831545,RNA-Seq,200,2225017200,PRJNA394680,SAMN07357227,1063839824,CD3+ Lymphocytes,GEO,public,"fastq,sra","gs,ncbi,s3","gs.US,ncbi.public,s3.us-east-1",266,SRX3008851,GSM2705030,Illumina HiSeq 2500,PAIRED,cDNA,TRANSCRIPTOMIC,Homo sapiens,ILLUMINA,2017-11-10T00:00:00Z,GSM2705030,Human peripheral blood,Primary cells,SRP112521,Peripheral blood,Vehicle
EOF


while IFS='' read -r line || [[ -n "$line" ]]
do

    cd ~/repeats_sc/data/bulk_GSE80095

    sample=$(echo $line | cut -f1 -d ',')

    echo $sample
    
  
    $(dirname $FASTQDUMP)/prefetch $sample --output-file ./"$sample".sra

    $(dirname $FASTQDUMP)/vdb-validate ./"$sample".sra &> "$sample"_vdbvalidation.log
    
    if [[ -e "${sample}.sra" ]]; then
        ${FASTQDUMP}  --gzip --split-files  ${sample}.sra
    fi

    echo 'remove the sra'
    rm -f  ${sample}.sra
    
done < tcells.conf



bash map_against_repeats.sh
