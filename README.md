# quickmirseq ClubAshworth

Instructions and scripts to run quickmirseq on ClubAshworth cluster.

DISCLAIMER: these are bbermudez personal notes, if these are useful to anyone that's a bonus.

## How to setup quickmirseq database?

PENDING

## How to run quickmirseq in ClubAshworth cluster

Create a directory within /data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq for the dataset you want to analyze
```
cd /data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq
mkdir 2022-07-12_modekextracellular_real
```

For both trial and real runs
```
/data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2022-07-12_modekextracellular_trial
/data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2022-07-12_modekextracellular_real
```

Then created fastq and output dirs within each of these
```
../2022-07-12_modekextracellular_real$ mkdir fastq
../2022-07-12_modekextracellular_real$ mkdir output
```
My script can create the output directory, but the fastq is mandatory

Then make soft links from all the datasets of interest to the fastq directory (in this example 5 datasets)
```
ln -s /data/buck/abuck_smallrna/analyses/11199_Buck_Amy/00.fastq_with_adapter.trial/403-0_MKcellsAGO2IP1.fq.gz . 
ln -s /data/buck/abuck_smallrna/analyses/11199_Buck_Amy/00.fastq_with_adapter.trial/406-0_MKcellsAgo2-IP2.fq.gz .
ln -s /data/buck/abuck_smallrna/analyses/11199_Buck_Amy/00.fastq_with_adapter.trial/402-0_MKcellsUB1.fq.gz .
ln -s /data/buck/abuck_smallrna/analyses/11199_Buck_Amy/00.fastq_with_adapter.trial/405-0_MKcellsUB2.fq.gz .
ln -s /data/buck/abuck_smallrna/analyses/11199_Buck_Amy/00.fastq_with_adapter.trial/409-0_MKSecretedAGO2IP1.fq.gz .
ln -s /data/buck/abuck_smallrna/analyses/11199_Buck_Amy/00.fastq_with_adapter.trial/412-0_MKSecretedAgo2-IP2.fq.gz .
ln -s /data/buck/abuck_smallrna/analyses/11199_Buck_Amy/00.fastq_with_adapter.trial/408-0_MKSecretedUB1.fq.gz .
ln -s /data/buck/abuck_smallrna/analyses/11199_Buck_Amy/00.fastq_with_adapter.trial/411-0_MKSecretedUB2.fq.gz .

ln -s /data/buck/abuck_smallrna/analyses/11804_Buck_Amy/00.fastq_with_adapter.trial/BMT_LN* .
ln -s /data/buck/abuck_smallrna/analyses/11804_Buck_Amy/00.fastq_with_adapter.trial/HET_LN* .

ln -s /data/buck/abuck_smallrna/analyses/15501_Cei/00.fastq_with_adapter.trial/F* .
ln -s /data/buck/abuck_smallrna/analyses/15501_Cei/00.fastq_with_adapter.trial/Het-Spleen-* .
ln -s /data/buck/abuck_smallrna/analyses/15501_Cei/00.fastq_with_adapter.trial/RAGKO-lung-* .

ln -s /data/buck/abuck_smallrna/analyses/11624_Buck_Amy/00.fastq_with_adapter.trial/2_MK-Ago2-IP* .
ln -s /data/buck/abuck_smallrna/analyses/11624_Buck_Amy/00.fastq_with_adapter.trial/2_MK-Input* .

ln -s /data/buck/abuck_smallrna/analyses/2022-04_Tcirc_hp_exWAGO_Kat/00.fastq_with_adapter.trial/KG07_* .
```
I opened the excel sheet to keep track of which libraries I added
Has soft links to fastq dir within quickmirseq dir (trial & real)?
1.  [x] 11199_Buck_Amy. (8 libs)
2.  [x] 11804_Buck_Amy. (12 libs)
3.  [x] 15501_Cei. (18 libs)
4.  [x] 11624_Buck_Amy. (8 libs)
5.  [x] 2022-04_Tcirc_hp_exWAGO_Kat. (36 libs)
In order to make the real directories, whenever I finished a dataset I moved to the real directory and clicked the up arrow in the keyboard to show the ln -s command for the trial lib and edited trial to real.
In total there are 82 libraries to include in this analysis

