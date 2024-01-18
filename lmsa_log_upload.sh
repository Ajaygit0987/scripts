#!/bin/bash

#Command to print Date and Time
echo "process is started"
echo "$(date '+%Y-%m-%d %H:%M:%S')"

# Command 1: Zip log files
echo "Started to zipping the files"
for file in /opt/apache-tomcat-8.5.97/bin/logs/inspirenetz-api.*-*-*.log; do
    zip -r "${file%.*}.zip" "$file"
done
echo "zipping the files is completed"


# Command 2: Upload zipped logs to AWS S3
echo "Started uploading the files to s3"
for zip_file in /opt/apache-tomcat-8.5.97/bin/logs/inspirenetz-api.*-*-*.zip; do
    aws s3 cp "$zip_file" s3://adl-logs-test/adl-dev/lmsa/
done
echo "completed of uploading the files to s3 "

# Command 3: Remove log files 
sudo rm /opt/apache-tomcat-8.5.97/bin/logs/inspirenetz-api.*-*-*.log
echo "original log files are removed"

# Command 4: Deleting the zip files  except last 15 days
cd /opt/apache-tomcat-8.5.97/bin/logs/
pwd 
ls -1 | head -n -15 | xargs rm
echo "zipped files are removed keeping the last 15 days file"

#Command 5: To print Date and Time
echo "process is completed"
echo "$(date '+%Y-%m-%d %H:%M:%S')" 
