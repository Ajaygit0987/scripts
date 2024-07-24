#!/bin/bash

#Print the Date and Time
echo "Process started at $(date '+%Y-%m-%d %H:%M:%S')"
previous_date=$(date -d "yesterday" '+%Y-%m-%d')

gateway_mount_dir="/efs/cloud-gateway-pvc-32894bf4-692a-4681-8841-fe39146c5206"

echo "Started zipping the files"

for app_dir in ${gateway_mount_dir}/cloud-gateway-*; do
    echo "----------------------------------------"
    echo "Processing directory: ${app_dir}"
    echo "----------------------------------------"

    [[ -d "${app_dir}" ]] || { echo "Directory ${app_dir} does not exist"; continue; }
    
    base_name=$(basename "${app_dir}")
    zip_file="${app_dir}/${base_name}_${previous_date}.zip"
    
    zipped=false
    
    # Zip the previous day's folder if it exists
    if [[ -d "${app_dir}/${previous_date}" ]]; then
        echo "Zipping folder ${app_dir}/${previous_date} into ${zip_file}"
        zip -r "${zip_file}" "${app_dir}/${previous_date}"
        zipped=true
    fi
    
    # Check if cloud-gateway.log file modification date matches previous day and zip it
    gateway_log="${app_dir}/cloud-gateway.log"
    if [[ -f "${gateway_log}" && "$(date -r ${gateway_log} '+%Y-%m-%d')" == "${previous_date}" ]]; then
        if [[ $zipped == false ]]; then
            echo "Creating zip file ${zip_file} for cloud-gateway.log"
            zip "${zip_file}" "${gateway_log}"
        else
            echo "Adding ${gateway_log} to zip ${zip_file}"
            zip -ur "${zip_file}" "${gateway_log}"
        fi
    fi

    # Upload the zip file to S3 if it was created
    if [[ -f "${zip_file}" ]]; then
        echo "Uploading ${zip_file} to S3"
        aws s3 cp "${zip_file}" s3://inspirenetz-eks/logs/credeze-prod/cloud-gateway/
    else
        echo "No previous day data found for ${app_dir}"
    fi
    
    echo "Finished processing ${app_dir}"
    echo "----------------------------------------"
    echo ""

    # Add a short delay between processing directories
    sleep 1
done

echo "Zipping and uploading completed"
