#!/bin/bash

# Define the process name
process_name="strapi"

# Check if the process is running
if ps aux | grep -q "[${process_name:0:1}]${process_name:1}"; then
    echo "Process $process_name is running."
else
    echo "Process $process_name is not running. Sending email."

    # Define the email details
    recipient="ajay24in7@gmail.com"
    subject="Process $process_name is not running"
    body="Process $process_name is not running. Please investigate."

    # Send the email using the 'mail' command (ensure the 'mailutils' package is installed)
    echo "$body" | mail -s "$subject" "$recipient"
fi
