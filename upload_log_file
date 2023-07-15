#!/bin/bash

# Specify the base directory path
base_directory="/root/sample/script-02/log"

# Specify the Amazon S3 bucket details
bucket_name="sample-test-0101"

# Specify the path to store the zip files
output_directory="/root/sample/script-02/log"

# Function to zip a file
zip_file() {
    file_path="$1"
    file_name=$(basename "$file_path")
    zip_filename="${file_name%.*}.zip"
    zip_path="$output_directory/$zip_filename"

    # Create a zip file for the file
    zip "$zip_path" "$file_path"

    # Upload the zip file to Amazon S3
    s3_key="$zip_filename"
    aws s3 cp "$zip_path" "s3://$bucket_name/$s3_key"
    echo "Uploaded $zip_filename to S3 bucket $bucket_name with key: $s3_key"
}

# Get the list of log files sorted by modification time (oldest to newest)
log_files=$(find "$base_directory" -type f -name "*.log" -printf "%T@ %p\n" | sort -n | cut -d' ' -f2-)

# Count the number of log files
count=$(echo "$log_files" | wc -l)

# Zip and upload all but the last two log files
current_count=0
for log_file in $log_files; do
    if [ $current_count -lt $((count-2)) ]; then
        zip_file "$log_file"
        rm "$log_file"
        rm "${log_file%.*}.zip"
    fi
    current_count=$((current_count+1))
done

# Remove all log files except the last two files
ls -t "$base_directory"/*.log 2>/dev/null | tail -n +3 | xargs rm -f

# Remove all zip files except the last two files
zip_files_count=$(ls -t "$output_directory"/*.zip 2>/dev/null | wc -l)
if [ $zip_files_count -gt 2 ]; then
    ls -t "$output_directory"/*.zip 2>/dev/null | tail -n +3 | xargs rm -f
fi
