source /home/appuser/.bash_profile

PG_INSTALLATION_PATH='/bin'
##AMBEST_RATING_PASSWORD=$(echo -n $AMBEST_RATING_PASSWORD | base64 -d)

PG_GCMP_DB_PASSWORD=$(echo -n $PG_GCMP_DB_PASSWORD | base64 -d)
export PGPASSWORD=$PG_GCMP_DB_PASSWORD


in_sPassword_field=in_sPassword
in_nDeliveryId_field=in_nDeliveryId
in_data_start_date_field=in_data_start_date
in_data_end_date_field=in_data_end_date
in_job_id_field=in_job_id
in_current_date_time_field=in_current_date_time
in_dummy_header_field=in_dummy_header

$PG_INSTALLATION_PATH/psql -h $PG_GCMP_SERVER_NAME -d $PG_GCMP_DB -U $PG_GCMP_DB_USER_ID -p $PG_GCMP_PORT -c "\copy ( select date( data_begin_datetime )||'T'
||case when EXTRACT(hour from  data_begin_datetime )<10 then '0'||EXTRACT(hour from  data_begin_datetime ) else 
cast (EXTRACT(hour from  data_begin_datetime ) as character varying(50) ) end
||':'|| case when EXTRACT(minute from  data_begin_datetime )<10 then '0'||EXTRACT(minute from  data_begin_datetime ) else 
 cast (  EXTRACT(minute from  data_begin_datetime ) as character varying(50) ) end
||':'|| case when EXTRACT(second from  data_begin_datetime )<10 then '0'|| trunc( EXTRACT(second from  data_begin_datetime ) )
else cast ( trunc(EXTRACT(second from  data_begin_datetime )) as character varying(50) ) end 
||'.'||case when substring ( cast( data_begin_datetime as character varying(100)  )  , 21,4)='' then '000'
else substring ( cast( data_begin_datetime as character varying(100)  )  , 21,4) end
||'-04:00'  as in_data_start_date
, date( data_end_datetime )||'T'
||case when EXTRACT(hour from  data_end_datetime )<10 then '0'||EXTRACT(hour from  data_end_datetime ) else 
cast (EXTRACT(hour from  data_end_datetime ) as character varying(50) ) end
||':'|| case when EXTRACT(minute from  data_end_datetime )<10 then '0'||EXTRACT(minute from  data_end_datetime ) else 
 cast (  EXTRACT(minute from  data_end_datetime ) as character varying(50) ) end
||':'|| case when EXTRACT(second from  data_end_datetime )<10 then '0'|| trunc( EXTRACT(second from  data_end_datetime ) )
else cast ( trunc(EXTRACT(second from  data_end_datetime )) as character varying(50) ) end 
||'.'||case when substring ( cast( now() as character varying(100)  )  , 21,3)='' then '000' else 
substring ( cast( now() as character varying(100)  )  , 21,3) end
||'-04:00' as in_data_end_date
,Job_Id
,now() as current_date_time
from  iics.di_job_metadata where job_status='InProgress' 
and job_id In (select max(job_id) from iics.di_job_metadata where application_name in (select application_name from iics.rating_type where ratingtype_Id=1) 
and job_status='InProgress'  )   ) to '$RATING_PATH/ambest_input_param_dates.txt' DELIMITER '|'  " &> $RATING_PATH/ambest_input_param_dates.log;

while IFS='|' read in_data_start_date in_data_end_date job_id current_date_time;do


in_data_start_date_value=$in_data_start_date
in_data_end_date_value=$in_data_end_date
job_id_value=$job_id
current_date_time_value=$current_date_time

done <$RATING_PATH/ambest_input_param_dates.txt

echo $in_sPassword_field','$in_nDeliveryId_field','$in_data_start_date_field','$in_data_end_date_field','$in_job_id_field','$in_current_date_time_field','$in_dummy_header_field > $RATING_PATH/ambest_input_param.txt
echo $AMBEST_RATING_PASSWORD','$AMBEST_RATING_USERID','$in_data_start_date_value','$in_data_end_date_value','$job_id_value','$current_date_time_value',' >> $RATING_PATH/ambest_input_param.txt