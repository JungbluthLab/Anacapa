#enter container
docker run -v /Volumes/2TBEXT/anacapa_databases:/mnt -it anacapa:latest /bin/bash

# Start: Part 1 - QC and dada2

## Start: 12S
cp -r /Anacapa/Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data /Anacapa/Anacapa_db

DB="/Anacapa/Anacapa_db"

DATA="${DB}/12S_test_data"

OUT="${DB}/12S_test_data_output"

FORWARD="$DATA/forward.txt"
REVERSE="$DATA/reverse.txt"

$DB/anacapa_QC_dada2.sh -i $DATA -o $OUT -d $DB -f $FORWARD -r $REVERSE -e $DB/metabarcode_loci_min_merge_length.txt -a truseq -t MiSeq -l -g
## End: 12S



## Start: CO1
cp -r /Anacapa/Example_data/CO1_custom_run /Anacapa/Anacapa_db

# update fasta files
cd /Anacapa/Anacapa_db/CO1_custom_run && rm *.fastq
cp /mnt/control_sequence_files/*.fastq /Anacapa/Anacapa_db/CO1_custom_run 

DB="/Anacapa/Anacapa_db"

DATA="${DB}/CO1_custom_run"

OUT="${DB}/CO1_custom_run_output"

FORWARD="$DATA/CO1_forward_primer.txt"
REVERSE="$DATA/CO1_reverse_primer.txt"

$DB/anacapa_QC_dada2.sh -i $DATA -o $OUT -d $DB -f $FORWARD -r $REVERSE -e $DB/metabarcode_loci_min_merge_length.txt -a truseq -t MiSeq -l -g


## End: CO1
# End: Part 1 - QC and dada2


# Start: Part 2 - Classify using Bowtie2

cp -r /Anacapa/Example_data/CO1_custom_run/CO1 /Anacapa/Anacapa_db

cd /Anacapa/Anacapa_db

$DB/anacapa_classifier.sh -o $OUT -d $DB -l
# End: Part 2 - Classify using Bowtie2

#copy output
cp -r /Anacapa/Anacapa_db/CO1_custom_run_output /mnt/CO1_crux_output_full_run


# Start CRUX testing

# Run download.sh to download required databases

obiconvert -t /mnt/crux_db/TAXO --embl --ecopcrdb-output=/mnt/crux_db/Obitools_databases/OB_dat_EMBL_$(date +"%b_%d_%y") /mnt/crux_db/Obitools_databases/EMBL_fun/* --skip-on-error

/CRUX_Creating-Reference-libraries-Using-eXisting-tools/crux_db/crux.sh \
  -n CO1 \
  -f GGWACWGGWTGAACWGTWTAYCCYCC \
  -r TAAACYTCWGGRTGWCCRAARAAYCA \
  -s 80 \
  -m 400 \
  -o /mnt/CO1_crux_output_full_run \
  -d /CRUX_Creating-Reference-libraries-Using-eXisting-tools/crux_db \
  -l \
  -x 70 \
  -j 30 \
  -t 30

# End CRUX testing

# Start: Part 3 - Classify using Bowtie2 custom database

cp -r /CRUX_Creating-Reference-libraries-Using-eXisting-tools/crux_db/CO1_crux_output/CO1_db_filtered /Anacapa/Anacapa_db/CO1

cd /Anacapa/Anacapa_db

$DB/anacapa_classifier.sh -o $OUT -d $DB -l
# End: Part 3 - Classify using Bowtie2 custom database
