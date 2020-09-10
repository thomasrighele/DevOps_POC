#!/bin/bash
#---------------------------------------------------------------------
# Script Name:                          non_trading_partner_failed_notification.sh
# Written By:                           Guycarpenter
# Date:                                     29/08/2019
# Description:                          This script will notify rating related validations and errors.
#---------------------------------------------------------------------


IICS_SERVER=`hostname`
Mail_Sender='iics@'

####Finding appropriate Environment based on Info Server ###############
PG_INSTALLATION_PATH='/bin'

if [[ ${IICS_SERVER} = 'usdf24v0171' ]]; then

#IICS_SERVER='usdf24v0171'
IICS_SERVER='Dev-SIT'
Mail_Sender+=$IICS_SERVER
RECIPIENTS="Nirav.Savani@guycarp.com,Mahipal.Ramidi@guycarp.com"

elif [[ $IICS_SERVER = 'usdf24v0183' ]]; then

#IICS_SERVER='usdf24v0183'
IICS_SERVER='Dev-SIT'
Mail_Sender+=$IICS_SERVER
RECIPIENTS="Nirav.Savani@guycarp.com,Mahipal.Ramidi@guycarp.com"


elif [[ $IICS_SERVER = 'usdf25v0176' ]]; then

#IICS_SERVER='usdf25v0176'
IICS_SERVER='QA-PPD'
Mail_Sender+=$IICS_SERVER
RECIPIENTS="Nirav.Savani@guycarp.com,Mahipal.Ramidi@guycarp.com,vinay.saxena@guycarp.com,sagar.gode@guycarp.com,suman.kumar@guycarp.com"


elif [[ $IICS_SERVER = 'usdf25v0177' ]]; then

#IICS_SERVER='usdf25v0177'
IICS_SERVER='QA-PPD'
Mail_Sender+=$IICS_SERVER
RECIPIENTS="Nirav.Savani@guycarp.com,Mahipal.Ramidi@guycarp.com,vinay.saxena@guycarp.com,sagar.gode@guycarp.com,suman.kumar@guycarp.com"

elif [[ $IICS_SERVER = 'USFKL21AS518V' ]]; then

#IICS_SERVER='USFKL21AS518V'
IICS_SERVER='Prod'
Mail_Sender+=$IICS_SERVER
RECIPIENTS="Nirav.Savani@guycarp.com,Mahipal.Ramidi@guycarp.com"

elif [[ $IICS_SERVER = 'USFKL21AS519V' ]]; then

#IICS_SERVER='USFKL21AS519V'
IICS_SERVER='Prod'
Mail_Sender+=$IICS_SERVER
RECIPIENTS="Nirav.Savani@guycarp.com,Mahipal.Ramidi@guycarp.com"

fi

source /home/appuser/.bash_profile

######## Notifying E-mail about the Non Trading Partenr failed job ##################  
echo "Non trading partenr ratings dataload failed at:`date`" | mailx -r "${Mail_Sender}" -s "Non trading partenr ratings dataload failed in  ${IICS_SERVER}" "${RECIPIENTS}"