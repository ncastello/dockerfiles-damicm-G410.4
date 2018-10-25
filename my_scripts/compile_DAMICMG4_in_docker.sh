#!/bin/bash

export SRC_DIRECTORY=/home/damicmuser/G4104Source/DAMICMSims/DamicG4/
export BIN_DIRECTORY=/home/damicmuser/G4104Run/build
export PATH=/home/damicmuser/G4104Run/build:${PATH}
export PATH=/home/damicmuser/scripts:${PATH}


cd $BIN_DIRECTORY

cmake $SRC_DIRECTORY
sudo make install

cd /home/damicmuser/G4104Run

echo ""
echo ""
echo -e "\e[1m####################################################################################################\e[m"
echo -e "\e[1m##########        ######       ###     ###    ###  ######  #######       ###    ###       ##########\e[m"
echo -e "\e[1m##########        ##   ##     ## ##    ###    ###    ##    ##            ###    ###       ##########\e[m"
echo -e "\e[1m##########        ##    ##   ##   ##   # ##  ## #    ##    ##       ###  # ##  ## #       ##########\e[m"
echo -e "\e[1m##########        ##    ##  ## ### ##  ##  ### ##    ##    ##       ###  ##  ### ##       ##########\e[m"
echo -e "\e[1m##########        ##   ##  ##       ## ##      ##    ##    ##            ##      ##       ##########\e[m"
echo -e "\e[1m##########        ######   ##       ## ##      ##  ######  #######       ##      ##       ##########\e[m"
echo -e "\e[1m####################################################################################################\e[m"
echo "                                                              "; date
echo -e "\e[1m      DAMICM is ready to run!     \e[m"
echo ""

export CHAIN_SIM_SCRIPTS_DIR=/home/damicmuser/G4104Source/DAMICMSims/scripts
echo ""
echo -e "\e[2m  simulation chain scripts PATH: $CHAIN_SIM_SCRIPTS_DIR \e[m"
echo ""



echo ""
echo ""


