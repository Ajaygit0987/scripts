#!/bin/bash

log_dir="/root/sample/script-03/script-02/log"
aws_s3_bucket="sample-test-0101/sample/"

 ls -d -t "$log_dir"/2023-*-* | grep -v "promos\.log$" | head -n -1
# ls -d -t /root/sample/script-03/script-02/log/2023-*-* |grep -v "promos\.log$"
echo "press 1 to proceed OR 0 to exist"
read input
    if [ $input -eq 1 ];
    then
           # Command 1: Zip log directories
           echo "Zipping log directories..."
           for dir in $(ls -d -t "$log_dir"/2023-*-* | grep -v "promos\.log$" | head -n -1); do
           if [ -d "$dir" ]; then
            zip -r "$dir.zip" "$dir"
           fi
           done
           echo "Log directories zipped."

          # Command 2: Upload zipped logs to AWS S3
           echo "Uploading zipped logs to AWS S3..."
           for zip_file in "$log_dir"/2023-*-*.zip; do
           aws s3 cp "$zip_file"  "s3://$aws_s3_bucket"
           done
           echo "Zipped logs uploaded."

          # Command 3: Remove log directories
          echo "Removing log directories..."
          sudo find "$log_dir" -mindepth 1 -maxdepth 1 -type d -name "2023-*-*" -print | sort | head -n -1 | xargs -I {} rm -rf {}

          echo "Log directories removed."

          # Command 4: Ask for deletion of specific zip files
          echo "Press 1 to delete specific zip files based on month, or press 0 to skip."
          read choice
          if [ "$choice" -eq 1 ]; then
             echo "Enter the month you want to delete (e.g., 01, 02, ..., 12):"
             read month
             sudo rm "$log_dir"/2023-$month-*.zip
             echo "Zip files for month $month are deleted."
           else
           echo "Zip files are not  deleted."

          fi
     else
         echo " exited"
     fi
