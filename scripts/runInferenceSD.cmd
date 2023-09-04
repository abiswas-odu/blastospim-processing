#!/bin/bash

#SBATCH --job-name=sd_infer      # create a short name for your job
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=4               # total number of tasks across all nodes
#SBATCH --mem=250G               # total memory per node
#SBATCH --time=00:30:00           # total run time limit (HH:MM:SS)
#SBATCH -A molbio


IMAGE_PATH="../test/data/Images"
OUT_DIR="../test/Segmentation"
OUT_FORMAT="tif"
TIMEPOINT_SWITCH=-1   ## The time point where the switch to late stage model is done.
                      ## Set to -1 to run all the images with early stage
                      ## Set to -2 to run all the images with late stage

##===================================================================================================
##=====================CHANGES BELOW THIS LINE FOR ADVANCED USERS====================================
##===================================================================================================

EARLY_MODEL_DIR="../test/early_embryo_model"
EARLY_PROB_THRESH="0.5"
EARLY_NMS_THRESH="0.3"

LATE_MODEL_DIR="../test/late_embryo_model"
LATE_PROB_THRESH="0.451"
LATE_NMS_THRESH="0.5"

##===================================================================================================
##==============================NO CHANGES BELOW THIS LINE===========================================
##===================================================================================================

echo Running on host `hostname`
echo Starting Time is `date`
echo Directory is `pwd`
starttime=$(date +"%s")

conda activate tf2-segmentation
rm -rf ${OUT_DIR}
mkdir ${OUT_DIR}

stardist_inference --image_path ${IMAGE_PATH} \
  --output_dir ${OUT_DIR} \
  --early_model_dir ${EARLY_MODEL_DIR} \
  --early_prob_thresh ${EARLY_PROB_THRESH} \
  --early_nms_thresh ${EARLY_NMS_THRESH} \
  --late_model_dir ${LATE_MODEL_DIR} \
  --late_prob_thresh ${LATE_PROB_THRESH} \
  --late_nms_thresh ${LATE_NMS_THRESH} \
  --timepoint_switch ${TIMEPOINT_SWITCH} \
  --output_format ${OUT_FORMAT} \
  --gen_roi

echo Ending time is $(date)
endtime=$(date +"%s")
diff=$(($endtime - $starttime))
echo Elapsed time is $(($diff/60)) minutes and $(($diff%60)) seconds.