IMPORTANT: library names
quickmirseq doesn't like libraries that have dots in the middle such as: KG07_HD_M97_45.2_AGO2_L1.fastq.gz
Will replace . with _
From
```
KG07_HD_M97_45.2_AGO2_L1.fastq.gz
```
To
```
KG07_HD_M97_45_2_AGO2_L1.fastq.gz
```
I noticed about when looking at "empty" columns for some libraries in the resulting plots, also by looking at the library names in the trimmed dir within quickmirseq output directory.

quickmirseq needs a allIDs.txt file, but this is created by my runQuickMIRSeq.sh script.


Then I copied the run.config file from the tissues directory
```
qmaster:/data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2021-06-15_AB_tissues_real$ 
cp run.config ../2022-07-12_modekextracellular_trial/
```

Modified the fastq and output dirs, changed fastq suffix to fq.gz (was fastq.gz)
turned on the refine mismatch function, subtract reads mapped to miRNA with mismatches but have better hits in reference genome (recommended, but optional)
```
REFINE_MISMATACH_READS=yes
```
increased the min miR length to 18, was 16

I need to check that the same adapter works for all the datasets involved TGGAATTCTCGGGTGCCAAGG
Will this adapter work for all datasets?
1.  [x] 11199_Buck_Amy. (~94.5% of reads in one lib have adapter)
2.  [x] 11804_Buck_Amy. (~94.7% of reads in one lib have adapter)
3.  [x] 15501_Cei. (~96.1% of reads in one lib have adapter)
4.  [x] 11624_Buck_Amy. (~96.7% of reads in one have adapter)
5.  [x] 2022-04_Tcirc_hp_exWAGO_Kat. (~94.6% of reads in one libhave adapter)

Edit config file, there are 23 parameters you can set, I will mention some of these below
```
run.config
```
Choose a fastq directory:
```
FASTQ_DIR=/data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2021-06-15_AB_tissues_real/fastq
```
Set the output directory:
```
OUTPUT_FOLDER=/data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2021-06-15_AB_tissues_real/output
```
Choose number of cpus
```
CPU=12
```
Choose a species
```
SPECIES=mouse
```
Set location for RNA bowtie index
```
RNA_BOWTIE_INDEX=/data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/database/mouse/db_stranded_0
```
Set location for genome bowtie index
```
GENOME_BOWTIE_INDEX=/data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/database/mouse/GRCm38.p6.genome.fa
```
Set minimum and max reads length
```
MIN_MIRNA_LENGTH=16
MAX_MIRNA_LENGTH=28
```

I later copied run.config the file to the real directory and modified accordingly (changed trial for real)
```
qmaster:/data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2022-07-12_modekextracellular_trial$ cp run.config ../2022-07-12_modekextracellular_real/
```

Go to scripts directory
```
/data/buck/abuck_smallrna/scripts/beto/ultimate_scripts
```

activate quickmirseq conda environment
```
conda activate quickmirseq
```

Then I modified the script to run the quickmirseq analysis accordingly
```
/Users/beto/ultimate_scripts/orgs_sRNA
runQuickMIRSeq.sh
```

Submit job, the instruction is found within the runQuickMIRSeq.sh script
```
qsub -V -N quickmirKG.r runQuickMIRSeq.sh -j -o /data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2022-07-12_modekextracellular_real/quickmirKG.t.log && touch /data/buck/abuck_smallrna/analyses/QuickMIRSeq_Beto/QuickMIRSeq/2022-07-12_modekextracellular_real/quickmirKG.t.log
```


