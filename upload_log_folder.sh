#!/bin/bash

# Specify the base directory path to zip
base_directory="/root/sample/script-01/log"

# Specify the Amazon S3 bucket details
bucket_name="sample-test-0101/logs"

# Specify the path to store the zip files outside the directories
output_directory="/root/sample/script-01/log"

# Function to zip a directory
zip_directory() {
    directory_path="$1"
    directory_name=$(basename "$directory_path")
    zip_filename="$directory_name.zip"
    zip_path="$output_directory/$zip_filename"

    # Create a zip file for the directory
    cd "$directory_path" || exit
    zip -r "$zip_path" .

    # Upload the zip file to Amazon S3
    s3_key="$zip_filename"
    aws s3 cp "$zip_path" "s3://$bucket_name/$s3_key"
    echo "Uploaded $zip_filename to S3 bucket $bucket_name with key: $s3_key"

    # Change back to the original working directory
    cd - || exit
}

# Declare variables to keep track of the last created directory and zip file
last_directory=""
last_zip_path=""

# Iterate over each subdirectory within the base directory
for directory in "$base_directory"/*; do
    if [ -d "$directory" ]; then
        last_directory="$directory"
        zip_directory "$directory"
        last_zip_path="$output_directory/$(basename "$directory").zip"
    fi
done

# Remove all zip files and directories except the last created directory
for directory in "$base_directory"/*; do
    if [ -d "$directory" ] && [ "$directory" != "$last_directory" ]; then
        rm -r "$directory"
        zip_path="$output_directory/$(basename "$directory").zip"
        rm "$zip_path"
        echo "Removed directory: $directory"
        echo "Removed zip file: $zip_path"
    fi
done

# Remove the zip file of the last created directory
if [ -n "$last_zip_path" ]; then
    rm "$last_zip_path"
    echo "Removed the zip file for the last created directory: $last_zip_path"
fi
