screen -S run_scrnabox_SCRNA
# mkdir -p /lustre03/project/6070393/COMMON/Dark_Genome/analysis_DarkGenome2weeks_test
export SCRNABOX_HOME=/lustre03/project/6070393/COMMON/Dark_Genome/pipeline/scrnabox010.slurm
export SCRNABOX_PWD=/lustre03/project/6070393/COMMON/Dark_Genome/analysis_DarkGenome2weeks_SCRNA


sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 0


sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 1


sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 2

# seu <- subset(seu, subset = nFeature_RNA > 300 & nFeature_RNA < 6500 & percent.mt < 25)
#  seu <- subset(seu, subset = nFeature_RNA > NFRNAL & nFeature_RNA < NFRNAU & nCount_RNA > NCRNL & nCount_RNA < NCRNU & percent.mt < PMT)
sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 3 \
--nFRNAL 300 \
--nCRNAU 6500 \
--pmtU 25

sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 4 

sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 5

sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 6

HERE
sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 7 \
--marker T


sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 7 \
--fta T

sh $SCRNABOX_HOME/launch_pipeline.scrnabox.sh \
-d ${SCRNABOX_PWD} \
--steps 7 \
--enrich T
