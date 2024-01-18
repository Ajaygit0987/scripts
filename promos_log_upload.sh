#!/bin/bash

# Command Print the Date and Time
echo "process is started"
echo "$(date '+%Y-%m-%d %H:%M:%S')"

# Command 1: Zip log files
echo "Started to zipping the files"
for dir in /opt/in-services/promos/logs/promos/ip-10-31-0-49.ap-south-1.compute.internal/*-*-*; do
    find "$dir" -type f -not -name '*.zip' -exec zip -r "$dir.zip" {} +
done
echo "zipping the files is completed"

# Command 2: Send zip files to AWS S3
echo "Started uploading the files to s3"
for zip_file in /opt/in-services/promos/logs/promos/ip-10-31-0-49.ap-south-1.compute.internal/*-*-*.zip;
    do aws s3 cp "$zip_file" s3://adl-logs-test/adl-dev/promos/;
done
echo "completed of uploading the files to s3 "

# Command 3: Remove the log directory
 sudo find /opt/in-services/promos/logs/promos/ip-10-31-0-49.ap-south-1.compute.internal/ -mindepth 1 -maxdepth 1 -type d -exec sudo rm -r {} \;
echo "original log files are removed"

#Command 4: Removing zip file older than 15 days
 cd /opt/in-services/promos/logs/promos/ip-10-31-0-49.ap-south-1.compute.internal/
 pwd
 ls -1 | head -n -15 | xargs rm
echo "zipped files are removed keeping the last 15 days file"
    
# Command 5: To print the Date and Time
echo "process is completed"
echo "$(date '+%Y-%m-%d %H:%M:%S')"
