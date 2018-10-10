#!/bin/bash

###########################################################
#####   DAMIC@SNOLAB SIMULATION CODE INSTALATION
###########################################################

#### directory path to the geant4 instalation in the docker image
export G4_DIR=/home/damicmuser/G4104Sim/DamicG4
#### SourceDirectory path to compile and run in the docker image
export DAMIC_RUN_DIR=/home/damicmuser/RunDirectory/
#### RunDirectory path to the simulation code in the docker image
export DAMIC_CODE_DIR=/home/damicmuser/G4104Sim/DamicG4

cd $DAMIC_RUN_DIR

cmake DGeant4_DIR=${G4_DIR} ${DAMIC_RUN_DIR}
sudo make install


