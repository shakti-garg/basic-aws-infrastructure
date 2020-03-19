#!/bin/bash

set -x

echo ${aws_region}
echo ${metadata_db_password_parameter}
echo ${metadata_db_endpoint}

#install gcc
sudo yum -y groupinstall "Development Tools"

#install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && sudo python get-pip.py

#install airflow
sudo pip install virtualenv

virtualenv ~/airflow_venv\
  && source ~/airflow_venv/bin/activate \

pip install psycopg2-binary apache-airflow

export AWS_DEFAULT_REGION=${aws_region}
metadata_db_password="$(aws ssm get-parameters \
                        --names ${metadata_db_password_parameter} \
                        --with-decryption \
                        --output text \
                        --query 'Parameters[0].Value')"


export AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql://airflow:"$metadata_db_password"@"${metadata_db_endpoint}"/airflow?sslmode=require"


source ~/airflow_venv/bin/activate

airflow initdb

airflow webserver -D
airflow scheduler -D