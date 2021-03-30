

#enter container


#Part 1

# 12S
cp -r /Anacapa/Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data /Anacapa/Anacapa_db

DB="/Anacapa/Anacapa_db"

DATA="${DB}/12S_test_data"

OUT="${DB}/12S_test_data_output"

FORWARD="$DATA/forward.txt"
REVERSE="$DATA/reverse.txt"

$DB/anacapa_QC_dada2.sh -i $DATA -o $OUT -d $DB -f $FORWARD -r $REVERSE -e $DB/metabarcode_loci_min_merge_length.txt -a truseq -t MiSeq -l -g



# CO1

cp -r /Anacapa/CO1_custom_run /Anacapa/Anacapa_db

DB="/Anacapa/Anacapa_db"

DATA="${DB}/CO1_custom_run"

OUT="${DB}/CO1_custom_run_output"

FORWARD="$DATA/CO1_forward_primer.txt"
REVERSE="$DATA/CO1_reverse_primer.txt"

$DB/anacapa_QC_dada2.sh -i $DATA -o $OUT -d $DB -f $FORWARD -r $REVERSE -e $DB/metabarcode_loci_min_merge_length.txt -a truseq -t MiSeq -l -g




#Part 2

cp -r /anacapa/Anacapa_db/CO1 /Anacapa/Anacapa_db

cp /usr/local/bin/muscle /Anacapa/Anacapa_db/

cd /Anacapa/Anacapa_db

$DB/anacapa_classifier.sh -o $OUT -d $DB -l
