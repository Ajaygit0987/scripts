#!/bin/bash
# Command 1: Zip log files
for file in /root/sample/script-03/script-02/log/inspirenetz-api.2023-*-*.log; do
    zip -r "${file%.*}.zip" "$file"
done

# Command 2: Upload zipped logs to AWS S3
for zip_file in /root/sample/script-03/script-02/log/inspirenetz-api.2023-*-*.zip; do
    aws s3 cp "$zip_file" s3://sample-test-0101/logs/
done

# Command 3: Remove log files and zip files
sudo rm /root/sample/script-03/script-02/log/inspirenetz-api.2023-*-*.log

echo "Press 1 for deletion or press 0 for not deletion of zip file"
read a
if [ $a -eq 1 ]
then
       echo "enter the month u want delete"
     read m
  sudo rm /root/sample/script-03/script-02/log/inspirenetz-api.2023-$m-*.zip
  echo "Zip files are deleted"
fi
