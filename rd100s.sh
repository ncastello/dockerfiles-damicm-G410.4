#!/bin/bash

###########################################################
#####   DAMIC@SNOLAB SIMULATION CODE INSTALATION
###########################################################

mkdir /home/damicmuser/RunDirectory/
cd /home/damicmuser/RunDirectory/

cmake DGeant4_DIR=/opt/geant4-10-build ${DAMICM_SIM_ROOT}
sudo make install


