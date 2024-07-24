#!/bin/bash

# Command Print the Date and Time
echo "process is started"
echo "$(date '+%Y-%m-%d %H:%M:%S')"
current_date=$(date "+%Y-%m-%d")

# Command 1: Zip log files
echo "Started to zipping the files"
for dir in /opt/in-service/promos/logs/promos/ip-10-33-1-17.ap-south-1.compute.internal/*-*-*; do
    find "$dir" -type d -not -name "$current_date" -exec zip -r "$dir.zip" {} +
done
echo "zipping the files is completed"

# Command 2: Send zip files to AWS S3
echo "Started uploading the files to s3"
for zip_file in /opt/in-service/promos/logs/promos/ip-10-33-1-17.ap-south-1.compute.internal/*-*-*.zip; 
    do aws s3 cp "$zip_file" s3://inspz-app-logs/coreset-logs/adl-prod-coreset-03/promos/; 
done
#echo "completed of uploading the files to s3 "

# Command 3: Remove the log directory
 sudo find /opt/in-service/promos/logs/promos/ip-10-33-1-17.ap-south-1.compute.internal/ -mindepth 1 -maxdepth 1 -type d | sort | head -n -1 | xargs sudo rm -r
echo "original log files are removed"

#Command 4: Removing zip file older than 20 days
 cd /opt/in-service/promos/logs/promos/ip-10-33-1-17.ap-south-1.compute.internal/
 pwd 
 ls -1 | head -n -20 | xargs rm
echo "zipped files are removed keeping the last 30 days file"

# Command 5: To print the Date and Time
sync; echo 3 > /proc/sys/vm/drop_caches
echo "process is completed"
echo "$(date '+%Y-%m-%d %H:%M:%S')"
