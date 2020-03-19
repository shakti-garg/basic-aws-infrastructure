#install gcc
sudo yum -y groupinstall "Development Tools"

#install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && sudo python get-pip.py

#install airflow
sudo pip install virtualenv

virtualenv airflow_venv \
  && source ~/airflow_venv/bin/activate \
  && pip install psycopg2-binary apache-airflow

# Install cloud watch agent prerequirement
sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
unzip CloudWatchMonitoringScripts-1.2.2.zip && \
rm CloudWatchMonitoringScripts-1.2.2.zip && \
(crontab -l 2>/dev/null; echo "*/5 * * * * ~/aws-scripts-mon/mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --mem-used --mem-avail --disk-space-used --disk-space-avail --disk-space-util --disk-path=/ --from-cron") | crontab -
