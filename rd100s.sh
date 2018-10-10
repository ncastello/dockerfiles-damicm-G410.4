#!/bin/bash

###########################################################
#####   DAMIC@SNOLAB SIMULATION CODE INSTALATION
###########################################################

echo "\e[1m Defining environment variables:\e[m"
#### directory path to the geant4 instalation in the docker image
export G4_DIR=/home/damicmuser/G4104Sim/DamicG4
echo "\e[1m   G4_DIR    pointing to $G4_DIR\e[m"
#### SourceDirectory path to compile and run in the docker image
export DAMIC_RUN_DIR=/home/damicmuser/RunDirectory/
echo "\e[1m   DAMIC_RUN_DIR    pointing to $GDAMIC_RUN_DIR\e[m"

#### RunDirectory path to the simulation code in the docker image
export DAMIC_CODE_DIR=/home/damicmuser/G4104Sim/DamicG4
echo "\e1[m   DAMIC_CODE_DIR    pointing to $DAMIC_CODE_DIR\e[m"


cd $DAMIC_RUN_DIR

cmake DGeant4_DIR=${G4_DIR} ${DAMIC_CODE_DIR}
sudo make install

echo "############################################################################"
echo "##########        ######  ######  ###    ###                      ##########"
echo "##########        ##        ##    ## #  # ##                      ##########"
echo "##########        ######    ##    ##  ##  ##                      ##########"
echo "##########            ##    ##    ##      ##                      ##########"
echo "##########        ######  ######  ##      ##                      ##########"
echo "############################################################################"
echo ""
echo ""
echo ""
echo ""

