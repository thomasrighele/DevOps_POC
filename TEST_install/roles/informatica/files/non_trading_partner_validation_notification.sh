#!/bin/bash
#---------------------------------------------------------------------
# Script Name:                          non_trading_partner_rating_validation.sh
# Written By:                           Guycarpenter
# Date:                                     29/08/2019
# Description:                          This script will notify rating related validations and errors.
#---------------------------------------------------------------------

IICS_SERVER=`hostname`
Mail_Sender='iics@'

####Finding appropriate Environment based on Info Server ###############

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

PG_INSTALLATION_PATH='/bin'
AMBEST_RATING_PASSWORD=$(echo -n $PG_GCMP_DB_PASSWORD | base64 -d)

PG_GCMP_DB_PASSWORD=$(echo -n $PG_GCMP_DB_PASSWORD | base64 -d)
export PGPASSWORD=$PG_GCMP_DB_PASSWORD

############ Removing files which were created in the previous run ################

if [ -f $$RATING_PATH/non_trading_ratings_validations_data.txt ] ; then

    rm $RATING_PATH/non_trading_ratings_validations_data.txt
fi

if [ -f $$RATING_PATH/non_trading_ratings_validations.txt ] ; then

    rm $RATING_PATH/non_trading_ratings_validations.txt
fi

if [ -f $$RATING_PATH/non_trading_ratings_error.txt ] ; then

    rm $RATING_PATH/non_trading_ratings_error.txt
fi

#############Setting the header values ########################

in_company_name_filed=company_name
in_company_ref_num=company_ref_num
in_attribute_name=rating_attribute_name
in_attribute_value=rating_attribute_value

first_record_flag=0

####################Reading the AMbest validation and Error Records#########################

$PG_INSTALLATION_PATH/psql -h $PG_GCMP_SERVER_NAME -d $PG_GCMP_DB -U $PG_GCMP_DB_USER_ID -p $PG_GCMP_PORT -c "\copy (  select distinct a.job_id, company_name,error_severity,b,attribute_name,attribute_value
,error_message,1 as ratingtype_id,(SELECT current_database()) as db_name
 from iics.di_exception a left outer join iics.rating_data_errors b on a.job_id=b.job_id where a.job_id in 
(select job_id from iics.di_job_metadata where application_name in (select application_name from iics.rating_type where ratingtype_Id in (1,2) )
 and  job_status='Completed' and job_id in (select distinct job_id from iics.non_trading_partner_ratings where trading_partner_flag=1 ) ) and b.email_flag='N'  )  to '$RATING_PATH/non_trading_ratings_validations_data.txt' DELIMITER '|'  " &> $RATING_PATH/non_trading_ratings_validations_error.log;


while IFS='|' read job_id company_name error_severity company_ref_num attribute_name attribute_value error_message ratingtype_id db_name;do

################# Createing the AMbest validation file with proper headers############################

if [[ $ratingtype_id == 1 && $first_record_flag == 0 ]]; then

echo $in_company_name_filed','$in_company_ref_num','$in_attribute_name','$in_attribute_value > $RATING_PATH/non_trading_ratings_validations.txt

first_record_flag=1
job_id_to_update=$job_id

fi

##############AMBsest validateion failure recored capture ########################################

if [[ $error_severity == 1 ]]; then

echo $company_name','$company_ref_num','$attribute_name','$attribute_value >> $RATING_PATH/non_trading_ratings_validations.txt
non_trading_ratings_validation_flag=1

fi

###################AMBest error capcture ####################

if [[ $error_severity == 2 ]]; then

echo AMBest Task flow Error:$error_message > $RATING_PATH/non_trading_ratings_error.txt
non_trading_ratings_error_flag=1

fi


if [[ $job_id_to_update !=  '' ]]; then

##################Updating the Status ########################

$PG_INSTALLATION_PATH/psql -h $PG_GCMP_SERVER_NAME -d $PG_GCMP_DB -U $PG_GCMP_DB_USER_ID -p $PG_GCMP_PORT -c "  update iics.rating_data_errors set email_flag='Y'  where job_id=$job_id_to_update " &> $RATING_PATH/non_trading_ratings_notificaton_status_update.log;

fi

done <$RATING_PATH/non_trading_ratings_validations_data.txt

if [[ $non_trading_ratings_validation_flag == 1 ]]; then

######## Notifying E-mail about the list of  new rating attribute values recieved from AMBest & SNP ##################  
echo "Attached list of new rating attributes values received from AMBest and S&P feed at:`date`" | mailx -r "${Mail_Sender}" -s "New rating attribute values received from AMbest and S&P feed in ${IICS_SERVER}" -a $RATING_PATH/non_trading_ratings_validations.txt ${RECIPIENTS}

fi

if [[ $non_trading_ratings_error_flag == 1 ]]; then

######## Notifying E-mail about the Non trading Taskflow error ##################  
echo "Non trading ratings dataload failed with attached errors at:`date`" | mailx -r "${Mail_Sender}" -s "Non trading ratings dataload failed in  ${IICS_SERVER}" -a $RATING_PATH/non_trading_ratings_error.txt ${RECIPIENTS}

else

######## Notifying E-mail about the Non trading Tasflow success ##################  
echo "Non trading ratings dataload successfully completed at:`date`" | mailx -r "${Mail_Sender}" -s "Non trading ratings dataload successfully completed in  ${IICS_SERVER}" "${RECIPIENTS}"

fi