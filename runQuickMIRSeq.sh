# before running the following line you should load the quickmirseq conda environment
# conda activate quickmirseq
# this script is meant to run like: 
# qsub -V -N quickmirKG.r runQuickMIRSeq.sh -j y -o /data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2022-07-12_modekextracellular_real/quickmirKG.r.log && touch /data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2022-07-12_modekextracellular_real/quickmirKG.r.log

dataset_dir="2022-07-12_modekextracellular_real"

# your project's directory
cd /data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/$dataset_dir

# create the allIDs.txt file
ls fastq | cut -f1 -d . > allIDs.txt

cd /data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq

# run quickmirseq quantification step # step 2 in paper 
perl QuickMIRSeq.pl $dataset_dir/allIDs.txt $dataset_dir/run.config

# set QuickMIRSeq home
export QuickMIRSeq=/data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq

# create output directory
mkdir $QuickMIRSeq/$dataset_dir/output

# change location to the output directory
cd $QuickMIRSeq/$dataset_dir/output

pwd

# make quickmirseq scripts executable by anyone 
chmod a+x $QuickMIRSeq/*.sh
chmod a+x $QuickMIRSeq/*.R
chmod a+x $QuickMIRSeq/*.pl

# run the report script # step 3 in paper
$QuickMIRSeq/QuickMIRSeq-report.sh

