#!/bin/bash
#---------------------------------------------------------------------
# Script Name:                          snp_failed_notification.sh
# Written By:                           Guycarpenter
# Date:                                 29/08/2019
# Description:                          This scritp will notify rating realted validations and errors.
#---------------------------------------------------------------------


IICS_SERVER=`hostname`
Mail_Sender='iics@'

####Finding approprite Environment based on Info Server ###############

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
RECIPIENTS="Nirav.Savani@guycarp.com,Mahipal.Ramidi@guycarp.com"


elif [[ $IICS_SERVER = 'usdf25v0177' ]]; then

#IICS_SERVER='usdf25v0177'
IICS_SERVER='QA-PPD'
Mail_Sender+=$IICS_SERVER
RECIPIENTS="Nirav.Savani@guycarp.com,Mahipal.Ramidi@guycarp.com"

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

AMBEST_RATING_PASSWORD=$(echo -n $PG_GCMP_DB_PASSWORD | base64 -d)

PG_GCMP_DB_PASSWORD=$(echo -n $PG_GCMP_DB_PASSWORD | base64 -d)
export PGPASSWORD=$PG_GCMP_DB_PASSWORD

############ Removing files which were created in the previous run ################

if [ -f $$snp_jobid.txt ] ; then

    rm $snp_jobid.txt.txt
fi


####################Reading the SNP failed job#########################

$PG_INSTALLATION_PATH/psql -h $PG_GCMP_SERVER_NAME -d $PG_GCMP_DB -U $PG_GCMP_DB_USER_ID -p $PG_GCMP_PORT -c "\copy (
  select max(job_id) as job_id from iics.di_job_metadata where lower(job_status)='inprogress'  and  application_name in (select application_name from iics.rating_type where ratingtype_Id=2)  
)  to '$RATING_PATH/snp_jobid.txt' DELIMITER '|'  " &> $RATING_PATH/snp_jobid.log;


while IFS='|' read job_id;do 

JOBID=$job_id

done <$RATING_PATH/snp_jobid.txt


######## Notifying E-mail about the S&P failed job ##################  
echo "S&P ratings feed dataload failed(Job_ID:$JOBID ) at:`date`" | mailx -r "${Mail_Sender}" -s "S&P ratings feed dataload failed in  ${IICS_SERVER}" "${RECIPIENTS}"