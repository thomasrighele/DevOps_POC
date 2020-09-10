source /home/appuser/.bash_profile

PG_INSTALLATION_PATH='/bin'

AMBEST_RATING_PASSWORD=$(echo -n $PG_GCMP_DB_PASSWORD | base64 -d)

PG_GCMP_DB_PASSWORD=$(echo -n $PG_GCMP_DB_PASSWORD | base64 -d)
export PGPASSWORD=$PG_GCMP_DB_PASSWORD


$PG_INSTALLATION_PATH/psql -h $PG_GCMP_SERVER_NAME -d $PG_GCMP_DB -U $PG_GCMP_DB_USER_ID -p $PG_GCMP_PORT -c "select iics.ambest_ratings ()" &> /opt/apps/rating/ambest_function.log;