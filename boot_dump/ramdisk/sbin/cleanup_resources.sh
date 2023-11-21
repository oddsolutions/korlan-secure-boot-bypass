#!/bin/bash

# This script cleans up spaces for resources and prepares symlink
# for sound sensing resources.
#
# arguments:
# $1 model type (estelle, etc)

MODEL_TYPE=$1

TMP_FILES=/data/chrome/chirp/assistant/resources/.org.chromium.*

RUNIN_FOLDER=/data/runin
ML_RUNIN_FOLDER=/data/ml-runin

/bin/rm -f ${TMP_FILES}

/bin/rm -rf ${RUNIN_FOLDER}
/bin/rm -rf ${ML_RUNIN_FOLDER}

# Prepare sound sensing resources.

SS_MODEL_SYMLINK_DIR=/data/chrome/chirp/mdd/links/cast/perception_group
PROD_MODEL_FILE=encrypted_${MODEL_TYPE}_production_model.tflite
PROD_MODEL_SPEECHMICRO_FILE=encrypted_${MODEL_TYPE}_production_model_speechmicro.pb

/bin/rm -rf $SS_MODEL_SYMLINK_DIR
/bin/mkdir -p $SS_MODEL_SYMLINK_DIR

symlink_soundsensing_resource()
{
  OTA_FILE=$1
  FILE_NAME=$2
  SYMLINK_FILE=$SS_MODEL_SYMLINK_DIR/$FILE_NAME
  /bin/ln -s $OTA_FILE $SYMLINK_FILE
}

symlink_soundsensing_resource /system/chrome/resources/google3/${MODEL_TYPE}_production_model.tflite $PROD_MODEL_FILE
symlink_soundsensing_resource /system/chrome/resources/google3/${MODEL_TYPE}_production_model_speechmicro.pb $PROD_MODEL_SPEECHMICRO_FILE

/bin/toybox chown -R chrome:chrome /data/chrome/chirp

# Defensive to correct owner and permission from old residues.
chmod 700 /data/chrome/chirp
