#!/bin/bash

# Specify the base directory path
base_directory="/root/sample/script-02/log"

# Specify the Amazon S3 bucket details
bucket_name="sample-test-0101/logs"

# Specify the AWS CLI binary path
aws_cli="/usr/local/bin/aws"

# Function to zip a file
zip_file() {
    file_path="$1"
    file_name=$(basename "$file_path")
    zip_filename="${file_name%.*}.zip"
    zip_path="/tmp/$zip_filename"  # Store the zip file temporarily in /tmp directory

    # Create a zip file for the file (without the directory structure)
    zip -j "$zip_path" "$file_path"

    # Upload the zip file to Amazon S3
    "$aws_cli" s3 cp "$zip_path" "s3://$bucket_name/"
    echo "Uploaded $zip_filename to S3 bucket $bucket_name"

    # Remove the temporary zip file
    rm "$zip_path"
}

# Check if the AWS CLI is installed at the specified path
if [ ! -x "$aws_cli" ]; then
    echo "AWS CLI is not installed. Please install it at $aws_cli and configure AWS credentials."
    exit 1
fi

# Change to the base directory to ensure relative paths work correctly
cd "$base_directory" || exit

# Zip and upload log files, keeping the last two
log_files=$(find . -maxdepth 1 -type f -name "*.log" -printf "%T@ %p\n" | sort -n | cut -d' ' -f2-)

total_logs=$(echo "$log_files" | wc -l)
count=0

echo "$log_files" | while IFS= read -r log_file; do
    if [ $count -lt $((total_logs - 2)) ]; then
        zip_file "$log_file"
        rm "$log_file"
    fi
    count=$((count + 1))
done

# Remove all zip files except the last two files
zip_files=$(find /tmp -maxdepth 1 -type f -name "*.zip" -printf "%T@ %p\n" | sort -n | cut -d' ' -f2-)

total_zips=$(echo "$zip_files" | wc -l)
count=0

echo "$zip_files" | while IFS= read -r zip_file; do
    if [ $count -lt $((total_zips - 2)) ]; then
        rm "$zip_file"
    fi
    count=$((count + 1))
done
